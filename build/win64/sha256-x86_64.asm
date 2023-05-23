OPTION	DOTNAME
PUBLIC	blst_sha256_block_data_order_shaext


ALIGN	64
blst_sha256_block_data_order_shaext	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_blst_sha256_block_data_order_shaext::
	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8



	sub	rsp,058h

	movaps	XMMWORD PTR[(-88)+r11],xmm6

	movaps	XMMWORD PTR[(-72)+r11],xmm7

	movaps	XMMWORD PTR[(-56)+r11],xmm8

	movaps	XMMWORD PTR[(-40)+r11],xmm9

	movaps	XMMWORD PTR[(-24)+r11],xmm10

$L$SEH_body_blst_sha256_block_data_order_shaext::

	lea	rcx,QWORD PTR[((K256+128))]
	movdqu	xmm1,XMMWORD PTR[rdi]
	movdqu	xmm2,XMMWORD PTR[16+rdi]
	movdqa	xmm7,XMMWORD PTR[((256-128))+rcx]

	pshufd	xmm0,xmm1,01bh
	pshufd	xmm1,xmm1,0b1h
	pshufd	xmm2,xmm2,01bh
	movdqa	xmm8,xmm7
DB	102,15,58,15,202,8
	punpcklqdq	xmm2,xmm0
	jmp	$L$oop_shaext

ALIGN	16
$L$oop_shaext::
	movdqu	xmm3,XMMWORD PTR[rsi]
	movdqu	xmm4,XMMWORD PTR[16+rsi]
	movdqu	xmm5,XMMWORD PTR[32+rsi]
DB	102,15,56,0,223
	movdqu	xmm6,XMMWORD PTR[48+rsi]

	movdqa	xmm0,XMMWORD PTR[((0-128))+rcx]
	paddd	xmm0,xmm3
DB	102,15,56,0,231
	movdqa	xmm10,xmm2
DB	15,56,203,209
	pshufd	xmm0,xmm0,00eh
	nop
	movdqa	xmm9,xmm1
DB	15,56,203,202

	movdqa	xmm0,XMMWORD PTR[((16-128))+rcx]
	paddd	xmm0,xmm4
DB	102,15,56,0,239
DB	15,56,203,209
	pshufd	xmm0,xmm0,00eh
	lea	rsi,QWORD PTR[64+rsi]
DB	15,56,204,220
DB	15,56,203,202

	movdqa	xmm0,XMMWORD PTR[((32-128))+rcx]
	paddd	xmm0,xmm5
DB	102,15,56,0,247
DB	15,56,203,209
	pshufd	xmm0,xmm0,00eh
	movdqa	xmm7,xmm6
DB	102,15,58,15,253,4
	nop
	paddd	xmm3,xmm7
DB	15,56,204,229
DB	15,56,203,202

	movdqa	xmm0,XMMWORD PTR[((48-128))+rcx]
	paddd	xmm0,xmm6
DB	15,56,205,222
DB	15,56,203,209
	pshufd	xmm0,xmm0,00eh
	movdqa	xmm7,xmm3
DB	102,15,58,15,254,4
	nop
	paddd	xmm4,xmm7
DB	15,56,204,238
DB	15,56,203,202
	movdqa	xmm0,XMMWORD PTR[((64-128))+rcx]
	paddd	xmm0,xmm3
DB	15,56,205,227
DB	15,56,203,209
	pshufd	xmm0,xmm0,00eh
	movdqa	xmm7,xmm4
DB	102,15,58,15,251,4
	nop
	paddd	xmm5,xmm7
DB	15,56,204,243
DB	15,56,203,202
	movdqa	xmm0,XMMWORD PTR[((80-128))+rcx]
	paddd	xmm0,xmm4
DB	15,56,205,236
DB	15,56,203,209
	pshufd	xmm0,xmm0,00eh
	movdqa	xmm7,xmm5
DB	102,15,58,15,252,4
	nop
	paddd	xmm6,xmm7
DB	15,56,204,220
DB	15,56,203,202
	movdqa	xmm0,XMMWORD PTR[((96-128))+rcx]
	paddd	xmm0,xmm5
DB	15,56,205,245
DB	15,56,203,209
	pshufd	xmm0,xmm0,00eh
	movdqa	xmm7,xmm6
DB	102,15,58,15,253,4
	nop
	paddd	xmm3,xmm7
DB	15,56,204,229
DB	15,56,203,202
	movdqa	xmm0,XMMWORD PTR[((112-128))+rcx]
	paddd	xmm0,xmm6
DB	15,56,205,222
DB	15,56,203,209
	pshufd	xmm0,xmm0,00eh
	movdqa	xmm7,xmm3
DB	102,15,58,15,254,4
	nop
	paddd	xmm4,xmm7
DB	15,56,204,238
DB	15,56,203,202
	movdqa	xmm0,XMMWORD PTR[((128-128))+rcx]
	paddd	xmm0,xmm3
DB	15,56,205,227
DB	15,56,203,209
	pshufd	xmm0,xmm0,00eh
	movdqa	xmm7,xmm4
DB	102,15,58,15,251,4
	nop
	paddd	xmm5,xmm7
DB	15,56,204,243
DB	15,56,203,202
	movdqa	xmm0,XMMWORD PTR[((144-128))+rcx]
	paddd	xmm0,xmm4
DB	15,56,205,236
DB	15,56,203,209
	pshufd	xmm0,xmm0,00eh
	movdqa	xmm7,xmm5
DB	102,15,58,15,252,4
	nop
	paddd	xmm6,xmm7
DB	15,56,204,220
DB	15,56,203,202
	movdqa	xmm0,XMMWORD PTR[((160-128))+rcx]
	paddd	xmm0,xmm5
DB	15,56,205,245
DB	15,56,203,209
	pshufd	xmm0,xmm0,00eh
	movdqa	xmm7,xmm6
DB	102,15,58,15,253,4
	nop
	paddd	xmm3,xmm7
