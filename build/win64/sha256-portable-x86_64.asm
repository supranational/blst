OPTION	DOTNAME
.text$	SEGMENT ALIGN(256) 'CODE'

PUBLIC	blst_sha256_block_data_order_portable

ALIGN	16
blst_sha256_block_data_order_portable	PROC PUBLIC
	DB	243,15,30,250
	mov	QWORD PTR[8+rsp],rdi	;WIN64 prologue
	mov	QWORD PTR[16+rsp],rsi
	mov	r11,rsp
$L$SEH_begin_blst_sha256_block_data_order_portable::
	mov	rdi,rcx
	mov	rsi,rdx
	mov	rdx,r8



	push	rbx

	push	rbp

	push	r12

	push	r13

	push	r14

	push	r15

	shl	rdx,4
	sub	rsp,16*4+3*8

	lea	rdx,QWORD PTR[rdx*4+rsi]
	mov	QWORD PTR[((64+0))+rsp],rdi
	mov	QWORD PTR[((64+8))+rsp],rsi
	mov	QWORD PTR[((64+16))+rsp],rdx
$L$SEH_body_blst_sha256_block_data_order_portable::


	mov	eax,DWORD PTR[rdi]
	mov	ebx,DWORD PTR[4+rdi]
	mov	ecx,DWORD PTR[8+rdi]
	mov	edx,DWORD PTR[12+rdi]
	mov	r8d,DWORD PTR[16+rdi]
	mov	r9d,DWORD PTR[20+rdi]
	mov	r10d,DWORD PTR[24+rdi]
	mov	r11d,DWORD PTR[28+rdi]
	jmp	$L$loop

