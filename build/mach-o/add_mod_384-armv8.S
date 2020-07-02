.text

.globl	_add_mod_384
.private_extern	_add_mod_384

.align	5
_add_mod_384:
.long	3573752639
	stp	x29,x30,[sp,#-48]!
	add	x29,sp,#0
	stp	x19,x20,[sp,#16]
	stp	x21,x22,[sp,#32]

	ldp	x4,x5,[x3]
	ldp	x6,x7,[x3,#16]
	ldp	x8,x9,[x3,#32]

	bl	__add_mod_384
	ldr	x30,[sp,#8]

	stp	x10,x11,[x0]
	stp	x12,x13,[x0,#16]
	stp	x14,x15,[x0,#32]

	ldp	x19,x20,[x29,#16]
	ldp	x21,x22,[x29,#32]
	ldr	x29,[sp],#48
.long	3573752767
	ret



.align	5
__add_mod_384:
	ldp	x10,x11,[x1]
	ldp	x16,x17,[x2]
	ldp	x12,x13,[x1,#16]
	ldp	x19,x20,[x2,#16]
	ldp	x14,x15,[x1,#32]
	ldp	x21,x22,[x2,#32]

__add_mod_384_ab_are_loaded:
	adds	x10,x10,x16
	adcs	x11,x11,x17
	adcs	x12,x12,x19
	adcs	x13,x13,x20
	adcs	x14,x14,x21
	adcs	x15,x15,x22
	adc	x3,xzr,xzr

	subs	x16,x10,x4
	sbcs	x17,x11,x5
	sbcs	x19,x12,x6
	sbcs	x20,x13,x7
	sbcs	x21,x14,x8
	sbcs	x22,x15,x9
	sbcs	xzr,x3,xzr

	csel	x10,x10,x16,lo
	csel	x11,x11,x17,lo
	csel	x12,x12,x19,lo
	csel	x13,x13,x20,lo
	csel	x14,x14,x21,lo
	csel	x15,x15,x22,lo

	ret


.globl	_add_mod_384x
.private_extern	_add_mod_384x

.align	5
_add_mod_384x:
.long	3573752639
	stp	x29,x30,[sp,#-48]!
	add	x29,sp,#0
	stp	x19,x20,[sp,#16]
	stp	x21,x22,[sp,#32]

	ldp	x4,x5,[x3]
	ldp	x6,x7,[x3,#16]
	ldp	x8,x9,[x3,#32]

	bl	__add_mod_384

	stp	x10,x11,[x0]
	add	x1,x1,#48
	stp	x12,x13,[x0,#16]
	add	x2,x2,#48
	stp	x14,x15,[x0,#32]

	bl	__add_mod_384
	ldr	x30,[sp,#8]

	stp	x10,x11,[x0,#48]
	stp	x12,x13,[x0,#64]
	stp	x14,x15,[x0,#80]

	ldp	x19,x20,[x29,#16]
	ldp	x21,x22,[x29,#32]
	ldr	x29,[sp],#48
.long	3573752767
	ret


.globl	_lshift_mod_384
.private_extern	_lshift_mod_384

.align	5
_lshift_mod_384:
.long	3573752639
	stp	x29,x30,[sp,#-48]!
	add	x29,sp,#0
	stp	x19,x20,[sp,#16]
	stp	x21,x22,[sp,#32]

	ldp	x10,x11,[x1]
	ldp	x12,x13,[x1,#16]
	ldp	x14,x15,[x1,#32]

	ldp	x4,x5,[x3]
	ldp	x6,x7,[x3,#16]
	ldp	x8,x9,[x3,#32]

Loop_lshift_mod_384:
	sub	x2,x2,#1
	bl	__lshift_mod_384
	cbnz	x2,Loop_lshift_mod_384

	ldr	x30,[sp,#8]
	stp	x10,x11,[x0]
	stp	x12,x13,[x0,#16]
	stp	x14,x15,[x0,#32]

	ldp	x19,x20,[x29,#16]
	ldp	x21,x22,[x29,#32]
	ldr	x29,[sp],#48
.long	3573752767
	ret



.align	5
__lshift_mod_384:
	adds	x10,x10,x10
	adcs	x11,x11,x11
	adcs	x12,x12,x12
	adcs	x13,x13,x13
	adcs	x14,x14,x14
	adcs	x15,x15,x15
	adc	x3,xzr,xzr

	subs	x16,x10,x4
	sbcs	x17,x11,x5
	sbcs	x19,x12,x6
	sbcs	x20,x13,x7
	sbcs	x21,x14,x8
	sbcs	x22,x15,x9
	sbcs	xzr,x3,xzr

	csel	x10,x10,x16,lo
	csel	x11,x11,x17,lo
	csel	x12,x12,x19,lo
	csel	x13,x13,x20,lo
	csel	x14,x14,x21,lo
	csel	x15,x15,x22,lo

	ret


.globl	_mul_by_3_mod_384
.private_extern	_mul_by_3_mod_384

.align	5
_mul_by_3_mod_384:
.long	3573752639
	stp	x29,x30,[sp,#-48]!
	add	x29,sp,#0
	stp	x19,x20,[sp,#16]
	stp	x21,x22,[sp,#32]

	ldp	x10,x11,[x1]
	ldp	x12,x13,[x1,#16]
	ldp	x14,x15,[x1,#32]

	ldp	x4,x5,[x2]
	ldp	x6,x7,[x2,#16]
	ldp	x8,x9,[x2,#32]

	bl	__lshift_mod_384

	ldp	x16,x17,[x1]
	ldp	x19,x20,[x1,#16]
	ldp	x21,x22,[x1,#32]

	bl	__add_mod_384_ab_are_loaded
	ldr	x30,[sp,#8]

	stp	x10,x11,[x0]
	stp	x12,x13,[x0,#16]
	stp	x14,x15,[x0,#32]

	ldp	x19,x20,[x29,#16]
	ldp	x21,x22,[x29,#32]
	ldr	x29,[sp],#48
.long	3573752767
	ret


.globl	_mul_by_8_mod_384
.private_extern	_mul_by_8_mod_384

.align	5
_mul_by_8_mod_384:
.long	3573752639
	stp	x29,x30,[sp,#-48]!
	add	x29,sp,#0
	stp	x19,x20,[sp,#16]
	stp	x21,x22,[sp,#32]

	ldp	x10,x11,[x1]
	ldp	x12,x13,[x1,#16]
	ldp	x14,x15,[x1,#32]

	ldp	x4,x5,[x2]
	ldp	x6,x7,[x2,#16]
	ldp	x8,x9,[x2,#32]

	bl	__lshift_mod_384
	bl	__lshift_mod_384
	bl	__lshift_mod_384
	ldr	x30,[sp,#8]

	stp	x10,x11,[x0]
	stp	x12,x13,[x0,#16]
	stp	x14,x15,[x0,#32]

	ldp	x19,x20,[x29,#16]
	ldp	x21,x22,[x29,#32]
	ldr	x29,[sp],#48
.long	3573752767
	ret


.globl	_mul_by_b_onE1
.private_extern	_mul_by_b_onE1

.align	5
_mul_by_b_onE1:
.long	3573752639
	stp	x29,x30,[sp,#-48]!
	add	x29,sp,#0
	stp	x19,x20,[sp,#16]
	stp	x21,x22,[sp,#32]

	adrp	x3,BLS12_381_P@PAGE
	ldp	x10,x11,[x1]
	add	x3,x3,BLS12_381_P@PAGEOFF
	ldp	x12,x13,[x1,#16]
	ldp	x14,x15,[x1,#32]

	ldp	x4,x5,[x3]
	ldp	x6,x7,[x3,#16]
	ldp	x8,x9,[x3,#32]

	bl	__lshift_mod_384
	bl	__lshift_mod_384
	ldr	x30,[sp,#8]

	stp	x10,x11,[x0]
	stp	x12,x13,[x0,#16]
	stp	x14,x15,[x0,#32]

	ldp	x19,x20,[x29,#16]
	ldp	x21,x22,[x29,#32]
	ldr	x29,[sp],#48
.long	3573752767
	ret


.globl	_mul_by_4b_onE1
.private_extern	_mul_by_4b_onE1

.align	5
_mul_by_4b_onE1:
.long	3573752639
	stp	x29,x30,[sp,#-48]!
	add	x29,sp,#0
	stp	x19,x20,[sp,#16]
	stp	x21,x22,[sp,#32]

	adrp	x3,BLS12_381_P@PAGE
	ldp	x10,x11,[x1]
	add	x3,x3,BLS12_381_P@PAGEOFF
	ldp	x12,x13,[x1,#16]
	ldp	x14,x15,[x1,#32]

	ldp	x4,x5,[x3]
	ldp	x6,x7,[x3,#16]
	ldp	x8,x9,[x3,#32]

	bl	__lshift_mod_384
	bl	__lshift_mod_384
	bl	__lshift_mod_384
	bl	__lshift_mod_384
	ldr	x30,[sp,#8]

	stp	x10,x11,[x0]
	stp	x12,x13,[x0,#16]
	stp	x14,x15,[x0,#32]

	ldp	x19,x20,[x29,#16]
	ldp	x21,x22,[x29,#32]
	ldr	x29,[sp],#48
.long	3573752767
	ret


.globl	_mul_by_3_mod_384x
.private_extern	_mul_by_3_mod_384x

.align	5
_mul_by_3_mod_384x:
.long	3573752639
	stp	x29,x30,[sp,#-48]!
	add	x29,sp,#0
	stp	x19,x20,[sp,#16]
	stp	x21,x22,[sp,#32]

	ldp	x10,x11,[x1]
	ldp	x12,x13,[x1,#16]
	ldp	x14,x15,[x1,#32]

	ldp	x4,x5,[x2]
	ldp	x6,x7,[x2,#16]
	ldp	x8,x9,[x2,#32]

	bl	__lshift_mod_384

	ldp	x16,x17,[x1]
	ldp	x19,x20,[x1,#16]
	ldp	x21,x22,[x1,#32]

	bl	__add_mod_384_ab_are_loaded

	stp	x10,x11,[x0]
	ldp	x10,x11,[x1,#48]
	stp	x12,x13,[x0,#16]
	ldp	x12,x13,[x1,#64]
	stp	x14,x15,[x0,#32]
	ldp	x14,x15,[x1,#80]

	bl	__lshift_mod_384

	ldp	x16,x17,[x1,#48]
	ldp	x19,x20,[x1,#64]
	ldp	x21,x22,[x1,#80]

	bl	__add_mod_384_ab_are_loaded
	ldr	x30,[sp,#8]

	stp	x10,x11,[x0,#48]
	stp	x12,x13,[x0,#64]
	stp	x14,x15,[x0,#80]

	ldp	x19,x20,[x29,#16]
	ldp	x21,x22,[x29,#32]
	ldr	x29,[sp],#48
.long	3573752767
	ret


.globl	_mul_by_8_mod_384x
.private_extern	_mul_by_8_mod_384x

.align	5
_mul_by_8_mod_384x:
.long	3573752639
	stp	x29,x30,[sp,#-48]!
	add	x29,sp,#0
	stp	x19,x20,[sp,#16]
	stp	x21,x22,[sp,#32]

	ldp	x10,x11,[x1]
	ldp	x12,x13,[x1,#16]
	ldp	x14,x15,[x1,#32]

	ldp	x4,x5,[x2]
	ldp	x6,x7,[x2,#16]
	ldp	x8,x9,[x2,#32]

	bl	__lshift_mod_384
	bl	__lshift_mod_384
	bl	__lshift_mod_384

	stp	x10,x11,[x0]
	ldp	x10,x11,[x1,#48]
	stp	x12,x13,[x0,#16]
	ldp	x12,x13,[x1,#64]
	stp	x14,x15,[x0,#32]
	ldp	x14,x15,[x1,#80]

	bl	__lshift_mod_384
	bl	__lshift_mod_384
	bl	__lshift_mod_384
	ldr	x30,[sp,#8]

	stp	x10,x11,[x0,#48]
	stp	x12,x13,[x0,#64]
	stp	x14,x15,[x0,#80]

	ldp	x19,x20,[x29,#16]
	ldp	x21,x22,[x29,#32]
	ldr	x29,[sp],#48
.long	3573752767
	ret


.globl	_mul_by_b_onE2
.private_extern	_mul_by_b_onE2

.align	5
_mul_by_b_onE2:
.long	3573752639
	stp	x29,x30,[sp,#-48]!
	add	x29,sp,#0
	stp	x19,x20,[sp,#16]
	stp	x21,x22,[sp,#32]

	adrp	x3,BLS12_381_P@PAGE
	add	x3,x3,BLS12_381_P@PAGEOFF
	add	x2,x1,#48

	ldp	x4,x5,[x3]
	ldp	x6,x7,[x3,#16]
	ldp	x8,x9,[x3,#32]

	bl	__sub_mod_384
	bl	__lshift_mod_384
	bl	__lshift_mod_384

	stp	x10,x11,[x0]
	stp	x12,x13,[x0,#16]
	stp	x14,x15,[x0,#32]

	bl	__add_mod_384
	bl	__lshift_mod_384
	bl	__lshift_mod_384
	ldr	x30,[sp,#8]

	stp	x10,x11,[x0,#48]
	stp	x12,x13,[x0,#64]
	stp	x14,x15,[x0,#80]

	ldp	x19,x20,[x29,#16]
	ldp	x21,x22,[x29,#32]
	ldr	x29,[sp],#48
.long	3573752767
	ret


.globl	_mul_by_4b_onE2
.private_extern	_mul_by_4b_onE2

.align	5
_mul_by_4b_onE2:
.long	3573752639
	stp	x29,x30,[sp,#-48]!
	add	x29,sp,#0
	stp	x19,x20,[sp,#16]
	stp	x21,x22,[sp,#32]

	adrp	x3,BLS12_381_P@PAGE
	add	x3,x3,BLS12_381_P@PAGEOFF
	add	x2,x1,#48

	ldp	x4,x5,[x3]
	ldp	x6,x7,[x3,#16]
	ldp	x8,x9,[x3,#32]

	bl	__sub_mod_384
	bl	__lshift_mod_384
	bl	__lshift_mod_384
	bl	__lshift_mod_384
	bl	__lshift_mod_384

	stp	x10,x11,[x0]
	stp	x12,x13,[x0,#16]
	stp	x14,x15,[x0,#32]

	bl	__add_mod_384
	bl	__lshift_mod_384
	bl	__lshift_mod_384
	bl	__lshift_mod_384
	bl	__lshift_mod_384
	ldr	x30,[sp,#8]

	stp	x10,x11,[x0,#48]
	stp	x12,x13,[x0,#64]
	stp	x14,x15,[x0,#80]

	ldp	x19,x20,[x29,#16]
	ldp	x21,x22,[x29,#32]
	ldr	x29,[sp],#48
.long	3573752767
	ret


.globl	_cneg_mod_384
.private_extern	_cneg_mod_384

.align	5
_cneg_mod_384:
.long	3573752639
	stp	x29,x30,[sp,#-48]!
	add	x29,sp,#0
	stp	x19,x20,[sp,#16]
	stp	x21,x22,[sp,#32]

	ldp	x10,x11,[x1]
	ldp	x4,x5,[x3]
	ldp	x12,x13,[x1,#16]
	ldp	x6,x7,[x3,#16]

	subs	x16,x4,x10
	ldp	x14,x15,[x1,#32]
	ldp	x8,x9,[x3,#32]
	orr	x3,x10,x11
	sbcs	x17,x5,x11
	orr	x3,x3,x12
	sbcs	x19,x6,x12
	orr	x3,x3,x13
	sbcs	x20,x7,x13
	orr	x3,x3,x14
	sbcs	x21,x8,x14
	orr	x3,x3,x15
	sbc	x22,x9,x15

	cmp	x3,#0
	csetm	x3,ne
	ands	x2,x2,x3

	csel	x10,x10,x16,eq
	csel	x11,x11,x17,eq
	csel	x12,x12,x19,eq
	csel	x13,x13,x20,eq
	stp	x10,x11,[x0]
	csel	x14,x14,x21,eq
	stp	x12,x13,[x0,#16]
	csel	x15,x15,x22,eq
	stp	x14,x15,[x0,#32]

	ldp	x19,x20,[x29,#16]
	ldp	x21,x22,[x29,#32]
	ldr	x29,[sp],#48
.long	3573752767
	ret


.globl	_sub_mod_384
.private_extern	_sub_mod_384

.align	5
_sub_mod_384:
.long	3573752639
	stp	x29,x30,[sp,#-48]!
	add	x29,sp,#0
	stp	x19,x20,[sp,#16]
	stp	x21,x22,[sp,#32]

	ldp	x4,x5,[x3]
	ldp	x6,x7,[x3,#16]
	ldp	x8,x9,[x3,#32]

	bl	__sub_mod_384
	ldr	x30,[sp,#8]

	stp	x10,x11,[x0]
	stp	x12,x13,[x0,#16]
	stp	x14,x15,[x0,#32]

	ldp	x19,x20,[x29,#16]
	ldp	x21,x22,[x29,#32]
	ldr	x29,[sp],#48
.long	3573752767
	ret



.align	5
__sub_mod_384:
	ldp	x10,x11,[x1]
	ldp	x16,x17,[x2]
	ldp	x12,x13,[x1,#16]
	ldp	x19,x20,[x2,#16]
	ldp	x14,x15,[x1,#32]
	ldp	x21,x22,[x2,#32]

	subs	x10,x10,x16
	sbcs	x11,x11,x17
	sbcs	x12,x12,x19
	sbcs	x13,x13,x20
	sbcs	x14,x14,x21
	sbcs	x15,x15,x22
	sbc	x3,xzr,xzr

	and	x16,x4,x3
	and	x17,x5,x3
	adds	x10,x10,x16
	and	x19,x6,x3
	adcs	x11,x11,x17
	and	x20,x7,x3
	adcs	x12,x12,x19
	and	x21,x8,x3
	adcs	x13,x13,x20
	and	x22,x9,x3
	adcs	x14,x14,x21
	adc	x15,x15,x22

	ret


.globl	_sub_mod_384x
.private_extern	_sub_mod_384x

.align	5
_sub_mod_384x:
.long	3573752639
	stp	x29,x30,[sp,#-48]!
	add	x29,sp,#0
	stp	x19,x20,[sp,#16]
	stp	x21,x22,[sp,#32]

	ldp	x4,x5,[x3]
	ldp	x6,x7,[x3,#16]
	ldp	x8,x9,[x3,#32]

	bl	__sub_mod_384

	stp	x10,x11,[x0]
	add	x1,x1,#48
	stp	x12,x13,[x0,#16]
	add	x2,x2,#48
	stp	x14,x15,[x0,#32]

	bl	__sub_mod_384
	ldr	x30,[sp,#8]

	stp	x10,x11,[x0,#48]
	stp	x12,x13,[x0,#64]
	stp	x14,x15,[x0,#80]

	ldp	x19,x20,[x29,#16]
	ldp	x21,x22,[x29,#32]
	ldr	x29,[sp],#48
.long	3573752767
	ret


.globl	_mul_by_1_plus_i_mod_384x
.private_extern	_mul_by_1_plus_i_mod_384x

.align	5
_mul_by_1_plus_i_mod_384x:
.long	3573752639
	stp	x29,x30,[sp,#-48]!
	add	x29,sp,#0
	stp	x19,x20,[sp,#16]
	stp	x21,x22,[sp,#32]

	ldp	x4,x5,[x2]
	ldp	x6,x7,[x2,#16]
	ldp	x8,x9,[x2,#32]
	add	x2,x1,#48

	bl	__sub_mod_384			// a->re - a->im

	ldp	x16,x17,[x1]
	ldp	x19,x20,[x1,#16]
	ldp	x21,x22,[x1,#32]
	stp	x10,x11,[x0]
	ldp	x10,x11,[x1,#48]
	stp	x12,x13,[x0,#16]
	ldp	x12,x13,[x1,#64]
	stp	x14,x15,[x0,#32]
	ldp	x14,x15,[x1,#80]

	bl	__add_mod_384_ab_are_loaded	// a->re + a->im
	ldr	x30,[sp,#8]

	stp	x10,x11,[x0,#48]
	stp	x12,x13,[x0,#64]
	stp	x14,x15,[x0,#80]

	ldp	x19,x20,[x29,#16]
	ldp	x21,x22,[x29,#32]
	ldr	x29,[sp],#48
.long	3573752767
	ret


.globl	_sgn0_pty_mod_384
.private_extern	_sgn0_pty_mod_384

.align	5
_sgn0_pty_mod_384:
	ldp	x10,x11,[x0]
	ldp	x12,x13,[x0,#16]
	ldp	x14,x15,[x0,#32]

	ldp	x4,x5,[x1]
	ldp	x6,x7,[x1,#16]
	ldp	x8,x9,[x1,#32]

	and	x0,x10,#1
	adds	x10,x10,x10
	adcs	x11,x11,x11
	adcs	x12,x12,x12
	adcs	x13,x13,x13
	adcs	x14,x14,x14
	adcs	x15,x15,x15
	adc	x3,xzr,xzr

	subs	x10,x10,x4
	sbcs	x11,x11,x5
	sbcs	x12,x12,x6
	sbcs	x13,x13,x7
	sbcs	x14,x14,x8
	sbcs	x15,x15,x9
	sbc	x3,x3,xzr

	mvn	x3,x3
	and	x3,x3,#2
	orr	x0,x0,x3

	ret


.globl	_sgn0_pty_mod_384x
.private_extern	_sgn0_pty_mod_384x

.align	5
_sgn0_pty_mod_384x:
	ldp	x10,x11,[x0]
	ldp	x12,x13,[x0,#16]
	ldp	x14,x15,[x0,#32]

	ldp	x4,x5,[x1]
	ldp	x6,x7,[x1,#16]
	ldp	x8,x9,[x1,#32]

	and	x2,x10,#1
	orr	x3,x10,x11
	adds	x10,x10,x10
	orr	x3,x3,x12
	adcs	x11,x11,x11
	orr	x3,x3,x13
	adcs	x12,x12,x12
	orr	x3,x3,x14
	adcs	x13,x13,x13
	orr	x3,x3,x15
	adcs	x14,x14,x14
	adcs	x15,x15,x15
	adc	x16,xzr,xzr

	subs	x10,x10,x4
	sbcs	x11,x11,x5
	sbcs	x12,x12,x6
	sbcs	x13,x13,x7
	sbcs	x14,x14,x8
	sbcs	x15,x15,x9
	sbc	x16,x16,xzr

	ldp	x10,x11,[x0,#48]
	ldp	x12,x13,[x0,#64]
	ldp	x14,x15,[x0,#80]

	mvn	x16,x16
	and	x16,x16,#2
	orr	x2,x2,x16

	and	x0,x10,#1
	orr	x1,x10,x11
	adds	x10,x10,x10
	orr	x1,x1,x12
	adcs	x11,x11,x11
	orr	x1,x1,x13
	adcs	x12,x12,x12
	orr	x1,x1,x14
	adcs	x13,x13,x13
	orr	x1,x1,x15
	adcs	x14,x14,x14
	adcs	x15,x15,x15
	adc	x16,xzr,xzr

	subs	x10,x10,x4
	sbcs	x11,x11,x5
	sbcs	x12,x12,x6
	sbcs	x13,x13,x7
	sbcs	x14,x14,x8
	sbcs	x15,x15,x9
	sbc	x16,x16,xzr

	mvn	x16,x16
	and	x16,x16,#2
	orr	x0,x0,x16

	cmp	x3,#0
	csel	x3,x0,x2,eq	// a->re==0? prty(a->im) : prty(a->re)

	cmp	x1,#0
	csel	x1,x0,x2,ne	// a->im!=0? sgn0(a->im) : sgn0(a->re)

	and	x3,x3,#1
	and	x1,x1,#2
	orr	x0,x1,x3	// pack sign and parity

	ret