DB	15,56,204,229
DB	15,56,203,202
	movdqa	xmm0,XMMWORD PTR[((176-128))+rcx]
	paddd	xmm0,xmm6
DB	15,56,205,222
DB	15,56,203,209
	pshufd	xmm0,xmm0,00eh
	movdqa	xmm7,xmm3
DB	102,15,58,15,254,4
	nop
	paddd	xmm4,xmm7
DB	15,56,204,238
DB	15,56,203,202
	movdqa	xmm0,XMMWORD PTR[((192-128))+rcx]
	paddd	xmm0,xmm3
DB	15,56,205,227
DB	15,56,203,209
	pshufd	xmm0,xmm0,00eh
	movdqa	xmm7,xmm4
DB	102,15,58,15,251,4
	nop
	paddd	xmm5,xmm7
DB	15,56,204,243
DB	15,56,203,202
	movdqa	xmm0,XMMWORD PTR[((208-128))+rcx]
	paddd	xmm0,xmm4
DB	15,56,205,236
DB	15,56,203,209
	pshufd	xmm0,xmm0,00eh
	movdqa	xmm7,xmm5
DB	102,15,58,15,252,4
DB	15,56,203,202
	paddd	xmm6,xmm7

	movdqa	xmm0,XMMWORD PTR[((224-128))+rcx]
	paddd	xmm0,xmm5
DB	15,56,203,209
	pshufd	xmm0,xmm0,00eh
DB	15,56,205,245
	movdqa	xmm7,xmm8
DB	15,56,203,202

	movdqa	xmm0,XMMWORD PTR[((240-128))+rcx]
	paddd	xmm0,xmm6
	nop
DB	15,56,203,209
	pshufd	xmm0,xmm0,00eh
	dec	rdx
	nop
DB	15,56,203,202

	paddd	xmm2,xmm10
	paddd	xmm1,xmm9
	jnz	$L$oop_shaext

	pshufd	xmm2,xmm2,0b1h
	pshufd	xmm7,xmm1,01bh
	pshufd	xmm1,xmm1,0b1h
	punpckhqdq	xmm1,xmm2
DB	102,15,58,15,215,8

	movdqu	XMMWORD PTR[rdi],xmm1
	movdqu	XMMWORD PTR[16+rdi],xmm2
	movaps	xmm6,XMMWORD PTR[((-88))+r11]
	movaps	xmm7,XMMWORD PTR[((-72))+r11]
	movaps	xmm8,XMMWORD PTR[((-56))+r11]
	movaps	xmm9,XMMWORD PTR[((-40))+r11]
	movaps	xmm10,XMMWORD PTR[((-24))+r11]
	mov	rsp,r11

$L$SEH_epilogue_blst_sha256_block_data_order_shaext::
	mov	rdi,QWORD PTR[8+r11]	;WIN64 epilogue
	mov	rsi,QWORD PTR[16+r11]

	DB	0F3h,0C3h		;repret

$L$SEH_end_blst_sha256_block_data_order_shaext::
blst_sha256_block_data_order_shaext	ENDP
PUBLIC	blst_sha256_block_data_order


ALIGN	64
blst_sha256_block_data_order	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_blst_sha256_block_data_order::
	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8



	push	rbp

	push	rbx

	push	r12

	push	r13

	push	r14

	push	r15

	shl	rdx,4
	sub	rsp,104

	lea	rdx,QWORD PTR[rdx*4+rsi]
	mov	QWORD PTR[rsp],rdi

	mov	QWORD PTR[16+rsp],rdx
	movaps	XMMWORD PTR[32+rsp],xmm6

	movaps	XMMWORD PTR[48+rsp],xmm7

	movaps	XMMWORD PTR[64+rsp],xmm8

	movaps	XMMWORD PTR[80+rsp],xmm9

	mov	rbp,rsp

$L$SEH_body_blst_sha256_block_data_order::


	lea	rsp,QWORD PTR[((-64))+rsp]
	mov	eax,DWORD PTR[rdi]
	and	rsp,-64
	mov	ebx,DWORD PTR[4+rdi]
	mov	ecx,DWORD PTR[8+rdi]
	mov	edx,DWORD PTR[12+rdi]
	mov	r8d,DWORD PTR[16+rdi]
	mov	r9d,DWORD PTR[20+rdi]
	mov	r10d,DWORD PTR[24+rdi]
	mov	r11d,DWORD PTR[28+rdi]


	jmp	$L$loop_ssse3
ALIGN	16
$L$loop_ssse3::
	movdqa	xmm7,XMMWORD PTR[((K256+256))]
	mov	QWORD PTR[8+rbp],rsi
	movdqu	xmm0,XMMWORD PTR[rsi]
	movdqu	xmm1,XMMWORD PTR[16+rsi]
	movdqu	xmm2,XMMWORD PTR[32+rsi]
DB	102,15,56,0,199
	movdqu	xmm3,XMMWORD PTR[48+rsi]
	lea	rsi,QWORD PTR[K256]
DB	102,15,56,0,207
	movdqa	xmm4,XMMWORD PTR[rsi]
	movdqa	xmm5,XMMWORD PTR[16+rsi]
DB	102,15,56,0,215
	paddd	xmm4,xmm0
	movdqa	xmm6,XMMWORD PTR[32+rsi]
DB	102,15,56,0,223
	movdqa	xmm7,XMMWORD PTR[48+rsi]
	paddd	xmm5,xmm1
	paddd	xmm6,xmm2
	paddd	xmm7,xmm3
	movdqa	XMMWORD PTR[rsp],xmm4
	mov	r14d,eax
	movdqa	XMMWORD PTR[16+rsp],xmm5
	mov	edi,ebx
	movdqa	XMMWORD PTR[32+rsp],xmm6
	xor	edi,ecx
	movdqa	XMMWORD PTR[48+rsp],xmm7
	mov	r13d,r8d
	jmp	$L$ssse3_00_47