ALIGN	16
$L$loop::
	mov	edi,ebx
	lea	rbp,QWORD PTR[K256]
	xor	edi,ecx
	mov	r12d,DWORD PTR[rsi]
	mov	r13d,r8d
	mov	r14d,eax
	bswap	r12d
	ror	r13d,14
	mov	r15d,r9d

	xor	r13d,r8d
	ror	r14d,9
	xor	r15d,r10d

	mov	DWORD PTR[rsp],r12d
	xor	r14d,eax
	and	r15d,r8d

	ror	r13d,5
	add	r12d,r11d
	xor	r15d,r10d

	ror	r14d,11
	xor	r13d,r8d
	add	r12d,r15d

	mov	r15d,eax
	add	r12d,DWORD PTR[rbp]
	xor	r14d,eax

	xor	r15d,ebx
	ror	r13d,6
	mov	r11d,ebx

	and	edi,r15d
	ror	r14d,2
	add	r12d,r13d

	xor	r11d,edi
	add	edx,r12d
	add	r11d,r12d
	add	r11d,r14d
	mov	r12d,DWORD PTR[4+rsi]
	mov	r13d,edx
	mov	r14d,r11d
	bswap	r12d
	ror	r13d,14
	mov	edi,r8d

	xor	r13d,edx
	ror	r14d,9
	xor	edi,r9d

	mov	DWORD PTR[4+rsp],r12d
	xor	r14d,r11d
	and	edi,edx

	ror	r13d,5
	add	r12d,r10d
	xor	edi,r9d

	ror	r14d,11
	xor	r13d,edx
	add	r12d,edi

	mov	edi,r11d
	add	r12d,DWORD PTR[4+rbp]
	xor	r14d,r11d

	xor	edi,eax
	ror	r13d,6
	mov	r10d,eax

	and	r15d,edi
	ror	r14d,2
	add	r12d,r13d

	xor	r10d,r15d
	add	ecx,r12d
	add	r10d,r12d
	add	r10d,r14d
	mov	r12d,DWORD PTR[8+rsi]
	mov	r13d,ecx
	mov	r14d,r10d
	bswap	r12d
	ror	r13d,14
	mov	r15d,edx

	xor	r13d,ecx
	ror	r14d,9
	xor	r15d,r8d

	mov	DWORD PTR[8+rsp],r12d
	xor	r14d,r10d
	and	r15d,ecx

	ror	r13d,5
	add	r12d,r9d
	xor	r15d,r8d

	ror	r14d,11
	xor	r13d,ecx
	add	r12d,r15d

	mov	r15d,r10d
	add	r12d,DWORD PTR[8+rbp]
	xor	r14d,r10d

	xor	r15d,r11d
	ror	r13d,6
	mov	r9d,r11d

	and	edi,r15d
	ror	r14d,2
	add	r12d,r13d

	xor	r9d,edi
	add	ebx,r12d
	add	r9d,r12d
	add	r9d,r14d
	mov	r12d,DWORD PTR[12+rsi]
	mov	r13d,ebx
	mov	r14d,r9d
	bswap	r12d
	ror	r13d,14
	mov	edi,ecx

	xor	r13d,ebx
	ror	r14d,9
	xor	edi,edx

	mov	DWORD PTR[12+rsp],r12d
	xor	r14d,r9d
	and	edi,ebx

	ror	r13d,5
	add	r12d,r8d
	xor	edi,edx

	ror	r14d,11
	xor	r13d,ebx
	add	r12d,edi

	mov	edi,r9d
	add	r12d,DWORD PTR[12+rbp]
	xor	r14d,r9d

	xor	edi,r10d
	ror	r13d,6
	mov	r8d,r10d

	and	r15d,edi
	ror	r14d,2
	add	r12d,r13d

	xor	r8d,r15d
	add	eax,r12d
	add	r8d,r12d
	add	r8d,r14d
	mov	r12d,DWORD PTR[16+rsi]
	mov	r13d,eax
	mov	r14d,r8d
	bswap	r12d
	ror	r13d,14
	mov	r15d,ebx

	xor	r13d,eax
	ror	r14d,9
	xor	r15d,ecx

	mov	DWORD PTR[16+rsp],r12d
	xor	r14d,r8d
	and	r15d,eax

	ror	r13d,5
	add	r12d,edx
	xor	r15d,ecx

	ror	r14d,11
	xor	r13d,eax
	add	r12d,r15d

	mov	r15d,r8d
	add	r12d,DWORD PTR[16+rbp]
	xor	r14d,r8d

	xor	r15d,r9d
	ror	r13d,6
	mov	edx,r9d

	and	edi,r15d
	ror	r14d,2
	add	r12d,r13d

	xor	edx,edi
	add	r11d,r12d
	add	edx,r12d
	add	edx,r14d
	mov	r12d,DWORD PTR[20+rsi]
	mov	r13d,r11d
	mov	r14d,edx
	bswap	r12d
	ror	r13d,14
	mov	edi,eax

	xor	r13d,r11d
	ror	r14d,9
	xor	edi,ebx

	mov	DWORD PTR[20+rsp],r12d
	xor	r14d,edx
	and	edi,r11d

	ror	r13d,5
	add	r12d,ecx
	xor	edi,ebx

	ror	r14d,11
	xor	r13d,r11d
	add	r12d,edi

	mov	edi,edx
	add	r12d,DWORD PTR[20+rbp]
	xor	r14d,edx

	xor	edi,r8d
	ror	r13d,6
	mov	ecx,r8d

	and	r15d,edi
	ror	r14d,2
	add	r12d,r13d

	xor	ecx,r15d
	add	r10d,r12d
	add	ecx,r12d
	add	ecx,r14d
	mov	r12d,DWORD PTR[24+rsi]
	mov	r13d,r10d
	mov	r14d,ecx
	bswap	r12d
	ror	r13d,14
	mov	r15d,r11d

	xor	r13d,r10d
	ror	r14d,9
	xor	r15d,eax

	mov	DWORD PTR[24+rsp],r12d
	xor	r14d,ecx
	and	r15d,r10d

	ror	r13d,5
	add	r12d,ebx
	xor	r15d,eax

	ror	r14d,11
	xor	r13d,r10d
	add	r12d,r15d

	mov	r15d,ecx
	add	r12d,DWORD PTR[24+rbp]
	xor	r14d,ecx

	xor	r15d,edx
	ror	r13d,6
	mov	ebx,edx

	and	edi,r15d
	ror	r14d,2
	add	r12d,r13d

	xor	ebx,edi
	add	r9d,r12d
	add	ebx,r12d
	add	ebx,r14d
	mov	r12d,DWORD PTR[28+rsi]
	mov	r13d,r9d
	mov	r14d,ebx
	bswap	r12d
	ror	r13d,14
	mov	edi,r10d

	xor	r13d,r9d
	ror	r14d,9
	xor	edi,r11d

	mov	DWORD PTR[28+rsp],r12d
	xor	r14d,ebx
	and	edi,r9d

	ror	r13d,5
	add	r12d,eax
	xor	edi,r11d

	ror	r14d,11
	xor	r13d,r9d
	add	r12d,edi

	mov	edi,ebx
	add	r12d,DWORD PTR[28+rbp]
	xor	r14d,ebx

	xor	edi,ecx
	ror	r13d,6
	mov	eax,ecx

	and	r15d,edi
	ror	r14d,2
	add	r12d,r13d

	xor	eax,r15d
	add	r8d,r12d
	add	eax,r12d
	add	eax,r14d
	mov	r12d,DWORD PTR[32+rsi]
	mov	r13d,r8d
	mov	r14d,eax
	bswap	r12d
	ror	r13d,14
	mov	r15d,r9d

	xor	r13d,r8d
	ror	r14d,9
	xor	r15d,r10d

	mov	DWORD PTR[32+rsp],r12d
	xor	r14d,eax
	and	r15d,r8d

	ror	r13d,5
	add	r12d,r11d
	xor	r15d,r10d

	ror	r14d,11
	xor	r13d,r8d
	add	r12d,r15d

	mov	r15d,eax
	add	r12d,DWORD PTR[32+rbp]
	xor	r14d,eax

	xor	r15d,ebx
	ror	r13d,6
	mov	r11d,ebx

	and	edi,r15d
	ror	r14d,2
	add	r12d,r13d

	xor	r11d,edi
	add	edx,r12d
	add	r11d,r12d
	add	r11d,r14d
	mov	r12d,DWORD PTR[36+rsi]
	mov	r13d,edx
	mov	r14d,r11d
	bswap	r12d
	ror	r13d,14
	mov	edi,r8d

	xor	r13d,edx
	ror	r14d,9
	xor	edi,r9d

	mov	DWORD PTR[36+rsp],r12d
	xor	r14d,r11d
	and	edi,edx

	ror	r13d,5
	add	r12d,r10d
	xor	edi,r9d

	ror	r14d,11
	xor	r13d,edx
	add	r12d,edi

	mov	edi,r11d
	add	r12d,DWORD PTR[36+rbp]
	xor	r14d,r11d

	xor	edi,eax
	ror	r13d,6
	mov	r10d,eax

	and	r15d,edi
	ror	r14d,2
	add	r12d,r13d

	xor	r10d,r15d
	add	ecx,r12d
	add	r10d,r12d
	add	r10d,r14d
	mov	r12d,DWORD PTR[40+rsi]
	mov	r13d,ecx
	mov	r14d,r10d
	bswap	r12d
	ror	r13d,14
	mov	r15d,edx

	xor	r13d,ecx
	ror	r14d,9
	xor	r15d,r8d

	mov	DWORD PTR[40+rsp],r12d
	xor	r14d,r10d
	and	r15d,ecx

	ror	r13d,5
	add	r12d,r9d
	xor	r15d,r8d

	ror	r14d,11
	xor	r13d,ecx
	add	r12d,r15d

	mov	r15d,r10d
	add	r12d,DWORD PTR[40+rbp]
	xor	r14d,r10d

	xor	r15d,r11d
	ror	r13d,6
	mov	r9d,r11d

	and	edi,r15d
	ror	r14d,2
	add	r12d,r13d

	xor	r9d,edi
	add	ebx,r12d
	add	r9d,r12d
	add	r9d,r14d
	mov	r12d,DWORD PTR[44+rsi]
	mov	r13d,ebx
	mov	r14d,r9d
	bswap	r12d
	ror	r13d,14
	mov	edi,ecx

	xor	r13d,ebx
	ror	r14d,9
	xor	edi,edx

	mov	DWORD PTR[44+rsp],r12d
	xor	r14d,r9d
	and	edi,ebx

	ror	r13d,5
	add	r12d,r8d
	xor	edi,edx

	ror	r14d,11
	xor	r13d,ebx
	add	r12d,edi

	mov	edi,r9d
	add	r12d,DWORD PTR[44+rbp]
	xor	r14d,r9d

	xor	edi,r10d
	ror	r13d,6
	mov	r8d,r10d

	and	r15d,edi
	ror	r14d,2
	add	r12d,r13d

	xor	r8d,r15d
	add	eax,r12d
	add	r8d,r12d
	add	r8d,r14d
	mov	r12d,DWORD PTR[48+rsi]
	mov	r13d,eax
	mov	r14d,r8d
	bswap	r12d
	ror	r13d,14
	mov	r15d,ebx

	xor	r13d,eax
	ror	r14d,9
	xor	r15d,ecx

	mov	DWORD PTR[48+rsp],r12d
	xor	r14d,r8d
	and	r15d,eax

	ror	r13d,5
	add	r12d,edx
	xor	r15d,ecx

	ror	r14d,11
	xor	r13d,eax
	add	r12d,r15d

	mov	r15d,r8d
	add	r12d,DWORD PTR[48+rbp]
	xor	r14d,r8d

	xor	r15d,r9d
	ror	r13d,6
	mov	edx,r9d

	and	edi,r15d
	ror	r14d,2
	add	r12d,r13d

	xor	edx,edi
	add	r11d,r12d
	add	edx,r12d
	add	edx,r14d
	mov	r12d,DWORD PTR[52+rsi]
	mov	r13d,r11d
	mov	r14d,edx
	bswap	r12d
	ror	r13d,14
	mov	edi,eax

	xor	r13d,r11d
	ror	r14d,9
	xor	edi,ebx

	mov	DWORD PTR[52+rsp],r12d
	xor	r14d,edx
	and	edi,r11d

	ror	r13d,5
	add	r12d,ecx
	xor	edi,ebx

	ror	r14d,11
	xor	r13d,r11d
	add	r12d,edi

	mov	edi,edx
	add	r12d,DWORD PTR[52+rbp]
	xor	r14d,edx

	xor	edi,r8d
	ror	r13d,6
	mov	ecx,r8d

	and	r15d,edi
	ror	r14d,2
	add	r12d,r13d

	xor	ecx,r15d
	add	r10d,r12d
	add	ecx,r12d
	add	ecx,r14d
	mov	r12d,DWORD PTR[56+rsi]
	mov	r13d,r10d
	mov	r14d,ecx
	bswap	r12d
	ror	r13d,14
	mov	r15d,r11d

	xor	r13d,r10d
	ror	r14d,9
	xor	r15d,eax

	mov	DWORD PTR[56+rsp],r12d
	xor	r14d,ecx
	and	r15d,r10d

	ror	r13d,5
	add	r12d,ebx
	xor	r15d,eax

	ror	r14d,11
	xor	r13d,r10d
	add	r12d,r15d

	mov	r15d,ecx
	add	r12d,DWORD PTR[56+rbp]
	xor	r14d,ecx

	xor	r15d,edx
	ror	r13d,6
	mov	ebx,edx

	and	edi,r15d
	ror	r14d,2
	add	r12d,r13d

	xor	ebx,edi
	add	r9d,r12d
	add	ebx,r12d
	add	ebx,r14d
	mov	r12d,DWORD PTR[60+rsi]
	mov	r13d,r9d
	mov	r14d,ebx
	bswap	r12d
	ror	r13d,14
	mov	edi,r10d

	xor	r13d,r9d
	ror	r14d,9
	xor	edi,r11d

	mov	DWORD PTR[60+rsp],r12d
	xor	r14d,ebx
	and	edi,r9d

	ror	r13d,5
	add	r12d,eax
	xor	edi,r11d

	ror	r14d,11
	xor	r13d,r9d
	add	r12d,edi

	mov	edi,ebx
	add	r12d,DWORD PTR[60+rbp]
	xor	r14d,ebx

	xor	edi,ecx
	ror	r13d,6
	mov	eax,ecx

	and	r15d,edi
	ror	r14d,2
	add	r12d,r13d

	xor	eax,r15d
	add	r8d,r12d
	add	eax,r12d
	jmp	$L$rounds_16_xx
