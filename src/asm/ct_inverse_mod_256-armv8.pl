#!/usr/bin/env perl
#
# Copyright Supranational LLC
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Both constant-time and fast Euclidean inversion as suggested in
# https://eprint.iacr.org/2020/972.
#
# void ct_inverse_mod_256(vec512 ret, const vec256 inp, const vec256 mod,
#                                                       const vec256 modx);
#
$python_ref.=<<'___';
def ct_inverse_mod_256(inp, mod):
    a, u = inp, 1
    b, v = mod, 0

    k = 62
    w = 64
    mask = (1 << w) - 1

    for i in range(0, 512 // k):
        # __ab_approximation_62
        n = max(a.bit_length(), b.bit_length())
        if n < 128:
            a_, b_ = a, b
        else:
            a_ = (a & mask) | ((a >> (n-w)) << w)
            b_ = (b & mask) | ((b >> (n-w)) << w)

        # __inner_loop_62
        f0, g0, f1, g1 = 1, 0, 0, 1
        for j in range(0, k):
            if a_ & 1:
                if a_ < b_:
                    a_, b_, f0, g0, f1, g1 = b_, a_, f1, g1, f0, g0
                a_, f0, g0 = a_-b_, f0-f1, g0-g1
            a_, f1, g1 = a_ >> 1, f1 << 1, g1 << 1

        # __smul_256_n_shift_by_62
        a, b = (a*f0 + b*g0) >> k, (a*f1 + b*g1) >> k
        if a < 0:
            a, f0, g0 = -a, -f0, -g0
        if b < 0:
            b, f1, g1 = -b, -f1, -g1

        # __smul_512x63
        u, v = u*f0 + v*g0, u*f1 + v*g1

    if 512 % k:
        f0, g0, f1, g1 = 1, 0, 0, 1
        for j in range(0, 512 % k):
            if a & 1:
                if a < b:
                    a, b, f0, g0, f1, g1 = b, a, f1, g1, f0, g0
                a, f0, g0 = a-b, f0-f1, g0-g1
            a, f1, g1 = a >> 1, f1 << 1, g1 << 1

        v = u*f1 + v*g1

    mod <<= 512 - mod.bit_length()  # align to the left
    if v < 0:
        v += mod
    elif v == 1<<512
        v -= mod

    return v    # to be reduced % mod
___

$flavour = shift;
$output  = shift;

if ($flavour && $flavour ne "void") {
    $0 =~ m/(.*[\/\\])[^\/\\]+$/; $dir=$1;
    ( $xlate="${dir}arm-xlate.pl" and -f $xlate ) or
    ( $xlate="${dir}../../perlasm/arm-xlate.pl" and -f $xlate) or
    die "can't locate arm-xlate.pl";

    open STDOUT,"| \"$^X\" $xlate $flavour $output";
} else {
    open STDOUT,">$output";
}

my ($out_ptr, $in_ptr, $n_ptr, $nx_ptr) = map("x$_", (0..3));
my @acc=map("x$_",(4..11));
my ($f0, $g0, $f1, $g1, $f_, $g_) = map("x$_",(12..17));
my $cnt = $n_ptr;
my @t = map("x$_",(19..26));
my ($a_lo, $a_hi, $b_lo, $b_hi) = @acc[0,3,4,7];

$frame = 16+2*512;

$code.=<<___;
.text

.globl	ct_inverse_mod_256
.type	ct_inverse_mod_256, %function
.align	5
ct_inverse_mod_256:
	paciasp
	stp	x29, x30, [sp,#-80]!
	add	x29, sp, #0
	stp	x19, x20, [sp,#16]
	stp	x21, x22, [sp,#32]
	stp	x23, x24, [sp,#48]
	stp	x25, x26, [sp,#64]
	sub	sp, sp, #$frame

	ldp	@acc[0], @acc[1], [$in_ptr,#8*0]
	ldp	@acc[2], @acc[3], [$in_ptr,#8*2]

	add	$in_ptr, sp, #16+511	// find closest 512-byte-aligned spot
	and	$in_ptr, $in_ptr, #-512	// in the frame...
	str	$out_ptr, [sp]

	ldp	@acc[4], @acc[5], [$n_ptr,#8*0]
	ldp	@acc[6], @acc[7], [$n_ptr,#8*2]

	stp	@acc[0], @acc[1], [$in_ptr,#8*0]	// copy input to |a|
	stp	@acc[2], @acc[3], [$in_ptr,#8*2]
	stp	@acc[4], @acc[5], [$in_ptr,#8*4]	// copy modulus to |b|
	stp	@acc[6], @acc[7], [$in_ptr,#8*6]

	////////////////////////////////////////// first iteration
	mov	$cnt, #62
	bl	.Lab_approximation_62_256_loaded

	eor	$out_ptr, $in_ptr, #256		// pointer to dst |a|b|u|v|
	bl	__smul_256_n_shift_by_62
	str	$f0,[$out_ptr,#8*8]		// initialize |u| with |f0|

	mov	$f0, $f1			// |f1|
	mov	$g0, $g1			// |g1|
	add	$out_ptr, $out_ptr, #8*4	// pointer to dst |b|
	bl	__smul_256_n_shift_by_62
	str	$f0, [$out_ptr,#8*9]		// initialize |v| with |f1|

	////////////////////////////////////////// second iteration
	eor	$in_ptr, $in_ptr, #256		// flip-flop src |a|b|u|v|
	mov	$cnt, #62
	bl	__ab_approximation_62_256

	eor	$out_ptr, $in_ptr, #256		// pointer to dst |a|b|u|v|
	bl	__smul_256_n_shift_by_62
	mov	$f_, $f0			// corrected |f0|
	mov	$g_, $g0			// corrected |g0|

	mov	$f0, $f1			// |f1|
	mov	$g0, $g1			// |g1|
	add	$out_ptr, $out_ptr, #8*4	// pointer to destination |b|
	bl	__smul_256_n_shift_by_62

	ldr	@acc[4], [$in_ptr,#8*8]		// |u|
	ldr	@acc[5], [$in_ptr,#8*13]	// |v|
	mul	@acc[0], $f_, @acc[4]		// |u|*|f0|
	smulh	@acc[1], $f_, @acc[4]
	mul	@acc[2], $g_, @acc[5]		// |v|*|g0|
	smulh	@acc[3], $g_, @acc[5]
	adds	@acc[0], @acc[0], @acc[2]
	adc	@acc[1], @acc[1], @acc[3]
	stp	@acc[0], @acc[1], [$out_ptr,#8*4]
	asr	@acc[2], @acc[1], #63		// sign extenstion
	stp	@acc[2], @acc[2], [$out_ptr,#8*6]
	str	@acc[2], [$out_ptr,#8*8]

	mul	@acc[0], $f0, @acc[4]		// |u|*|f1|
	smulh	@acc[1], $f0, @acc[4]
	mul	@acc[2], $g0, @acc[5]		// |v|*|g1|
	smulh	@acc[3], $g0, @acc[5]
	adds	@acc[0], @acc[0], @acc[2]
	adc	@acc[1], @acc[1], @acc[3]
	stp	@acc[0], @acc[1], [$out_ptr,#8*9]
	asr	@acc[2], @acc[1], #63		// sign extenstion
	stp	@acc[2], @acc[2], [$out_ptr,#8*11]
	str	@acc[2], [$out_ptr,#8*13]
___
for($i=2; $i<7; $i++) {
$code.=<<___;
	eor	$in_ptr, $in_ptr, #256		// flip-flop src |a|b|u|v|
	mov	$cnt, #62
	bl	__ab_approximation_62_256

	eor	$out_ptr, $in_ptr, #256		// pointer to dst |a|b|u|v|
	bl	__smul_256_n_shift_by_62
	mov	$f_, $f0			// corrected |f0|
	mov	$g_, $g0			// corrected |g0|

	mov	$f0, $f1			// |f1|
	mov	$g0, $g1			// |g1|
	add	$out_ptr, $out_ptr, #8*4	// pointer to destination |b|
	bl	__smul_256_n_shift_by_62

	add	$out_ptr, $out_ptr, #8*4	// pointer to destination |u|
	bl	__smul_256x63
	adc	@t[3], @t[3], @t[4]
	str	@t[3], [$out_ptr,#8*4]

	mov	$f_, $f0			// corrected |f1|
	mov	$g_, $g0			// corrected |g1|
	add	$out_ptr, $out_ptr, #8*5	// pointer to destination |v|
	bl	__smul_256x63
___
$code.=<<___	if ($i>3);
	bl	__smul_512x63_tail
___
$code.=<<___	if ($i<=3);
	adc	@t[3], @t[3], @t[4]
	stp	@t[3], @t[3], [$out_ptr,#8*4]
	stp	@t[3], @t[3], [$out_ptr,#8*6]
___
}
$code.=<<___;
	////////////////////////////////////////// iteration before last
	eor	$in_ptr, $in_ptr, #256		// flip-flop src |a|b|u|v|
	mov	$cnt, #62
	//bl	__ab_approximation_62_256	// |a| and |b| are exact,
	ldp	$a_lo, $a_hi, [$in_ptr,#8*0]	// just load
	ldp	$b_lo, $b_hi, [$in_ptr,#8*4]
	bl	__inner_loop_62_256

	eor	$out_ptr, $in_ptr, #256		// pointer to dst |a|b|u|v|
	str	$a_lo, [$out_ptr,#8*0]
	str	$b_lo, [$out_ptr,#8*4]

	mov	$f_, $f0			// exact |f0|
	mov	$g_, $g0			// exact |g0|
	mov	$f0, $f1
	mov	$g0, $g1
	add	$out_ptr, $out_ptr, #8*8	// pointer to dst |u|
	bl	__smul_256x63
	adc	@t[3], @t[3], @t[4]
	str	@t[3], [$out_ptr,#8*4]

	mov	$f_, $f0			// exact |f1|
	mov	$g_, $g0			// exact |g1|
	add	$out_ptr, $out_ptr, #8*5	// pointer to dst |v|
	bl	__smul_256x63
	bl	__smul_512x63_tail

	////////////////////////////////////////// last iteration
	eor	$in_ptr, $in_ptr, #256		// flip-flop src |a|b|u|v|
	mov	$cnt, #16			// 512 % 62
	//bl	__ab_approximation_62_256	// |a| and |b| are exact,
	ldr	$a_lo, [$in_ptr,#8*0]		// just load
	eor	$a_hi, $a_hi, $a_hi
	ldr	$b_lo, [$in_ptr,#8*4]
	eor	$b_hi, $b_hi, $b_hi
	bl	__inner_loop_62_256

	mov	$f_, $f1
	mov	$g_, $g1
	ldr	$out_ptr, [sp]			// original out_ptr
	bl	__smul_256x63
	bl	__smul_512x63_tail
	ldr	x30, [x29,#8]

	smulh	@t[1], @acc[3], $g_		// figure out top-most limb
	ldp	@acc[4], @acc[5], [$nx_ptr,#8*0]
	adc	@t[4], @t[4], @t[6]
	ldp	@acc[6], @acc[7], [$nx_ptr,#8*2]

	add	@t[1], @t[1], @t[4]
	asr	@t[0], @t[1], #63		// sign as mask

	and	@t[4],   @acc[4], @t[0]		// add mod<<256 conditionally
	and	@t[5],   @acc[5], @t[0]
	adds	@acc[0], @acc[0], @t[4]
	and	@t[6],   @acc[6], @t[0]
	adcs	@acc[1], @acc[1], @t[5]
	and	@t[7],   @acc[7], @t[0]
	adcs	@acc[2], @acc[2], @t[6]
	adcs	@acc[3], @t[3],   @t[7]
	adc	@t[1], @t[1], xzr

	neg	@t[0], @t[1]

	and	@acc[4], @acc[4], @t[0]		// subtract mod<<256 conditionally
	and	@acc[5], @acc[5], @t[0]
	subs	@acc[0], @acc[0], @acc[4]
	and	@acc[6], @acc[6], @t[0]
	sbcs	@acc[1], @acc[1], @acc[5]
	and	@acc[7], @acc[7], @t[0]
	sbcs	@acc[2], @acc[2], @acc[6]
	sbcs	@acc[3], @acc[3], @acc[7]

	stp	@acc[0], @acc[1], [$out_ptr,#8*4]
	stp	@acc[2], @acc[3], [$out_ptr,#8*6]

	add	sp, sp, #$frame
	ldp	x19, x20, [x29,#16]
	ldp	x21, x22, [x29,#32]
	ldp	x23, x24, [x29,#48]
	ldp	x25, x26, [x29,#64]
	ldr	x29, [sp],#80
	autiasp
	ret
.size	ct_inverse_mod_256,.-ct_inverse_mod_256

////////////////////////////////////////////////////////////////////////
.type	__smul_256x63, %function
.align	5
__smul_256x63:
___
for($j=0; $j<2; $j++) {
my $f_ = $f_;   $f_ = $g_          if ($j);
my @acc = @acc; @acc = @acc[4..7]  if ($j);
my $k = 8*8+8*5*$j;
$code.=<<___;
	ldp	@acc[0], @acc[1], [$in_ptr,#8*0+$k]	// load |u| (or |v|)
	asr	$f1, $f_, #63		// |f_|'s sign as mask (or |g_|'s)
	ldp	@acc[2], @acc[3], [$in_ptr,#8*2+$k]
	eor	$f_, $f_, $f1		// conditionally negate |f_| (or |g_|)
	ldr	@t[3+$j], [$in_ptr,#8*4+$k]

	eor	@acc[0], @acc[0], $f1	// conditionally negate |u| (or |v|)
	sub	$f_, $f_, $f1
	eor	@acc[1], @acc[1], $f1
	adds	@acc[0], @acc[0], $f1, lsr#63
	eor	@acc[2], @acc[2], $f1
	adcs	@acc[1], @acc[1], xzr
	eor	@acc[3], @acc[3], $f1
	adcs	@acc[2], @acc[2], xzr
	eor	@t[3+$j], @t[3+$j], $f1
	 umulh	@t[0], @acc[0], $f_
	adcs	@acc[3], @acc[3], xzr
	 umulh	@t[1], @acc[1], $f_
	adcs	@t[3+$j], @t[3+$j], xzr
	 umulh	@t[2], @acc[2], $f_
___
$code.=<<___	if ($j!=0);
	adc	$g1, xzr, xzr		// used in __smul_512x63_tail
___
$code.=<<___;
	mul	@acc[0], @acc[0], $f_
	 cmp	$f_, #0
	mul	@acc[1], @acc[1], $f_
	 csel	@t[3+$j], @t[3+$j], xzr, ne
	mul	@acc[2], @acc[2], $f_
	adds	@acc[1], @acc[1], @t[0]
	mul	@t[5+$j], @acc[3], $f_
	adcs	@acc[2], @acc[2], @t[1]
	adcs	@t[5+$j], @t[5+$j], @t[2]
___
$code.=<<___	if ($j==0);
	adc	@t[7], xzr, xzr
___
}
$code.=<<___;
	adc	@t[7], @t[7], xzr

	adds	@acc[0], @acc[0], @acc[4]
	adcs	@acc[1], @acc[1], @acc[5]
	adcs	@acc[2], @acc[2], @acc[6]
	stp	@acc[0], @acc[1], [$out_ptr,#8*0]
	adcs	@t[5],   @t[5],   @t[6]
	stp	@acc[2], @t[5], [$out_ptr,#8*2]

	ret
.size	__smul_256x63,.-__smul_256x63

.type	__smul_512x63_tail, %function
.align	5
__smul_512x63_tail:
	umulh	@t[5], @acc[3], $f_
	ldp	@acc[1], @acc[2], [$in_ptr,#8*18]	// load rest of |v|
	adc	@t[7], @t[7], xzr
	ldr	@acc[3], [$in_ptr,#8*20]
	and	@t[3], @t[3], $f_

	umulh	@acc[7], @acc[7], $g_

	sub	@t[5], @t[5], @t[3]
	asr	@t[6], @t[5], #63

	eor	@acc[1], @acc[1], $f1	// conditionally negate rest of |v|
	eor	@acc[2], @acc[2], $f1
	adds	@acc[1], @acc[1], $g1
	eor	@acc[3], @acc[3], $f1
	adcs	@acc[2], @acc[2], xzr
	 umulh	@t[0], @t[4],   $g_
	adc	@acc[3], @acc[3], xzr
	 umulh	@t[1], @acc[1], $g_
	add	@acc[7], @acc[7], @t[7]
	 umulh	@t[2], @acc[2], $g_

	mul	@acc[0], @t[4],   $g_
	mul	@acc[1], @acc[1], $g_
	adds	@acc[0], @acc[0], @acc[7]
	mul	@acc[2], @acc[2], $g_
	adcs	@acc[1], @acc[1], @t[0]
	mul	@t[3],   @acc[3], $g_
	adcs	@acc[2], @acc[2], @t[1]
	adcs	@t[3],   @t[3],   @t[2]
	adc	@t[4], xzr, xzr

	adds	@acc[0], @acc[0], @t[5]
	adcs	@acc[1], @acc[1], @t[6]
	adcs	@acc[2], @acc[2], @t[6]
	stp	@acc[0], @acc[1], [$out_ptr,#8*4]
	adcs	@t[3],   @t[3],   @t[6]
	stp	@acc[2], @t[3],   [$out_ptr,#8*6]

	ret
.size	__smul_512x63_tail,.-__smul_512x63_tail

.type	__smul_256_n_shift_by_62, %function
.align	5
__smul_256_n_shift_by_62:
___
for($j=0; $j<2; $j++) {
my $f0 = $f0;   $f0 = $g0           if ($j);
my @acc = @acc; @acc = @acc[4..7]   if ($j);
my $k = 8*4*$j;
$code.=<<___;
	ldp	@acc[0], @acc[1], [$in_ptr,#8*0+$k]	// load |a| (or |b|)
	asr	@t[5], $f0, #63		// |f0|'s sign as mask (or |g0|'s)
	ldp	@acc[2], @acc[3], [$in_ptr,#8*2+$k]
	eor	@t[6], $f0, @t[5]	// conditionally negate |f0| (or |g0|)

	eor	@acc[0], @acc[0], @t[5]	// conditionally negate |a| (or |b|)
	sub	@t[6], @t[6], @t[5]
	eor	@acc[1], @acc[1], @t[5]
	adds	@acc[0], @acc[0], @t[5], lsr#63
	eor	@acc[2], @acc[2], @t[5]
	adcs	@acc[1], @acc[1], xzr
	eor	@acc[3], @acc[3], @t[5]
	 umulh	@t[0], @acc[0], @t[6]
	adcs	@acc[2], @acc[2], xzr
	 umulh	@t[1], @acc[1], @t[6]
	adc	@acc[3], @acc[3], xzr
	 umulh	@t[2], @acc[2], @t[6]
	 umulh	@t[3+$j], @acc[3], @t[6]

	mul	@acc[0], @acc[0], @t[6]
	mul	@acc[1], @acc[1], @t[6]
	and	@t[5], @t[5], @t[6]
	mul	@acc[2], @acc[2], @t[6]
	adds	@acc[1], @acc[1], @t[0]
	mul	@acc[3], @acc[3], @t[6]
	adcs	@acc[2], @acc[2], @t[1]
	sub	@t[3+$j], @t[3+$j], @t[5]
	adcs	@acc[3], @acc[3], @t[2]
	adc	@t[3+$j], @t[3+$j], xzr
___
}
$code.=<<___;
	adds	@acc[0], @acc[0], @acc[4]
	adcs	@acc[1], @acc[1], @acc[5]
	adcs	@acc[2], @acc[2], @acc[6]
	adcs	@acc[3], @acc[3], @acc[7]
	adc	@acc[4], @t[3],   @t[4]

	extr	@acc[0], @acc[1], @acc[0], #62
	extr	@acc[1], @acc[2], @acc[1], #62
	extr	@acc[2], @acc[3], @acc[2], #62
	asr	@t[4], @acc[4], #63
	extr	@acc[3], @acc[4], @acc[3], #62

	eor	@acc[0], @acc[0], @t[4]
	eor	@acc[1], @acc[1], @t[4]
	adds	@acc[0], @acc[0], @t[4], lsr#63
	eor	@acc[2], @acc[2], @t[4]
	adcs	@acc[1], @acc[1], xzr
	eor	@acc[3], @acc[3], @t[4]
	adcs	@acc[2], @acc[2], xzr
	adc	@acc[3], @acc[3], xzr
	stp	@acc[0], @acc[1], [$out_ptr,#8*0]
	stp	@acc[2], @acc[3], [$out_ptr,#8*2]

	eor	$f0, $f0, @t[4]
	eor	$g0, $g0, @t[4]
	sub	$f0, $f0, @t[4]
	sub	$g0, $g0, @t[4]

	ret
.size	__smul_256_n_shift_by_62,.-__smul_256_n_shift_by_62
___

{
my @a = @acc[0..3];
my @b = @acc[4..7];

$code.=<<___;
.type	__ab_approximation_62_256, %function
.align	4
__ab_approximation_62_256:
	ldp	@a[2], @a[3], [$in_ptr,#8*2]
	ldp	@b[2], @b[3], [$in_ptr,#8*6]
	ldp	@a[0], @a[1], [$in_ptr,#8*0]
	ldp	@b[0], @b[1], [$in_ptr,#8*4]

.Lab_approximation_62_256_loaded:
	orr	@t[0], @a[3], @b[3]	// check top-most limbs, ...
	cmp	@t[0], #0
	csel	@a[3], @a[3], @a[2], ne
	csel	@b[3], @b[3], @b[2], ne
	csel	@a[2], @a[2], @a[1], ne
	orr	@t[0], @a[3], @b[3]	// and ones before top-most, ...
	csel	@b[2], @b[2], @b[1], ne

	clz	@t[0], @t[0]
	cmp	@t[0], #64
	csel	@t[0], @t[0], xzr, ne
	csel	@a[3], @a[3], @a[2], ne
	csel	@b[3], @b[3], @b[2], ne
	neg	@t[1], @t[0]

	lslv	@a[3], @a[3], @t[0]	// align high limbs to the left
	lslv	@b[3], @b[3], @t[0]
	lsrv	@a[2], @a[2], @t[1]
	lsrv	@b[2], @b[2], @t[1]
	and	@a[2], @a[2], @t[1], asr#6
	and	@b[2], @b[2], @t[1], asr#6
	orr	@a[3], @a[3], @a[2]
	orr	@b[3], @b[3], @b[2]

	b	__inner_loop_62_256
	ret
.size	__ab_approximation_62_256,.-__ab_approximation_62_256
___
}
$code.=<<___;
.type	__inner_loop_62_256, %function
.align	4
__inner_loop_62_256:
	mov	$f0, #1		// |f0|=1
	mov	$g0, #0		// |g0|=0
	mov	$f1, #0		// |f1|=0
	mov	$g1, #1		// |g1|=1

.Loop_62_256:
	sbfx	@t[6], $a_lo, #0, #1	// if |a_| is odd, then we'll be subtracting
	sub	$cnt, $cnt, #1
	and	@t[0], $b_lo, @t[6]
	and	@t[1], $b_hi, @t[6]
	subs	@t[2], $b_lo, $a_lo	// |b_|-|a_|
	mov	@t[4], $a_lo
	sbc	@t[3], $b_hi, $a_hi
	mov	@t[5], $a_hi
	subs	$a_lo, $a_lo, @t[0]	// |a_|-|b_| (or |a_|-0 if |a_| was even)
	mov	@t[0], $f0
	sbcs	$a_hi, $a_hi, @t[1]
	mov	@t[1], $g0
	csel	$a_lo, $a_lo, @t[2], hs	// borrow means |a_|<|b_|, replace with |b_|-|a_|
	csel	$a_hi, $a_hi, @t[3], hs
	csel	$b_lo, $b_lo, @t[4], hs	// |b_| = |a_|
	csel	$b_hi, $b_hi, @t[5], hs
	csel	$f0, $f0, $f1,       hs	// exchange |f0| and |f1|
	csel	$f1, $f1, @t[0],     hs
	csel	$g0, $g0, $g1,       hs	// exchange |g0| and |g1|
	csel	$g1, $g1, @t[1],     hs
	extr	$a_lo, $a_hi, $a_lo, #1
	lsr	$a_hi, $a_hi, #1
	and	@t[0], $f1, @t[6]
	and	@t[1], $g1, @t[6]
	add	$f1, $f1, $f1		// |f1|<<=1
	add	$g1, $g1, $g1		// |g1|<<=1
	sub	$f0, $f0, @t[0]		// |f0|-=|f1| (or |f0-=0| if |a_| was even)
	sub	$g0, $g0, @t[1]		// |g0|-=|g1| (or |g0-=0| ...)
	cbnz	$cnt, .Loop_62_256

	ret
.size	__inner_loop_62_256,.-__inner_loop_62_256
___

print $code;
close STDOUT;
