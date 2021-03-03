/*
 * Copyright Supranational LLC
 * Licensed under the Apache License, Version 2.0, see LICENSE for details.
 * SPDX-License-Identifier: Apache-2.0
 */

#include "fields.h"

static void reciprocal_fp(vec384 out, const vec384 inp)
{
    static const vec384 Px8 = {    /* left-aligned value of the modulus */
        TO_LIMB_T(0xcff7fffffffd5558), TO_LIMB_T(0xf55ffff58a9ffffd),
        TO_LIMB_T(0x39869507b587b120), TO_LIMB_T(0x23ba5c279c2895fb),
        TO_LIMB_T(0x58dd3db21a5d66bb), TO_LIMB_T(0xd0088f51cbff34d2)
    };
    static const vec384 RRx4 = {   /* (4<<768)%P */
        TO_LIMB_T(0x5f7e7cd070d107c2), TO_LIMB_T(0xec839a9ac49c13c8),
        TO_LIMB_T(0x6933786f44f4ef0b), TO_LIMB_T(0xd6bf8b9c676be983),
        TO_LIMB_T(0xd3adaaaa4dcefb06), TO_LIMB_T(0x12601bc1d82bc175)
    };
    vec768 temp;

    ct_inverse_mod_383(temp, inp, BLS12_381_P, Px8);
    redc_mont_384(out, temp, BLS12_381_P, p0);
    mul_mont_384(out, out, RRx4, BLS12_381_P, p0);
}

void blst_fp_inverse(vec384 out, const vec384 inp)
{   reciprocal_fp(out, inp);   }

void blst_fp_eucl_inverse(vec384 ret, const vec384 a)
{   reciprocal_fp(ret, a);   }

static void reciprocal_fp2(vec384x out, const vec384x inp)
{
    vec384 t0, t1;

    /*
     * |out| = 1/(a + b*i) = a/(a^2+b^2) - b/(a^2+b^2)*i
     */
    sqr_fp(t0, inp[0]);
    sqr_fp(t1, inp[1]);
    add_fp(t0, t0, t1);
    reciprocal_fp(t1, t0);
    mul_fp(out[0], inp[0], t1);
    mul_fp(out[1], inp[1], t1);
    neg_fp(out[1], out[1]);
}

void blst_fp2_inverse(vec384x out, const vec384x inp)
{   reciprocal_fp2(out, inp);   }

void blst_fp2_eucl_inverse(vec384x out, const vec384x inp)
{   reciprocal_fp2(out, inp);   }