ALIGN	16
$L$ssse3_00_47::
	sub	rsi,-64
	ror	r13d,14
	movdqa	xmm4,xmm1
	mov	eax,r14d
	mov	r12d,r9d
	movdqa	xmm7,xmm3
	ror	r14d,9
	xor	r13d,r8d
	xor	r12d,r10d
	ror	r13d,5
	xor	r14d,eax
DB	102,15,58,15,224,4
	and	r12d,r8d
	xor	r13d,r8d
DB	102,15,58,15,250,4
	add	r11d,DWORD PTR[rsp]
	mov	r15d,eax
	xor	r12d,r10d
	ror	r14d,11
	movdqa	xmm5,xmm4
	xor	r15d,ebx
	add	r11d,r12d
	movdqa	xmm6,xmm4
	ror	r13d,6
	and	edi,r15d
	psrld	xmm4,3
	xor	r14d,eax
	add	r11d,r13d
	xor	edi,ebx
	paddd	xmm0,xmm7
	ror	r14d,2
	add	edx,r11d
	psrld	xmm6,7
	add	r11d,edi
	mov	r13d,edx
	pshufd	xmm7,xmm3,250
	add	r14d,r11d
	ror	r13d,14
	pslld	xmm5,14
	mov	r11d,r14d
	mov	r12d,r8d
	pxor	xmm4,xmm6
	ror	r14d,9
	xor	r13d,edx
	xor	r12d,r9d
	ror	r13d,5
	psrld	xmm6,11
	xor	r14d,r11d
	pxor	xmm4,xmm5
	and	r12d,edx
	xor	r13d,edx
	pslld	xmm5,11
	add	r10d,DWORD PTR[4+rsp]
	mov	edi,r11d
	pxor	xmm4,xmm6
	xor	r12d,r9d
	ror	r14d,11
	movdqa	xmm6,xmm7
	xor	edi,eax
	add	r10d,r12d
	pxor	xmm4,xmm5
	ror	r13d,6
	and	r15d,edi
	xor	r14d,r11d
	psrld	xmm7,10
	add	r10d,r13d
	xor	r15d,eax
	paddd	xmm0,xmm4
	ror	r14d,2
	add	ecx,r10d
	psrlq	xmm6,17
	add	r10d,r15d
	mov	r13d,ecx
	add	r14d,r10d
	pxor	xmm7,xmm6
	ror	r13d,14
	mov	r10d,r14d
	mov	r12d,edx
	ror	r14d,9
	psrlq	xmm6,2
	xor	r13d,ecx
	xor	r12d,r8d
	pxor	xmm7,xmm6
	ror	r13d,5
	xor	r14d,r10d
	and	r12d,ecx
	pshufd	xmm7,xmm7,128
	xor	r13d,ecx
	add	r9d,DWORD PTR[8+rsp]
	mov	r15d,r10d
	psrldq	xmm7,8
	xor	r12d,r8d
	ror	r14d,11
	xor	r15d,r11d
	add	r9d,r12d
	ror	r13d,6
	paddd	xmm0,xmm7
	and	edi,r15d
	xor	r14d,r10d
	add	r9d,r13d
	pshufd	xmm7,xmm0,80
	xor	edi,r11d
	ror	r14d,2
	add	ebx,r9d
	movdqa	xmm6,xmm7
	add	r9d,edi
	mov	r13d,ebx
	psrld	xmm7,10
	add	r14d,r9d
	ror	r13d,14
	psrlq	xmm6,17
	mov	r9d,r14d
	mov	r12d,ecx
	pxor	xmm7,xmm6
	ror	r14d,9
	xor	r13d,ebx
	xor	r12d,edx
	ror	r13d,5
	xor	r14d,r9d
	psrlq	xmm6,2
	and	r12d,ebx
	xor	r13d,ebx
	add	r8d,DWORD PTR[12+rsp]
	pxor	xmm7,xmm6
	mov	edi,r9d
	xor	r12d,edx
	ror	r14d,11
	pshufd	xmm7,xmm7,8
	xor	edi,r10d
	add	r8d,r12d
	movdqa	xmm6,XMMWORD PTR[rsi]
	ror	r13d,6
	and	r15d,edi
	pslldq	xmm7,8
	xor	r14d,r9d
	add	r8d,r13d
	xor	r15d,r10d
	paddd	xmm0,xmm7
	ror	r14d,2
	add	eax,r8d
	add	r8d,r15d
	paddd	xmm6,xmm0
	mov	r13d,eax
	add	r14d,r8d
	movdqa	XMMWORD PTR[rsp],xmm6
	ror	r13d,14
	movdqa	xmm4,xmm2
	mov	r8d,r14d
	mov	r12d,ebx
	movdqa	xmm7,xmm0
	ror	r14d,9
	xor	r13d,eax
	xor	r12d,ecx
	ror	r13d,5
	xor	r14d,r8d
DB	102,15,58,15,225,4
	and	r12d,eax
	xor	r13d,eax
