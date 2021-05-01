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
    static const ptype##_affine infinity = { 0 }; \
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
#define POINTS_TO_AFFINE_IMPL(ptype, bits, field) \
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
POINTS_TO_AFFINE_IMPL(POINTonE1, 384, fp)

PRECOMPUTE_WBITS_IMPL(POINTonE2, 384x, fp2, BLS12_381_Rx.p2)
MULT_SCALAR_WBITS_IMPL(POINTonE2, 384x, fp2, BLS12_381_Rx.p2)
POINTS_TO_AFFINE_IMPL(POINTonE2, 384x, fp2)

static size_t pippenger_window_size(size_t npoints)
{
    size_t wbits;

    for (wbits=0; npoints>>=1; wbits++) ;

    return wbits>12 ? wbits-3 : (wbits>4 ? wbits-2 : 3);
}

#define DECLARE_PRIVATE_POINTXYZZ(ptype, bits) \
typedef struct { vec##bits X,Y,ZZZ,ZZ; } ptype##xyzz;

#define POINTS_MULT_PIPPENGER_IMPL(ptype) \
static void ptype##_integrate_buckets(ptype *out, ptype##xyzz buckets[], \
                                                  size_t wbits) \
{ \
    ptype##xyzz ret[1], acc[1]; \
    size_t n = (size_t)1 << wbits; \
\
    /* Calculate sum of x[i-1]*i for i=1 through 1<<|wbits|. */\
    vec_copy(acc, &buckets[--n], sizeof(acc)); \
    vec_copy(ret, &buckets[n], sizeof(ret)); \
    vec_zero(&buckets[n], sizeof(buckets[n])); \
    while (n--) { \
        ptype##xyzz_dadd(acc, acc, &buckets[n]); \
        ptype##xyzz_dadd(ret, ret, acc); \
        vec_zero(&buckets[n], sizeof(buckets[n])); \
    } \
    ptype##xyzz_to_Jacobian(out, ret); \
} \
\
static void ptype##_bucket(ptype##xyzz buckets[], limb_t booth_idx, \
                           size_t wbits, const ptype##_affine *p) \
{ \
    bool_t booth_sign = (booth_idx >> wbits) & 1; \
\
    booth_idx &= (1<<wbits) - 1; \
    if (booth_idx--) \
        ptype##xyzz_dadd_affine(&buckets[booth_idx], &buckets[booth_idx], \
                                                     p, booth_sign); \
} \
\
static void ptype##_prefetch(const ptype##xyzz buckets[], limb_t booth_idx, \
                             size_t wbits) \
{ \
    booth_idx &= (1<<wbits) - 1; \
    if (booth_idx--) \
        vec_prefetch(&buckets[booth_idx], sizeof(buckets[booth_idx])); \
} \
\
static void ptype##s_tile_pippenger(ptype *ret, const ptype##_affine *points[], \
                                    size_t npoints, const byte *scalars[], \
                                    size_t nbits, ptype##xyzz buckets[], \
                                    size_t bit0, size_t wbits, size_t cbits) \
{ \
    limb_t wmask, wval, wnxt; \
    size_t i, z; \
\
    wmask = ((limb_t)1 << (wbits+1)) - 1; \
    z = is_zero(bit0); \
    bit0 -= z^1; wbits += z^1; \
    wval = (get_wval_limb(scalars[0], bit0, wbits) << z) & wmask; \
    wval = booth_encode(wval, cbits); \
    wnxt = (get_wval_limb(scalars[1], bit0, wbits) << z) & wmask; \
    wnxt = booth_encode(wnxt, cbits); \
    npoints--;  /* account for prefetch */ \
\
    ptype##_bucket(buckets, wval, cbits, points[0]); \
    for (i = 1; i < npoints; i++) { \
        wval = wnxt; \
        wnxt = (get_wval_limb(scalars[i+1], bit0, wbits) << z) & wmask; \
        wnxt = booth_encode(wnxt, cbits); \
        ptype##_prefetch(buckets, wnxt, cbits); \
        ptype##_bucket(buckets, wval, cbits, points[i]); \
    } \
    ptype##_bucket(buckets, wnxt, cbits, points[i]); \
    ptype##_integrate_buckets(ret, buckets, cbits - 1); \
    (void)nbits; \
} \
\
static void ptype##s_mult_pippenger(ptype *ret, const ptype##_affine *points[], \
                                    size_t npoints, const byte *scalars[], \
                                    size_t nbits, ptype##xyzz buckets[], \
                                    size_t window) \
{ \
    size_t i, wbits, cbits, bit0 = nbits; \
    ptype tile[1]; \
\
    window = window ? window : pippenger_window_size(npoints); \
    vec_zero(buckets, sizeof(buckets[0]) << (window-1)); \
    vec_zero(ret, sizeof(*ret)); \
\
    /* top excess bits modulo target window size */ \
    wbits = nbits % window; /* yes, it may be zero */ \
    cbits = wbits + 1; \
    while (bit0 -= wbits) { \
        ptype##s_tile_pippenger(tile, points, npoints, scalars, nbits, \
                                      buckets, bit0, wbits, cbits); \
        ptype##_dadd(ret, ret, tile, NULL); \
        for (i = 0; i < window; i++) \
            ptype##_double(ret, ret); \
        cbits = wbits = window; \
    } \
    ptype##s_tile_pippenger(tile, points, npoints, scalars, nbits, \
                                  buckets, 0, wbits, cbits); \
    ptype##_dadd(ret, ret, tile, NULL); \
}

DECLARE_PRIVATE_POINTXYZZ(POINTonE1, 384)
POINTXYZZ_TO_JACOBIAN_IMPL(POINTonE1, 384, fp)
POINTXYZZ_DADD_IMPL(POINTonE1, 384, fp)
POINTXYZZ_DADD_AFFINE_IMPL(POINTonE1, 384, fp, BLS12_381_Rx.p)
POINTS_MULT_PIPPENGER_IMPL(POINTonE1)
POINT_TO_XYZZ_IMPL(POINTonE1, 384, fp)

DECLARE_PRIVATE_POINTXYZZ(POINTonE2, 384x)
POINTXYZZ_TO_JACOBIAN_IMPL(POINTonE2, 384x, fp2)
POINTXYZZ_DADD_IMPL(POINTonE2, 384x, fp2)
POINTXYZZ_DADD_AFFINE_IMPL(POINTonE2, 384x, fp2, BLS12_381_Rx.p2)
POINTS_MULT_PIPPENGER_IMPL(POINTonE2)
POINT_TO_XYZZ_IMPL(POINTonE2, 384x, fp2)