ALIGN	16
$L$rounds_16_xx::
	mov	r13d,DWORD PTR[4+rsp]
	mov	r15d,DWORD PTR[56+rsp]

	mov	r12d,r13d
	ror	r13d,11
	add	eax,r14d
	mov	r14d,r15d
	ror	r15d,2

	xor	r13d,r12d
	shr	r12d,3
	ror	r13d,7
	xor	r15d,r14d
	shr	r14d,10

	ror	r15d,17
	xor	r12d,r13d
	xor	r15d,r14d
	add	r12d,DWORD PTR[36+rsp]

	add	r12d,DWORD PTR[rsp]
	mov	r13d,r8d
	add	r12d,r15d
	mov	r14d,eax
	ror	r13d,14
	mov	r15d,r9d

	xor	r13d,r8d
	ror	r14d,9
	xor	r15d,r10d

	mov	DWORD PTR[rsp],r12d
	xor	r14d,eax
	and	r15d,r8d

	ror	r13d,5
	add	r12d,r11d
	xor	r15d,r10d

	ror	r14d,11
	xor	r13d,r8d
	add	r12d,r15d

	mov	r15d,eax
	add	r12d,DWORD PTR[64+rbp]
	xor	r14d,eax

	xor	r15d,ebx
	ror	r13d,6
	mov	r11d,ebx

	and	edi,r15d
	ror	r14d,2
	add	r12d,r13d

	xor	r11d,edi
	add	edx,r12d
	add	r11d,r12d
	mov	r13d,DWORD PTR[8+rsp]
	mov	edi,DWORD PTR[60+rsp]

	mov	r12d,r13d
	ror	r13d,11
	add	r11d,r14d
	mov	r14d,edi
	ror	edi,2

	xor	r13d,r12d
	shr	r12d,3
	ror	r13d,7
	xor	edi,r14d
	shr	r14d,10

	ror	edi,17
	xor	r12d,r13d
	xor	edi,r14d
	add	r12d,DWORD PTR[40+rsp]

	add	r12d,DWORD PTR[4+rsp]
	mov	r13d,edx
	add	r12d,edi
	mov	r14d,r11d
	ror	r13d,14
	mov	edi,r8d

	xor	r13d,edx
	ror	r14d,9
	xor	edi,r9d

	mov	DWORD PTR[4+rsp],r12d
	xor	r14d,r11d
	and	edi,edx

	ror	r13d,5
	add	r12d,r10d
	xor	edi,r9d

	ror	r14d,11
	xor	r13d,edx
	add	r12d,edi

	mov	edi,r11d
	add	r12d,DWORD PTR[68+rbp]
	xor	r14d,r11d

	xor	edi,eax
	ror	r13d,6
	mov	r10d,eax

	and	r15d,edi
	ror	r14d,2
	add	r12d,r13d

	xor	r10d,r15d
	add	ecx,r12d
	add	r10d,r12d
	mov	r13d,DWORD PTR[12+rsp]
	mov	r15d,DWORD PTR[rsp]

	mov	r12d,r13d
	ror	r13d,11
	add	r10d,r14d
	mov	r14d,r15d
	ror	r15d,2

	xor	r13d,r12d
	shr	r12d,3
	ror	r13d,7
	xor	r15d,r14d
	shr	r14d,10

	ror	r15d,17
	xor	r12d,r13d
	xor	r15d,r14d
	add	r12d,DWORD PTR[44+rsp]

	add	r12d,DWORD PTR[8+rsp]
	mov	r13d,ecx
	add	r12d,r15d
	mov	r14d,r10d
	ror	r13d,14
	mov	r15d,edx

	xor	r13d,ecx
	ror	r14d,9
	xor	r15d,r8d

	mov	DWORD PTR[8+rsp],r12d
	xor	r14d,r10d
	and	r15d,ecx

	ror	r13d,5
	add	r12d,r9d
	xor	r15d,r8d

	ror	r14d,11
	xor	r13d,ecx
	add	r12d,r15d

	mov	r15d,r10d
	add	r12d,DWORD PTR[72+rbp]
	xor	r14d,r10d

	xor	r15d,r11d
	ror	r13d,6
	mov	r9d,r11d

	and	edi,r15d
	ror	r14d,2
	add	r12d,r13d

	xor	r9d,edi
	add	ebx,r12d
	add	r9d,r12d
	mov	r13d,DWORD PTR[16+rsp]
	mov	edi,DWORD PTR[4+rsp]

	mov	r12d,r13d
	ror	r13d,11
	add	r9d,r14d
	mov	r14d,edi
	ror	edi,2

	xor	r13d,r12d
	shr	r12d,3
	ror	r13d,7
	xor	edi,r14d
	shr	r14d,10

	ror	edi,17
	xor	r12d,r13d
	xor	edi,r14d
	add	r12d,DWORD PTR[48+rsp]

	add	r12d,DWORD PTR[12+rsp]
	mov	r13d,ebx
	add	r12d,edi
	mov	r14d,r9d
	ror	r13d,14
	mov	edi,ecx

	xor	r13d,ebx
	ror	r14d,9
	xor	edi,edx

	mov	DWORD PTR[12+rsp],r12d
	xor	r14d,r9d
	and	edi,ebx

	ror	r13d,5
	add	r12d,r8d
	xor	edi,edx

	ror	r14d,11
	xor	r13d,ebx
	add	r12d,edi

	mov	edi,r9d
	add	r12d,DWORD PTR[76+rbp]
	xor	r14d,r9d

	xor	edi,r10d
	ror	r13d,6
	mov	r8d,r10d

	and	r15d,edi
	ror	r14d,2
	add	r12d,r13d

	xor	r8d,r15d
	add	eax,r12d
	add	r8d,r12d
	mov	r13d,DWORD PTR[20+rsp]
	mov	r15d,DWORD PTR[8+rsp]

	mov	r12d,r13d
	ror	r13d,11
	add	r8d,r14d
	mov	r14d,r15d
	ror	r15d,2

	xor	r13d,r12d
	shr	r12d,3
	ror	r13d,7
	xor	r15d,r14d
	shr	r14d,10

	ror	r15d,17
	xor	r12d,r13d
	xor	r15d,r14d
	add	r12d,DWORD PTR[52+rsp]

	add	r12d,DWORD PTR[16+rsp]
	mov	r13d,eax
	add	r12d,r15d
	mov	r14d,r8d
	ror	r13d,14
	mov	r15d,ebx

	xor	r13d,eax
	ror	r14d,9
	xor	r15d,ecx

	mov	DWORD PTR[16+rsp],r12d
	xor	r14d,r8d
	and	r15d,eax

	ror	r13d,5
	add	r12d,edx
	xor	r15d,ecx

	ror	r14d,11
	xor	r13d,eax
	add	r12d,r15d

	mov	r15d,r8d
	add	r12d,DWORD PTR[80+rbp]
	xor	r14d,r8d

	xor	r15d,r9d
	ror	r13d,6
	mov	edx,r9d

	and	edi,r15d
	ror	r14d,2
	add	r12d,r13d

	xor	edx,edi
	add	r11d,r12d
	add	edx,r12d
	mov	r13d,DWORD PTR[24+rsp]
	mov	edi,DWORD PTR[12+rsp]

	mov	r12d,r13d
	ror	r13d,11
	add	edx,r14d
	mov	r14d,edi
	ror	edi,2

	xor	r13d,r12d
	shr	r12d,3
	ror	r13d,7
	xor	edi,r14d
	shr	r14d,10

	ror	edi,17
	xor	r12d,r13d
	xor	edi,r14d
	add	r12d,DWORD PTR[56+rsp]

	add	r12d,DWORD PTR[20+rsp]
	mov	r13d,r11d
	add	r12d,edi
	mov	r14d,edx
	ror	r13d,14
	mov	edi,eax

	xor	r13d,r11d
	ror	r14d,9
	xor	edi,ebx

	mov	DWORD PTR[20+rsp],r12d
	xor	r14d,edx
	and	edi,r11d

	ror	r13d,5
	add	r12d,ecx
	xor	edi,ebx

	ror	r14d,11
	xor	r13d,r11d
	add	r12d,edi

	mov	edi,edx
	add	r12d,DWORD PTR[84+rbp]
	xor	r14d,edx

	xor	edi,r8d
	ror	r13d,6
	mov	ecx,r8d

	and	r15d,edi
	ror	r14d,2
	add	r12d,r13d

	xor	ecx,r15d
	add	r10d,r12d
	add	ecx,r12d
	mov	r13d,DWORD PTR[28+rsp]
	mov	r15d,DWORD PTR[16+rsp]

	mov	r12d,r13d
	ror	r13d,11
	add	ecx,r14d
	mov	r14d,r15d
	ror	r15d,2

	xor	r13d,r12d
	shr	r12d,3
	ror	r13d,7
	xor	r15d,r14d
	shr	r14d,10

	ror	r15d,17
	xor	r12d,r13d
	xor	r15d,r14d
	add	r12d,DWORD PTR[60+rsp]

	add	r12d,DWORD PTR[24+rsp]
	mov	r13d,r10d
	add	r12d,r15d
	mov	r14d,ecx
	ror	r13d,14
	mov	r15d,r11d

	xor	r13d,r10d
	ror	r14d,9
	xor	r15d,eax

	mov	DWORD PTR[24+rsp],r12d
	xor	r14d,ecx
	and	r15d,r10d

	ror	r13d,5
	add	r12d,ebx
	xor	r15d,eax

	ror	r14d,11
	xor	r13d,r10d
	add	r12d,r15d

	mov	r15d,ecx
	add	r12d,DWORD PTR[88+rbp]
	xor	r14d,ecx

	xor	r15d,edx
	ror	r13d,6
	mov	ebx,edx

	and	edi,r15d
	ror	r14d,2
	add	r12d,r13d

	xor	ebx,edi
	add	r9d,r12d
	add	ebx,r12d
	mov	r13d,DWORD PTR[32+rsp]
	mov	edi,DWORD PTR[20+rsp]

	mov	r12d,r13d
	ror	r13d,11
	add	ebx,r14d
	mov	r14d,edi
	ror	edi,2

	xor	r13d,r12d
	shr	r12d,3
	ror	r13d,7
	xor	edi,r14d
	shr	r14d,10

	ror	edi,17
	xor	r12d,r13d
	xor	edi,r14d
	add	r12d,DWORD PTR[rsp]

	add	r12d,DWORD PTR[28+rsp]
	mov	r13d,r9d
	add	r12d,edi
	mov	r14d,ebx
	ror	r13d,14
	mov	edi,r10d

	xor	r13d,r9d
	ror	r14d,9
	xor	edi,r11d

	mov	DWORD PTR[28+rsp],r12d
	xor	r14d,ebx
	and	edi,r9d

	ror	r13d,5
	add	r12d,eax
	xor	edi,r11d

	ror	r14d,11
	xor	r13d,r9d
	add	r12d,edi

	mov	edi,ebx
	add	r12d,DWORD PTR[92+rbp]
	xor	r14d,ebx

	xor	edi,ecx
	ror	r13d,6
	mov	eax,ecx

	and	r15d,edi
	ror	r14d,2
	add	r12d,r13d

	xor	eax,r15d
	add	r8d,r12d
	add	eax,r12d
	mov	r13d,DWORD PTR[36+rsp]
	mov	r15d,DWORD PTR[24+rsp]

	mov	r12d,r13d
	ror	r13d,11
	add	eax,r14d
	mov	r14d,r15d
	ror	r15d,2

	xor	r13d,r12d
	shr	r12d,3
	ror	r13d,7
	xor	r15d,r14d
	shr	r14d,10

	ror	r15d,17
	xor	r12d,r13d
	xor	r15d,r14d
	add	r12d,DWORD PTR[4+rsp]

	add	r12d,DWORD PTR[32+rsp]
	mov	r13d,r8d
	add	r12d,r15d
	mov	r14d,eax
	ror	r13d,14
	mov	r15d,r9d

	xor	r13d,r8d
	ror	r14d,9
	xor	r15d,r10d

	mov	DWORD PTR[32+rsp],r12d
	xor	r14d,eax
	and	r15d,r8d

	ror	r13d,5
	add	r12d,r11d
	xor	r15d,r10d

	ror	r14d,11
	xor	r13d,r8d
	add	r12d,r15d

	mov	r15d,eax
	add	r12d,DWORD PTR[96+rbp]
	xor	r14d,eax

	xor	r15d,ebx
	ror	r13d,6
	mov	r11d,ebx

	and	edi,r15d
	ror	r14d,2
	add	r12d,r13d

	xor	r11d,edi
	add	edx,r12d
	add	r11d,r12d
	mov	r13d,DWORD PTR[40+rsp]
	mov	edi,DWORD PTR[28+rsp]

	mov	r12d,r13d
	ror	r13d,11
	add	r11d,r14d
	mov	r14d,edi
	ror	edi,2

	xor	r13d,r12d
	shr	r12d,3
	ror	r13d,7
	xor	edi,r14d
	shr	r14d,10

	ror	edi,17
	xor	r12d,r13d
	xor	edi,r14d
	add	r12d,DWORD PTR[8+rsp]

	add	r12d,DWORD PTR[36+rsp]
	mov	r13d,edx
	add	r12d,edi
	mov	r14d,r11d
	ror	r13d,14
	mov	edi,r8d

	xor	r13d,edx
	ror	r14d,9
	xor	edi,r9d

	mov	DWORD PTR[36+rsp],r12d
	xor	r14d,r11d
	and	edi,edx

	ror	r13d,5
	add	r12d,r10d
	xor	edi,r9d

	ror	r14d,11
	xor	r13d,edx
	add	r12d,edi

	mov	edi,r11d
	add	r12d,DWORD PTR[100+rbp]
	xor	r14d,r11d

	xor	edi,eax
	ror	r13d,6
	mov	r10d,eax

	and	r15d,edi
	ror	r14d,2
	add	r12d,r13d

	xor	r10d,r15d
	add	ecx,r12d
	add	r10d,r12d
	mov	r13d,DWORD PTR[44+rsp]
	mov	r15d,DWORD PTR[32+rsp]

	mov	r12d,r13d
	ror	r13d,11
	add	r10d,r14d
	mov	r14d,r15d
	ror	r15d,2

	xor	r13d,r12d
	shr	r12d,3
	ror	r13d,7
	xor	r15d,r14d
	shr	r14d,10

	ror	r15d,17
	xor	r12d,r13d
	xor	r15d,r14d
	add	r12d,DWORD PTR[12+rsp]

	add	r12d,DWORD PTR[40+rsp]
	mov	r13d,ecx
	add	r12d,r15d
	mov	r14d,r10d
	ror	r13d,14
	mov	r15d,edx

	xor	r13d,ecx
	ror	r14d,9
	xor	r15d,r8d

	mov	DWORD PTR[40+rsp],r12d
	xor	r14d,r10d
	and	r15d,ecx

	ror	r13d,5
	add	r12d,r9d
	xor	r15d,r8d

	ror	r14d,11
	xor	r13d,ecx
	add	r12d,r15d

	mov	r15d,r10d
	add	r12d,DWORD PTR[104+rbp]
	xor	r14d,r10d

	xor	r15d,r11d
	ror	r13d,6
	mov	r9d,r11d

	and	edi,r15d
	ror	r14d,2
	add	r12d,r13d

	xor	r9d,edi
	add	ebx,r12d
	add	r9d,r12d
	mov	r13d,DWORD PTR[48+rsp]
	mov	edi,DWORD PTR[36+rsp]

	mov	r12d,r13d
	ror	r13d,11
	add	r9d,r14d
	mov	r14d,edi
	ror	edi,2

	xor	r13d,r12d
	shr	r12d,3
	ror	r13d,7
	xor	edi,r14d
	shr	r14d,10

	ror	edi,17
	xor	r12d,r13d
	xor	edi,r14d
	add	r12d,DWORD PTR[16+rsp]

	add	r12d,DWORD PTR[44+rsp]
	mov	r13d,ebx
	add	r12d,edi
	mov	r14d,r9d
	ror	r13d,14
	mov	edi,ecx

	xor	r13d,ebx
	ror	r14d,9
	xor	edi,edx

	mov	DWORD PTR[44+rsp],r12d
	xor	r14d,r9d
	and	edi,ebx

	ror	r13d,5
	add	r12d,r8d
	xor	edi,edx

	ror	r14d,11
	xor	r13d,ebx
	add	r12d,edi

	mov	edi,r9d
	add	r12d,DWORD PTR[108+rbp]
	xor	r14d,r9d

	xor	edi,r10d
	ror	r13d,6
	mov	r8d,r10d

	and	r15d,edi
	ror	r14d,2
	add	r12d,r13d

	xor	r8d,r15d
	add	eax,r12d
	add	r8d,r12d
	mov	r13d,DWORD PTR[52+rsp]
	mov	r15d,DWORD PTR[40+rsp]

	mov	r12d,r13d
	ror	r13d,11
	add	r8d,r14d
	mov	r14d,r15d
	ror	r15d,2

	xor	r13d,r12d
	shr	r12d,3
	ror	r13d,7
	xor	r15d,r14d
	shr	r14d,10

	ror	r15d,17
	xor	r12d,r13d
	xor	r15d,r14d
	add	r12d,DWORD PTR[20+rsp]

	add	r12d,DWORD PTR[48+rsp]
	mov	r13d,eax
	add	r12d,r15d
	mov	r14d,r8d
	ror	r13d,14
	mov	r15d,ebx

	xor	r13d,eax
	ror	r14d,9
	xor	r15d,ecx

	mov	DWORD PTR[48+rsp],r12d
	xor	r14d,r8d
	and	r15d,eax

	ror	r13d,5
	add	r12d,edx
	xor	r15d,ecx

	ror	r14d,11
	xor	r13d,eax
	add	r12d,r15d

	mov	r15d,r8d
	add	r12d,DWORD PTR[112+rbp]
	xor	r14d,r8d

	xor	r15d,r9d
	ror	r13d,6
	mov	edx,r9d

	and	edi,r15d
	ror	r14d,2
	add	r12d,r13d

	xor	edx,edi
	add	r11d,r12d
	add	edx,r12d
	mov	r13d,DWORD PTR[56+rsp]
	mov	edi,DWORD PTR[44+rsp]

	mov	r12d,r13d
	ror	r13d,11
	add	edx,r14d
	mov	r14d,edi
	ror	edi,2

	xor	r13d,r12d
	shr	r12d,3
	ror	r13d,7
	xor	edi,r14d
	shr	r14d,10

	ror	edi,17
	xor	r12d,r13d
	xor	edi,r14d
	add	r12d,DWORD PTR[24+rsp]

	add	r12d,DWORD PTR[52+rsp]
	mov	r13d,r11d
	add	r12d,edi
	mov	r14d,edx
	ror	r13d,14
	mov	edi,eax

	xor	r13d,r11d
	ror	r14d,9
	xor	edi,ebx

	mov	DWORD PTR[52+rsp],r12d
	xor	r14d,edx
	and	edi,r11d

	ror	r13d,5
	add	r12d,ecx
	xor	edi,ebx

	ror	r14d,11
	xor	r13d,r11d
	add	r12d,edi

	mov	edi,edx
	add	r12d,DWORD PTR[116+rbp]
	xor	r14d,edx

	xor	edi,r8d
	ror	r13d,6
	mov	ecx,r8d

	and	r15d,edi
	ror	r14d,2
	add	r12d,r13d

	xor	ecx,r15d
	add	r10d,r12d
	add	ecx,r12d
	mov	r13d,DWORD PTR[60+rsp]
	mov	r15d,DWORD PTR[48+rsp]

	mov	r12d,r13d
	ror	r13d,11
	add	ecx,r14d
	mov	r14d,r15d
	ror	r15d,2

	xor	r13d,r12d
	shr	r12d,3
	ror	r13d,7
	xor	r15d,r14d
	shr	r14d,10

	ror	r15d,17
	xor	r12d,r13d
	xor	r15d,r14d
	add	r12d,DWORD PTR[28+rsp]

	add	r12d,DWORD PTR[56+rsp]
	mov	r13d,r10d
	add	r12d,r15d
	mov	r14d,ecx
	ror	r13d,14
	mov	r15d,r11d

	xor	r13d,r10d
	ror	r14d,9
	xor	r15d,eax

	mov	DWORD PTR[56+rsp],r12d
	xor	r14d,ecx
	and	r15d,r10d

	ror	r13d,5
	add	r12d,ebx
	xor	r15d,eax

	ror	r14d,11
	xor	r13d,r10d
	add	r12d,r15d

	mov	r15d,ecx
	add	r12d,DWORD PTR[120+rbp]
	xor	r14d,ecx

	xor	r15d,edx
	ror	r13d,6
	mov	ebx,edx

	and	edi,r15d
	ror	r14d,2
	add	r12d,r13d

	xor	ebx,edi
	add	r9d,r12d
	add	ebx,r12d
	mov	r13d,DWORD PTR[rsp]
	mov	edi,DWORD PTR[52+rsp]

	mov	r12d,r13d
	ror	r13d,11
	add	ebx,r14d
	mov	r14d,edi
	ror	edi,2

	xor	r13d,r12d
	shr	r12d,3
	ror	r13d,7
	xor	edi,r14d
	shr	r14d,10

	ror	edi,17
	xor	r12d,r13d
	xor	edi,r14d
	add	r12d,DWORD PTR[32+rsp]

	add	r12d,DWORD PTR[60+rsp]
	mov	r13d,r9d
	add	r12d,edi
	mov	r14d,ebx
	ror	r13d,14
	mov	edi,r10d

	xor	r13d,r9d
	ror	r14d,9
	xor	edi,r11d

	mov	DWORD PTR[60+rsp],r12d
	xor	r14d,ebx
	and	edi,r9d

	ror	r13d,5
	add	r12d,eax
	xor	edi,r11d

	ror	r14d,11
	xor	r13d,r9d
	add	r12d,edi

	mov	edi,ebx
	add	r12d,DWORD PTR[124+rbp]
	xor	r14d,ebx

	xor	edi,ecx
	ror	r13d,6
	mov	eax,ecx

	and	r15d,edi
	ror	r14d,2
	add	r12d,r13d

	xor	eax,r15d
	add	r8d,r12d
	add	eax,r12d
	lea	rbp,QWORD PTR[64+rbp]
	cmp	BYTE PTR[3+rbp],019h
	jnz	$L$rounds_16_xx

	mov	rdi,QWORD PTR[((64+0))+rsp]
	add	eax,r14d
	lea	rsi,QWORD PTR[64+rsi]

	add	eax,DWORD PTR[rdi]
	add	ebx,DWORD PTR[4+rdi]
	add	ecx,DWORD PTR[8+rdi]
	add	edx,DWORD PTR[12+rdi]
	add	r8d,DWORD PTR[16+rdi]
	add	r9d,DWORD PTR[20+rdi]
	add	r10d,DWORD PTR[24+rdi]
	add	r11d,DWORD PTR[28+rdi]

	cmp	rsi,QWORD PTR[((64+16))+rsp]

	mov	DWORD PTR[rdi],eax
	mov	DWORD PTR[4+rdi],ebx
	mov	DWORD PTR[8+rdi],ecx
	mov	DWORD PTR[12+rdi],edx
	mov	DWORD PTR[16+rdi],r8d
	mov	DWORD PTR[20+rdi],r9d
	mov	DWORD PTR[24+rdi],r10d
	mov	DWORD PTR[28+rdi],r11d
	jb	$L$loop

	lea	r11,QWORD PTR[((64+24+48))+rsp]

	mov	r15,QWORD PTR[((64+24))+rsp]

	mov	r14,QWORD PTR[((-40))+r11]

	mov	r13,QWORD PTR[((-32))+r11]

	mov	r12,QWORD PTR[((-24))+r11]

	mov	rbp,QWORD PTR[((-16))+r11]

	mov	rbx,QWORD PTR[((-8))+r11]