DB	102,15,58,15,251,4
	add	edx,DWORD PTR[16+rsp]
	mov	r15d,r8d
	xor	r12d,ecx
	ror	r14d,11
	movdqa	xmm5,xmm4
	xor	r15d,r9d
	add	edx,r12d
	movdqa	xmm6,xmm4
	ror	r13d,6
	and	edi,r15d
	psrld	xmm4,3
	xor	r14d,r8d
	add	edx,r13d
	xor	edi,r9d
	paddd	xmm1,xmm7
	ror	r14d,2
	add	r11d,edx
	psrld	xmm6,7
	add	edx,edi
	mov	r13d,r11d
	pshufd	xmm7,xmm0,250
	add	r14d,edx
	ror	r13d,14
	pslld	xmm5,14
	mov	edx,r14d
	mov	r12d,eax
	pxor	xmm4,xmm6
	ror	r14d,9
	xor	r13d,r11d
	xor	r12d,ebx
	ror	r13d,5
	psrld	xmm6,11
	xor	r14d,edx
	pxor	xmm4,xmm5
	and	r12d,r11d
	xor	r13d,r11d
	pslld	xmm5,11
	add	ecx,DWORD PTR[20+rsp]
	mov	edi,edx
	pxor	xmm4,xmm6
	xor	r12d,ebx
	ror	r14d,11
	movdqa	xmm6,xmm7
	xor	edi,r8d
	add	ecx,r12d
	pxor	xmm4,xmm5
	ror	r13d,6
	and	r15d,edi
	xor	r14d,edx
	psrld	xmm7,10
	add	ecx,r13d
	xor	r15d,r8d
	paddd	xmm1,xmm4
	ror	r14d,2
	add	r10d,ecx
	psrlq	xmm6,17
	add	ecx,r15d
	mov	r13d,r10d
	add	r14d,ecx
	pxor	xmm7,xmm6
	ror	r13d,14
	mov	ecx,r14d
	mov	r12d,r11d
	ror	r14d,9
	psrlq	xmm6,2
	xor	r13d,r10d
	xor	r12d,eax
	pxor	xmm7,xmm6
	ror	r13d,5
	xor	r14d,ecx
	and	r12d,r10d
	pshufd	xmm7,xmm7,128
	xor	r13d,r10d
	add	ebx,DWORD PTR[24+rsp]
	mov	r15d,ecx
	psrldq	xmm7,8
	xor	r12d,eax
	ror	r14d,11
	xor	r15d,edx
	add	ebx,r12d
	ror	r13d,6
	paddd	xmm1,xmm7
	and	edi,r15d
	xor	r14d,ecx
	add	ebx,r13d
	pshufd	xmm7,xmm1,80
	xor	edi,edx
	ror	r14d,2
	add	r9d,ebx
	movdqa	xmm6,xmm7
	add	ebx,edi
	mov	r13d,r9d
	psrld	xmm7,10
	add	r14d,ebx
	ror	r13d,14
	psrlq	xmm6,17
	mov	ebx,r14d
	mov	r12d,r10d
	pxor	xmm7,xmm6
	ror	r14d,9
	xor	r13d,r9d
	xor	r12d,r11d
	ror	r13d,5
	xor	r14d,ebx
	psrlq	xmm6,2
	and	r12d,r9d
	xor	r13d,r9d
	add	eax,DWORD PTR[28+rsp]
	pxor	xmm7,xmm6
	mov	edi,ebx
	xor	r12d,r11d
	ror	r14d,11
	pshufd	xmm7,xmm7,8
	xor	edi,ecx
	add	eax,r12d
	movdqa	xmm6,XMMWORD PTR[16+rsi]
	ror	r13d,6
	and	r15d,edi
	pslldq	xmm7,8
	xor	r14d,ebx
	add	eax,r13d
	xor	r15d,ecx
	paddd	xmm1,xmm7
	ror	r14d,2
	add	r8d,eax
	add	eax,r15d
	paddd	xmm6,xmm1
	mov	r13d,r8d
	add	r14d,eax
	movdqa	XMMWORD PTR[16+rsp],xmm6
	ror	r13d,14
	movdqa	xmm4,xmm3
	mov	eax,r14d
	mov	r12d,r9d
	movdqa	xmm7,xmm1
	ror	r14d,9
	xor	r13d,r8d
	xor	r12d,r10d
	ror	r13d,5
	xor	r14d,eax
DB	102,15,58,15,226,4
	and	r12d,r8d
	xor	r13d,r8d
DB	102,15,58,15,248,4
	add	r11d,DWORD PTR[32+rsp]
	mov	r15d,eax
	xor	r12d,r10d
	ror	r14d,11
	movdqa	xmm5,xmm4
	xor	r15d,ebx
	add	r11d,r12d
	movdqa	xmm6,xmm4
	ror	r13d,6
	and	edi,r15d
	psrld	xmm4,3
	xor	r14d,eax
	add	r11d,r13d
	xor	edi,ebx
	paddd	xmm2,xmm7
	ror	r14d,2
	add	edx,r11d
	psrld	xmm6,7
	add	r11d,edi
	mov	r13d,edx
	pshufd	xmm7,xmm1,250
	add	r14d,r11d
	ror	r13d,14
	pslld	xmm5,14
	mov	r11d,r14d
	mov	r12d,r8d
	pxor	xmm4,xmm6
	ror	r14d,9
	xor	r13d,edx
	xor	r12d,r9d
	ror	r13d,5
	psrld	xmm6,11
	xor	r14d,r11d
	pxor	xmm4,xmm5
	and	r12d,edx
	xor	r13d,edx
	pslld	xmm5,11
	add	r10d,DWORD PTR[36+rsp]
	mov	edi,r11d
	pxor	xmm4,xmm6
	xor	r12d,r9d
	ror	r14d,11
	movdqa	xmm6,xmm7
	xor	edi,eax
	add	r10d,r12d
	pxor	xmm4,xmm5
	ror	r13d,6
	and	r15d,edi
	xor	r14d,r11d
	psrld	xmm7,10
	add	r10d,r13d
	xor	r15d,eax
	paddd	xmm2,xmm4
	ror	r14d,2
	add	ecx,r10d
	psrlq	xmm6,17
	add	r10d,r15d
	mov	r13d,ecx
	add	r14d,r10d
	pxor	xmm7,xmm6
	ror	r13d,14
	mov	r10d,r14d
	mov	r12d,edx
	ror	r14d,9
	psrlq	xmm6,2
	xor	r13d,ecx
	xor	r12d,r8d
	pxor	xmm7,xmm6
	ror	r13d,5
	xor	r14d,r10d
	and	r12d,ecx
	pshufd	xmm7,xmm7,128
	xor	r13d,ecx
	add	r9d,DWORD PTR[40+rsp]
	mov	r15d,r10d
	psrldq	xmm7,8
	xor	r12d,r8d
	ror	r14d,11
	xor	r15d,r11d
	add	r9d,r12d
	ror	r13d,6
	paddd	xmm2,xmm7
	and	edi,r15d
	xor	r14d,r10d
	add	r9d,r13d
	pshufd	xmm7,xmm2,80
	xor	edi,r11d
	ror	r14d,2
	add	ebx,r9d
	movdqa	xmm6,xmm7
	add	r9d,edi
	mov	r13d,ebx
	psrld	xmm7,10
	add	r14d,r9d
	ror	r13d,14
	psrlq	xmm6,17
	mov	r9d,r14d
	mov	r12d,ecx
	pxor	xmm7,xmm6
	ror	r14d,9
	xor	r13d,ebx
	xor	r12d,edx
	ror	r13d,5
	xor	r14d,r9d
	psrlq	xmm6,2
	and	r12d,ebx
	xor	r13d,ebx
	add	r8d,DWORD PTR[44+rsp]
	pxor	xmm7,xmm6
	mov	edi,r9d
	xor	r12d,edx
	ror	r14d,11
	pshufd	xmm7,xmm7,8
	xor	edi,r10d
	add	r8d,r12d
	movdqa	xmm6,XMMWORD PTR[32+rsi]
	ror	r13d,6
	and	r15d,edi
	pslldq	xmm7,8
	xor	r14d,r9d
	add	r8d,r13d
	xor	r15d,r10d
	paddd	xmm2,xmm7
	ror	r14d,2
	add	eax,r8d
	add	r8d,r15d
	paddd	xmm6,xmm2
	mov	r13d,eax
	add	r14d,r8d
	movdqa	XMMWORD PTR[32+rsp],xmm6
	ror	r13d,14
	movdqa	xmm4,xmm0
	mov	r8d,r14d
	mov	r12d,ebx
	movdqa	xmm7,xmm2
	ror	r14d,9
	xor	r13d,eax
	xor	r12d,ecx
	ror	r13d,5
	xor	r14d,r8d
