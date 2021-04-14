/*
 * Copyright Supranational LLC
 * Licensed under the Apache License, Version 2.0, see LICENSE for details.
 * SPDX-License-Identifier: Apache-2.0
 */

#include "fields.h"
#include "point.h"

/*
 * This is two-step multi-scalar multiplication procedure. First, given
 * a set of points you pre-compute a table for chosen windowing factor
 * [expressed in bits with value between 2 and 8], and then you pass
 * this table to the actual multiplication procedure along with scalars.
 * Idea is that pre-comuted table will be reused multiple times.
 */

#define PRECOMPUTE_WBITS_IMPL(ptype, bits, field, one) \
static void ptype##_precompute_row_wbits(ptype row[], size_t wbits, \
                                         const ptype##_affine *point) \
{ \
    size_t i, j, n = (size_t)1 << (wbits-1); \
                                          /* row[-1] is implicit infinity */\
    vec_copy(&row[0], point, sizeof(*point));           /* row[0]=p*1     */\
    vec_copy(&row[0].Z, one, sizeof(row[0].Z));                             \
    ptype##_double(&row[1],  &row[0]);                  /* row[1]=p*(1+1) */\
    for (i = 2, j = 1; i < n; i += 2, j++) \
        ptype##_add_affine(&row[i], &row[i-1], point),  /* row[2]=p*(2+1) */\
        ptype##_double(&row[i+1], &row[j]);             /* row[3]=p*(2+2) */\
}                                                       /* row[4] ...     */\
\
static void ptype##s_to_affine_row_wbits(ptype##_affine dst[], ptype src[], \
                                         size_t wbits, size_t npoints) \
{ \
    size_t total = npoints << (wbits-1); \
    size_t nwin = (size_t)1 << (wbits-1); \
    size_t i, j; \
    vec##bits *acc, ZZ, ZZZ; \
\
    src += total; \
    acc = (vec##bits *)src; \
    vec_copy(acc++, one, sizeof(vec##bits)); \
    for (i = 0; i < npoints; i++) \
        for (j = nwin; --src, --j; acc++)    \
            mul_##field(acc[0], acc[-1], src->Z); \
\
    --acc; reciprocal_##field(acc[0], acc[0]); \
\
    for (i = 0; i < npoints; i++) { \
        vec_copy(dst++, src++, sizeof(ptype##_affine)); \
        for (j = 1; j < nwin; j++, acc--, src++, dst++) { \
            mul_##field(acc[-1], acc[-1], acc[0]);  /* 1/Z        */\
            sqr_##field(ZZ, acc[-1]);               /* 1/Z^2      */\
            mul_##field(ZZZ, ZZ, acc[-1]);          /* 1/Z^3      */\
            mul_##field(acc[-1], src->Z, acc[0]);                   \
            mul_##field(dst->X, src->X, ZZ);        /* X = X'/Z^2 */\
            mul_##field(dst->Y, src->Y, ZZZ);       /* Y = Y'/Z^3 */\
        } \
    } \
} \
\
/* |points[n]| are customarily placed at the end of |table[n<<(wbits-1)]| */\
static void ptype##s_precompute_wbits(ptype##_affine table[], size_t wbits, \
                                      const ptype##_affine points[], \
                                      size_t npoints) \
{ \
    size_t total = npoints << (wbits-1); \
    size_t nwin = (size_t)1 << (wbits-1); \
    size_t nmin = (size_t)1 << (9-wbits); \
    size_t i, top = 0; \
    ptype *rows, *row; \
    size_t stride = ((512*1024)/sizeof(ptype##_affine)) >> wbits; \
    if (stride == 0) stride = 1; \
\
    while (npoints >= nmin) { \
        size_t limit = total - npoints; \
\
        if (top + (stride << wbits) > limit) { \
            stride = (limit - top) >> wbits;   \
            if (stride == 0) break;            \
        } \
        rows = row = (ptype *)(&table[top]); \
        for (i = 0; i < stride; i++, row += nwin) \
            ptype##_precompute_row_wbits(row, wbits, points++); \
        ptype##s_to_affine_row_wbits(&table[top], rows, wbits, stride); \
        top += stride << (wbits-1); \
        npoints -= stride; \
    } \
    rows = row = alloca(2*sizeof(ptype##_affine) * npoints * nwin); \
    for (i = 0; i < npoints; i++, row += nwin) \
        ptype##_precompute_row_wbits(row, wbits, points++); \
    ptype##s_to_affine_row_wbits(&table[top], rows, wbits, npoints); \
}

#define MULT_SCALAR_WBITS_IMPL(ptype, bits, field, one) \
static void ptype##_gather_booth_wbits(ptype *p, const ptype##_affine row[], \
                                       size_t wbits, limb_t booth_idx) \
{ \
    bool_t booth_sign = (booth_idx >> wbits) & 1; \
    bool_t idx_is_zero; \
    static const ptype##_affine infinity; \
\
    booth_idx &= ((limb_t)1 << wbits) - 1; \
    idx_is_zero = is_zero(booth_idx); \
    booth_idx -= 1 ^ idx_is_zero; \
    vec_select(p, &infinity, &row[booth_idx], sizeof(row[0]), idx_is_zero); \
    ptype##_cneg(p, booth_sign); \
} \
\
static void ptype##s_mult_wbits(ptype *ret, const ptype##_affine table[], \
                                size_t wbits, size_t npoints, \
                                const byte *scalars[], size_t nbits, \
                                ptype scratch[]) \
{ \
    limb_t wmask, wval; \
    size_t i, j, window, nwin = (size_t)1 << (wbits-1); \
    const ptype##_affine *row = table; \
\
    /* top excess bits modulo target window size */ \
    window = nbits % wbits; /* yes, it may be zero */ \
    wmask = ((limb_t)1 << (window + 1)) - 1; \
\
    nbits -= window; \
    if (nbits > 0) \
        wval = get_wval(scalars[0], nbits - 1, window + 1) & wmask; \
    else \
        wval = (scalars[0][0] << 1) & wmask; \
\
    wval = booth_encode(wval, wbits); \
    ptype##_gather_booth_wbits(&scratch[0], row, wbits, wval); \
    row += nwin; \
\
    i = 1; vec_zero(ret, sizeof(*ret)); \
    while (nbits > 0) { \
        for (; i < npoints; i++, row += nwin) { \
            wval = get_wval(scalars[i], nbits - 1, window + 1) & wmask; \
            wval = booth_encode(wval, wbits); \
            ptype##_gather_booth_wbits(&scratch[i], row, wbits, wval); \
        } \
        ptype##s_accumulate(ret, scratch, npoints); \
\
        for (j = 0; j < wbits; j++) \
            ptype##_double(ret, ret); \
\
        window = wbits; \
        wmask = ((limb_t)1 << (window + 1)) - 1; \
        nbits -= window; \
        i = 0; row = table; \
    } \
\
    for (; i < npoints; i++, row += nwin) { \
        wval = (scalars[i][0] << 1) & wmask; \
        wval = booth_encode(wval, wbits); \
        ptype##_gather_booth_wbits(&scratch[i], row, wbits, wval); \
    } \
    ptype##s_accumulate(ret, scratch, npoints); \
}

/*
 * Infinite point among inputs would be devastating. Shall we change it?
 */ 
#define TO_AFFINE_IMPL(ptype, bits, field) \
static void ptype##s_to_affine(ptype##_affine dst[], const ptype src[], \
                               size_t npoints) \
{ \
    size_t i; \
    vec##bits *acc, ZZ, ZZZ; \
\
    acc = (vec##bits *)dst; \
    vec_copy(acc++, (src++)->Z, sizeof(vec##bits)); \
    for (i = 1; i < npoints; i++, acc++, src++) \
        mul_##field(acc[0], acc[-1], src->Z); \
\
    --acc; reciprocal_##field(acc[0], acc[0]); \
\
    --src, --npoints, dst += npoints; \
    for (i = 0; i < npoints; i++, acc--, dst--, src--) { \
        mul_##field(acc[-1], acc[-1], acc[0]);  /* 1/Z        */\
        sqr_##field(ZZ, acc[-1]);               /* 1/Z^2      */\
        mul_##field(ZZZ, ZZ, acc[-1]);          /* 1/Z^3      */\
        mul_##field(acc[-1], src->Z, acc[0]);                   \
        mul_##field(dst->X,  src->X, ZZ);       /* X = X'/Z^2 */\
        mul_##field(dst->Y,  src->Y, ZZZ);      /* Y = Y'/Z^3 */\
    } \
    sqr_##field(ZZ, acc[0]);                    /* 1/Z^2      */\
    mul_##field(ZZZ, ZZ, acc[0]);               /* 1/Z^3      */\
    mul_##field(dst->X, src->X, ZZ);            /* X = X'/Z^2 */\
    mul_##field(dst->Y, src->Y, ZZZ);           /* Y = Y'/Z^3 */\
}

PRECOMPUTE_WBITS_IMPL(POINTonE1, 384, fp, BLS12_381_Rx.p)
MULT_SCALAR_WBITS_IMPL(POINTonE1, 384, fp, BLS12_381_Rx.p)
TO_AFFINE_IMPL(POINTonE1, 384, fp)

PRECOMPUTE_WBITS_IMPL(POINTonE2, 384x, fp2, BLS12_381_Rx.p2)
MULT_SCALAR_WBITS_IMPL(POINTonE2, 384x, fp2, BLS12_381_Rx.p2)
TO_AFFINE_IMPL(POINTonE2, 384x, fp2)