$L$SEH_epilogue_blst_sha256_block_data_order_portable::
	mov	rdi,QWORD PTR[8+r11]	;WIN64 epilogue
	mov	rsi,QWORD PTR[16+r11]

	lea	rsp,QWORD PTR[r11]
	DB	0F3h,0C3h		;repret

$L$SEH_end_blst_sha256_block_data_order_portable::
blst_sha256_block_data_order_portable	ENDP

ALIGN	64

K256::
	DD	0428a2f98h,071374491h,0b5c0fbcfh,0e9b5dba5h
	DD	03956c25bh,059f111f1h,0923f82a4h,0ab1c5ed5h
	DD	0d807aa98h,012835b01h,0243185beh,0550c7dc3h
	DD	072be5d74h,080deb1feh,09bdc06a7h,0c19bf174h
	DD	0e49b69c1h,0efbe4786h,00fc19dc6h,0240ca1cch
	DD	02de92c6fh,04a7484aah,05cb0a9dch,076f988dah
	DD	0983e5152h,0a831c66dh,0b00327c8h,0bf597fc7h
	DD	0c6e00bf3h,0d5a79147h,006ca6351h,014292967h
	DD	027b70a85h,02e1b2138h,04d2c6dfch,053380d13h
	DD	0650a7354h,0766a0abbh,081c2c92eh,092722c85h
	DD	0a2bfe8a1h,0a81a664bh,0c24b8b70h,0c76c51a3h
	DD	0d192e819h,0d6990624h,0f40e3585h,0106aa070h
	DD	019a4c116h,01e376c08h,02748774ch,034b0bcb5h
	DD	0391c0cb3h,04ed8aa4ah,05b9cca4fh,0682e6ff3h
	DD	0748f82eeh,078a5636fh,084c87814h,08cc70208h
	DD	090befffah,0a4506cebh,0bef9a3f7h,0c67178f2h