DB	102,15,58,15,227,4
	and	r12d,eax
	xor	r13d,eax
DB	102,15,58,15,249,4
	add	edx,DWORD PTR[48+rsp]
	mov	r15d,r8d
	xor	r12d,ecx
	ror	r14d,11
	movdqa	xmm5,xmm4
	xor	r15d,r9d
	add	edx,r12d
	movdqa	xmm6,xmm4
	ror	r13d,6
	and	edi,r15d
	psrld	xmm4,3
	xor	r14d,r8d
	add	edx,r13d
	xor	edi,r9d
	paddd	xmm3,xmm7
	ror	r14d,2
	add	r11d,edx
	psrld	xmm6,7
	add	edx,edi
	mov	r13d,r11d
	pshufd	xmm7,xmm2,250
	add	r14d,edx
	ror	r13d,14
	pslld	xmm5,14
	mov	edx,r14d
	mov	r12d,eax
	pxor	xmm4,xmm6
	ror	r14d,9
	xor	r13d,r11d
	xor	r12d,ebx
	ror	r13d,5
	psrld	xmm6,11
	xor	r14d,edx
	pxor	xmm4,xmm5
	and	r12d,r11d
	xor	r13d,r11d
	pslld	xmm5,11
	add	ecx,DWORD PTR[52+rsp]
	mov	edi,edx
	pxor	xmm4,xmm6
	xor	r12d,ebx
	ror	r14d,11
	movdqa	xmm6,xmm7
	xor	edi,r8d
	add	ecx,r12d
	pxor	xmm4,xmm5
	ror	r13d,6
	and	r15d,edi
	xor	r14d,edx
	psrld	xmm7,10
	add	ecx,r13d
	xor	r15d,r8d
	paddd	xmm3,xmm4
	ror	r14d,2
	add	r10d,ecx
	psrlq	xmm6,17
	add	ecx,r15d
	mov	r13d,r10d
	add	r14d,ecx
	pxor	xmm7,xmm6
	ror	r13d,14
	mov	ecx,r14d
	mov	r12d,r11d
	ror	r14d,9
	psrlq	xmm6,2
	xor	r13d,r10d
	xor	r12d,eax
	pxor	xmm7,xmm6
	ror	r13d,5
	xor	r14d,ecx
	and	r12d,r10d
	pshufd	xmm7,xmm7,128
	xor	r13d,r10d
	add	ebx,DWORD PTR[56+rsp]
	mov	r15d,ecx
	psrldq	xmm7,8
	xor	r12d,eax
	ror	r14d,11
	xor	r15d,edx
	add	ebx,r12d
	ror	r13d,6
	paddd	xmm3,xmm7
	and	edi,r15d
	xor	r14d,ecx
	add	ebx,r13d
	pshufd	xmm7,xmm3,80
	xor	edi,edx
	ror	r14d,2
	add	r9d,ebx
	movdqa	xmm6,xmm7
	add	ebx,edi
	mov	r13d,r9d
	psrld	xmm7,10
	add	r14d,ebx
	ror	r13d,14
	psrlq	xmm6,17
	mov	ebx,r14d
	mov	r12d,r10d
	pxor	xmm7,xmm6
	ror	r14d,9
	xor	r13d,r9d
	xor	r12d,r11d
	ror	r13d,5
	xor	r14d,ebx
	psrlq	xmm6,2
	and	r12d,r9d
	xor	r13d,r9d
	add	eax,DWORD PTR[60+rsp]
	pxor	xmm7,xmm6
	mov	edi,ebx
	xor	r12d,r11d
	ror	r14d,11
	pshufd	xmm7,xmm7,8
	xor	edi,ecx
	add	eax,r12d
	movdqa	xmm6,XMMWORD PTR[48+rsi]
	ror	r13d,6
	and	r15d,edi
	pslldq	xmm7,8
	xor	r14d,ebx
	add	eax,r13d
	xor	r15d,ecx
	paddd	xmm3,xmm7
	ror	r14d,2
	add	r8d,eax
	add	eax,r15d
	paddd	xmm6,xmm3
	mov	r13d,r8d
	add	r14d,eax
	movdqa	XMMWORD PTR[48+rsp],xmm6
	cmp	BYTE PTR[67+rsi],0
	jne	$L$ssse3_00_47
	ror	r13d,14
	mov	eax,r14d
	mov	r12d,r9d
	ror	r14d,9
	xor	r13d,r8d
	xor	r12d,r10d
	ror	r13d,5
	xor	r14d,eax
	and	r12d,r8d
	xor	r13d,r8d
	add	r11d,DWORD PTR[rsp]
	mov	r15d,eax
	xor	r12d,r10d
	ror	r14d,11
	xor	r15d,ebx
	add	r11d,r12d
	ror	r13d,6
	and	edi,r15d
	xor	r14d,eax
	add	r11d,r13d
	xor	edi,ebx
	ror	r14d,2
	add	edx,r11d
	add	r11d,edi
	mov	r13d,edx
	add	r14d,r11d
	ror	r13d,14
	mov	r11d,r14d
	mov	r12d,r8d
	ror	r14d,9
	xor	r13d,edx
	xor	r12d,r9d
	ror	r13d,5
	xor	r14d,r11d
	and	r12d,edx
	xor	r13d,edx
	add	r10d,DWORD PTR[4+rsp]
	mov	edi,r11d
	xor	r12d,r9d
	ror	r14d,11
	xor	edi,eax
	add	r10d,r12d
	ror	r13d,6
	and	r15d,edi
	xor	r14d,r11d
	add	r10d,r13d
	xor	r15d,eax
	ror	r14d,2
	add	ecx,r10d
	add	r10d,r15d
	mov	r13d,ecx
	add	r14d,r10d
	ror	r13d,14
	mov	r10d,r14d
	mov	r12d,edx
	ror	r14d,9
	xor	r13d,ecx
	xor	r12d,r8d
	ror	r13d,5
	xor	r14d,r10d
	and	r12d,ecx
	xor	r13d,ecx
	add	r9d,DWORD PTR[8+rsp]
	mov	r15d,r10d
	xor	r12d,r8d
	ror	r14d,11
	xor	r15d,r11d
	add	r9d,r12d
	ror	r13d,6
	and	edi,r15d
	xor	r14d,r10d
	add	r9d,r13d
	xor	edi,r11d
	ror	r14d,2
	add	ebx,r9d
	add	r9d,edi
	mov	r13d,ebx
	add	r14d,r9d
	ror	r13d,14
	mov	r9d,r14d
	mov	r12d,ecx
	ror	r14d,9
	xor	r13d,ebx
	xor	r12d,edx
	ror	r13d,5
	xor	r14d,r9d
	and	r12d,ebx
	xor	r13d,ebx
	add	r8d,DWORD PTR[12+rsp]
	mov	edi,r9d
	xor	r12d,edx
	ror	r14d,11
	xor	edi,r10d
	add	r8d,r12d
	ror	r13d,6
	and	r15d,edi
	xor	r14d,r9d
	add	r8d,r13d
	xor	r15d,r10d
	ror	r14d,2
	add	eax,r8d
	add	r8d,r15d
	mov	r13d,eax
	add	r14d,r8d
	ror	r13d,14
	mov	r8d,r14d
	mov	r12d,ebx
	ror	r14d,9
	xor	r13d,eax
	xor	r12d,ecx
	ror	r13d,5
	xor	r14d,r8d
	and	r12d,eax
	xor	r13d,eax
	add	edx,DWORD PTR[16+rsp]
	mov	r15d,r8d
	xor	r12d,ecx
	ror	r14d,11
	xor	r15d,r9d
	add	edx,r12d
	ror	r13d,6
	and	edi,r15d
	xor	r14d,r8d
	add	edx,r13d
	xor	edi,r9d
	ror	r14d,2
	add	r11d,edx
	add	edx,edi
	mov	r13d,r11d
	add	r14d,edx
	ror	r13d,14
	mov	edx,r14d
	mov	r12d,eax
	ror	r14d,9
	xor	r13d,r11d
	xor	r12d,ebx
	ror	r13d,5
	xor	r14d,edx
	and	r12d,r11d
	xor	r13d,r11d
	add	ecx,DWORD PTR[20+rsp]
	mov	edi,edx
	xor	r12d,ebx
	ror	r14d,11
	xor	edi,r8d
	add	ecx,r12d
	ror	r13d,6
	and	r15d,edi
	xor	r14d,edx
	add	ecx,r13d
	xor	r15d,r8d
	ror	r14d,2
	add	r10d,ecx
	add	ecx,r15d
	mov	r13d,r10d
	add	r14d,ecx
	ror	r13d,14
	mov	ecx,r14d
	mov	r12d,r11d
	ror	r14d,9
	xor	r13d,r10d
	xor	r12d,eax
	ror	r13d,5
	xor	r14d,ecx
	and	r12d,r10d
	xor	r13d,r10d
	add	ebx,DWORD PTR[24+rsp]
	mov	r15d,ecx
	xor	r12d,eax
	ror	r14d,11
	xor	r15d,edx
	add	ebx,r12d
	ror	r13d,6
	and	edi,r15d
	xor	r14d,ecx
	add	ebx,r13d
	xor	edi,edx
	ror	r14d,2
	add	r9d,ebx
	add	ebx,edi
	mov	r13d,r9d
	add	r14d,ebx
	ror	r13d,14
	mov	ebx,r14d
	mov	r12d,r10d
	ror	r14d,9
	xor	r13d,r9d
	xor	r12d,r11d
	ror	r13d,5
	xor	r14d,ebx
	and	r12d,r9d
	xor	r13d,r9d
	add	eax,DWORD PTR[28+rsp]
	mov	edi,ebx
	xor	r12d,r11d
	ror	r14d,11
	xor	edi,ecx
	add	eax,r12d
	ror	r13d,6
	and	r15d,edi
	xor	r14d,ebx
	add	eax,r13d
	xor	r15d,ecx
	ror	r14d,2
	add	r8d,eax
	add	eax,r15d
	mov	r13d,r8d
	add	r14d,eax
	ror	r13d,14
	mov	eax,r14d
	mov	r12d,r9d
	ror	r14d,9
	xor	r13d,r8d
	xor	r12d,r10d
	ror	r13d,5
	xor	r14d,eax
	and	r12d,r8d
	xor	r13d,r8d
	add	r11d,DWORD PTR[32+rsp]
	mov	r15d,eax
	xor	r12d,r10d
	ror	r14d,11
	xor	r15d,ebx
	add	r11d,r12d
	ror	r13d,6
	and	edi,r15d
	xor	r14d,eax
	add	r11d,r13d
	xor	edi,ebx
	ror	r14d,2
	add	edx,r11d
	add	r11d,edi
	mov	r13d,edx
	add	r14d,r11d
	ror	r13d,14
	mov	r11d,r14d
	mov	r12d,r8d
	ror	r14d,9
	xor	r13d,edx
	xor	r12d,r9d
	ror	r13d,5
	xor	r14d,r11d
	and	r12d,edx
	xor	r13d,edx
	add	r10d,DWORD PTR[36+rsp]
	mov	edi,r11d
	xor	r12d,r9d
	ror	r14d,11
	xor	edi,eax
	add	r10d,r12d
	ror	r13d,6
	and	r15d,edi
	xor	r14d,r11d
	add	r10d,r13d
	xor	r15d,eax
	ror	r14d,2
	add	ecx,r10d
	add	r10d,r15d
	mov	r13d,ecx
	add	r14d,r10d
	ror	r13d,14
	mov	r10d,r14d
	mov	r12d,edx
	ror	r14d,9
	xor	r13d,ecx
	xor	r12d,r8d
	ror	r13d,5
	xor	r14d,r10d
	and	r12d,ecx
	xor	r13d,ecx
	add	r9d,DWORD PTR[40+rsp]
	mov	r15d,r10d
	xor	r12d,r8d
	ror	r14d,11
	xor	r15d,r11d
	add	r9d,r12d
	ror	r13d,6
	and	edi,r15d
	xor	r14d,r10d
	add	r9d,r13d
	xor	edi,r11d
	ror	r14d,2
	add	ebx,r9d
	add	r9d,edi
	mov	r13d,ebx
	add	r14d,r9d
	ror	r13d,14
	mov	r9d,r14d
	mov	r12d,ecx
	ror	r14d,9
	xor	r13d,ebx
	xor	r12d,edx
	ror	r13d,5
	xor	r14d,r9d
	and	r12d,ebx
	xor	r13d,ebx
	add	r8d,DWORD PTR[44+rsp]
	mov	edi,r9d
	xor	r12d,edx
	ror	r14d,11
	xor	edi,r10d
	add	r8d,r12d
	ror	r13d,6
	and	r15d,edi
	xor	r14d,r9d
	add	r8d,r13d
	xor	r15d,r10d
	ror	r14d,2
	add	eax,r8d
	add	r8d,r15d
	mov	r13d,eax
	add	r14d,r8d
	ror	r13d,14
	mov	r8d,r14d
	mov	r12d,ebx
	ror	r14d,9
	xor	r13d,eax
	xor	r12d,ecx
	ror	r13d,5
	xor	r14d,r8d
	and	r12d,eax
	xor	r13d,eax
	add	edx,DWORD PTR[48+rsp]
	mov	r15d,r8d
	xor	r12d,ecx
	ror	r14d,11
	xor	r15d,r9d
	add	edx,r12d
	ror	r13d,6
	and	edi,r15d
	xor	r14d,r8d
	add	edx,r13d
	xor	edi,r9d
	ror	r14d,2
	add	r11d,edx
	add	edx,edi
	mov	r13d,r11d
	add	r14d,edx
	ror	r13d,14
	mov	edx,r14d
	mov	r12d,eax
	ror	r14d,9
	xor	r13d,r11d
	xor	r12d,ebx
	ror	r13d,5
	xor	r14d,edx
	and	r12d,r11d
	xor	r13d,r11d
	add	ecx,DWORD PTR[52+rsp]
	mov	edi,edx
	xor	r12d,ebx
	ror	r14d,11
	xor	edi,r8d
	add	ecx,r12d
	ror	r13d,6
	and	r15d,edi
	xor	r14d,edx
	add	ecx,r13d
	xor	r15d,r8d
	ror	r14d,2
	add	r10d,ecx
	add	ecx,r15d
	mov	r13d,r10d
	add	r14d,ecx
	ror	r13d,14
	mov	ecx,r14d
	mov	r12d,r11d
	ror	r14d,9
	xor	r13d,r10d
	xor	r12d,eax
	ror	r13d,5
	xor	r14d,ecx
	and	r12d,r10d
	xor	r13d,r10d
	add	ebx,DWORD PTR[56+rsp]
	mov	r15d,ecx
	xor	r12d,eax
	ror	r14d,11
	xor	r15d,edx
	add	ebx,r12d
	ror	r13d,6
	and	edi,r15d
	xor	r14d,ecx
	add	ebx,r13d
	xor	edi,edx
	ror	r14d,2
	add	r9d,ebx
	add	ebx,edi
	mov	r13d,r9d
	add	r14d,ebx
	ror	r13d,14
	mov	ebx,r14d
	mov	r12d,r10d
	ror	r14d,9
	xor	r13d,r9d
	xor	r12d,r11d
	ror	r13d,5
	xor	r14d,ebx
	and	r12d,r9d
	xor	r13d,r9d
	add	eax,DWORD PTR[60+rsp]
	mov	edi,ebx
	xor	r12d,r11d
	ror	r14d,11
	xor	edi,ecx
	add	eax,r12d
	ror	r13d,6
	and	r15d,edi
	xor	r14d,ebx
	add	eax,r13d
	xor	r15d,ecx
	ror	r14d,2
	add	r8d,eax
	add	eax,r15d
	mov	r13d,r8d
	add	r14d,eax
	mov	rdi,QWORD PTR[rbp]
	mov	eax,r14d
	mov	rsi,QWORD PTR[8+rbp]

	add	eax,DWORD PTR[rdi]
	add	ebx,DWORD PTR[4+rdi]
	add	ecx,DWORD PTR[8+rdi]
	add	edx,DWORD PTR[12+rdi]
	add	r8d,DWORD PTR[16+rdi]
	add	r9d,DWORD PTR[20+rdi]
	add	r10d,DWORD PTR[24+rdi]
	add	r11d,DWORD PTR[28+rdi]

	lea	rsi,QWORD PTR[64+rsi]
	cmp	rsi,QWORD PTR[16+rbp]

	mov	DWORD PTR[rdi],eax
	mov	DWORD PTR[4+rdi],ebx
	mov	DWORD PTR[8+rdi],ecx
	mov	DWORD PTR[12+rdi],edx
	mov	DWORD PTR[16+rdi],r8d
	mov	DWORD PTR[20+rdi],r9d
	mov	DWORD PTR[24+rdi],r10d
	mov	DWORD PTR[28+rdi],r11d
	jb	$L$loop_ssse3

	xorps	xmm0,xmm0
	lea	r11,QWORD PTR[((104+48))+rbp]

	movaps	XMMWORD PTR[rsp],xmm0
	movaps	XMMWORD PTR[16+rsp],xmm0
	movaps	XMMWORD PTR[32+rsp],xmm0
	movaps	XMMWORD PTR[48+rsp],xmm0
	movaps	xmm6,XMMWORD PTR[32+rbp]
	movaps	xmm7,XMMWORD PTR[48+rbp]
	movaps	xmm8,XMMWORD PTR[64+rbp]
	movaps	xmm9,XMMWORD PTR[80+rbp]
	mov	r15,QWORD PTR[104+rbp]

	mov	r14,QWORD PTR[((-40))+r11]

	mov	r13,QWORD PTR[((-32))+r11]

	mov	r12,QWORD PTR[((-24))+r11]

	mov	rbx,QWORD PTR[((-16))+r11]

	mov	rbp,QWORD PTR[((-8))+r11]

