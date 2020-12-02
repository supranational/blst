/*
 * Copyright Supranational LLC
 * Licensed under the Apache License, Version 2.0, see LICENSE for details.
 * SPDX-License-Identifier: Apache-2.0
 */

#include "fields.h"

static void reciprocal_fp(vec384 out, const vec384 inp)
{
    vec768 temp;

    ct_inverse_mod_383(temp, inp, BLS12_381_P);
    redc_mont_384(out, temp, BLS12_381_P, p0);
    mul_mont_384(out, out, BLS12_381_RR, BLS12_381_P, p0);
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