DB	83,72,65,50,53,54,32,98,108,111,99,107,32,116,114,97
DB	110,115,102,111,114,109,32,102,111,114,32,120,56,54,95,54
DB	52,44,32,67,82,89,80,84,79,71,65,77,83,32,98,121
DB	32,64,100,111,116,45,97,115,109,0
PUBLIC	blst_sha256_emit


ALIGN	16
blst_sha256_emit	PROC PUBLIC
	DB	243,15,30,250
	mov	r8,QWORD PTR[rdx]
	mov	r9,QWORD PTR[8+rdx]
	mov	r10,QWORD PTR[16+rdx]
	bswap	r8
	mov	r11,QWORD PTR[24+rdx]
	bswap	r9
	mov	DWORD PTR[4+rcx],r8d
	bswap	r10
	mov	DWORD PTR[12+rcx],r9d
	bswap	r11
	mov	DWORD PTR[20+rcx],r10d
	shr	r8,32
	mov	DWORD PTR[28+rcx],r11d
	shr	r9,32
	mov	DWORD PTR[rcx],r8d
	shr	r10,32
	mov	DWORD PTR[8+rcx],r9d
	shr	r11,32
	mov	DWORD PTR[16+rcx],r10d
	mov	DWORD PTR[24+rcx],r11d
	DB	0F3h,0C3h		;repret