$L$SEH_epilogue_blst_sha256_block_data_order::
	mov	rdi,QWORD PTR[8+r11]	;WIN64 epilogue
	mov	rsi,QWORD PTR[16+r11]

	lea	rsp,QWORD PTR[r11]
	DB	0F3h,0C3h		;repret

$L$SEH_end_blst_sha256_block_data_order::
blst_sha256_block_data_order	ENDP
.pdata	SEGMENT READONLY ALIGN(4)
ALIGN	4
	DD	imagerel $L$SEH_begin_blst_sha256_block_data_order_shaext
	DD	imagerel $L$SEH_body_blst_sha256_block_data_order_shaext
	DD	imagerel $L$SEH_info_blst_sha256_block_data_order_shaext_prologue

	DD	imagerel $L$SEH_body_blst_sha256_block_data_order_shaext
	DD	imagerel $L$SEH_epilogue_blst_sha256_block_data_order_shaext
	DD	imagerel $L$SEH_info_blst_sha256_block_data_order_shaext_body

	DD	imagerel $L$SEH_epilogue_blst_sha256_block_data_order_shaext
	DD	imagerel $L$SEH_end_blst_sha256_block_data_order_shaext
	DD	imagerel $L$SEH_info_blst_sha256_block_data_order_shaext_epilogue

	DD	imagerel $L$SEH_begin_blst_sha256_block_data_order
	DD	imagerel $L$SEH_body_blst_sha256_block_data_order
	DD	imagerel $L$SEH_info_blst_sha256_block_data_order_prologue

	DD	imagerel $L$SEH_body_blst_sha256_block_data_order
	DD	imagerel $L$SEH_epilogue_blst_sha256_block_data_order
	DD	imagerel $L$SEH_info_blst_sha256_block_data_order_body

	DD	imagerel $L$SEH_epilogue_blst_sha256_block_data_order
	DD	imagerel $L$SEH_end_blst_sha256_block_data_order
	DD	imagerel $L$SEH_info_blst_sha256_block_data_order_epilogue

.pdata	ENDS
.xdata	SEGMENT READONLY ALIGN(8)
ALIGN	8
$L$SEH_info_blst_sha256_block_data_order_shaext_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,003h
DB	0,0
$L$SEH_info_blst_sha256_block_data_order_shaext_body::
DB	1,0,15,0
DB	000h,068h,000h,000h
DB	000h,078h,001h,000h
DB	000h,088h,002h,000h
DB	000h,098h,003h,000h
DB	000h,0a8h,004h,000h
DB	000h,074h,00ch,000h
DB	000h,064h,00dh,000h
DB	000h,0a2h
DB	000h,000h,000h,000h,000h,000h
$L$SEH_info_blst_sha256_block_data_order_shaext_epilogue::
DB	1,0,5,11
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,003h
DB	000h,000h

$L$SEH_info_blst_sha256_block_data_order_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,003h
DB	0,0
$L$SEH_info_blst_sha256_block_data_order_body::
DB	1,0,26,5
DB	000h,068h,002h,000h
DB	000h,078h,003h,000h
DB	000h,088h,004h,000h
DB	000h,098h,005h,000h
DB	000h,0f4h,00dh,000h
DB	000h,0e4h,00eh,000h
DB	000h,0d4h,00fh,000h
DB	000h,0c4h,010h,000h
DB	000h,034h,011h,000h
DB	000h,074h,014h,000h
DB	000h,064h,015h,000h
DB	000h,003h
DB	000h,001h,012h,000h
DB	000h,050h
$L$SEH_info_blst_sha256_block_data_order_epilogue::
DB	1,0,5,11
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,003h
DB	000h,000h


.xdata	ENDS
END