blst_sha256_emit	ENDP

PUBLIC	blst_sha256_bcopy


ALIGN	16
blst_sha256_bcopy	PROC PUBLIC
	DB	243,15,30,250
	sub	rcx,rdx
$L$oop_bcopy::
	movzx	eax,BYTE PTR[rdx]
	lea	rdx,QWORD PTR[1+rdx]
	mov	BYTE PTR[((-1))+rdx*1+rcx],al
	dec	r8
	jnz	$L$oop_bcopy
	DB	0F3h,0C3h		;repret
blst_sha256_bcopy	ENDP

PUBLIC	blst_sha256_hcopy


ALIGN	16
blst_sha256_hcopy	PROC PUBLIC
	DB	243,15,30,250
	mov	r8,QWORD PTR[rdx]
	mov	r9,QWORD PTR[8+rdx]
	mov	r10,QWORD PTR[16+rdx]
	mov	r11,QWORD PTR[24+rdx]
	mov	QWORD PTR[rcx],r8
	mov	QWORD PTR[8+rcx],r9
	mov	QWORD PTR[16+rcx],r10
	mov	QWORD PTR[24+rcx],r11
	DB	0F3h,0C3h		;repret
blst_sha256_hcopy	ENDP
.text$	ENDS
.pdata	SEGMENT READONLY ALIGN(4)
ALIGN	4
	DD	imagerel $L$SEH_begin_blst_sha256_block_data_order_portable
	DD	imagerel $L$SEH_body_blst_sha256_block_data_order_portable
	DD	imagerel $L$SEH_info_blst_sha256_block_data_order_portable_prologue

	DD	imagerel $L$SEH_body_blst_sha256_block_data_order_portable
	DD	imagerel $L$SEH_epilogue_blst_sha256_block_data_order_portable
	DD	imagerel $L$SEH_info_blst_sha256_block_data_order_portable_body

	DD	imagerel $L$SEH_epilogue_blst_sha256_block_data_order_portable
	DD	imagerel $L$SEH_end_blst_sha256_block_data_order_portable
	DD	imagerel $L$SEH_info_blst_sha256_block_data_order_portable_epilogue

.pdata	ENDS
.xdata	SEGMENT READONLY ALIGN(8)
ALIGN	8
$L$SEH_info_blst_sha256_block_data_order_portable_prologue::
DB	1,0,5,00bh
DB	0,074h,1,0
DB	0,064h,2,0
DB	0,003h
DB	0,0
$L$SEH_info_blst_sha256_block_data_order_portable_body::
DB	1,0,18,0
DB	000h,0f4h,00bh,000h
DB	000h,0e4h,00ch,000h
DB	000h,0d4h,00dh,000h
DB	000h,0c4h,00eh,000h
DB	000h,054h,00fh,000h
DB	000h,034h,010h,000h
DB	000h,074h,012h,000h
DB	000h,064h,013h,000h
DB	000h,001h,011h,000h
$L$SEH_info_blst_sha256_block_data_order_portable_epilogue::
DB	1,0,5,11
DB	000h,074h,001h,000h
DB	000h,064h,002h,000h
DB	000h,003h
DB	000h,000h


.xdata	ENDS
END
