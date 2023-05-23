.text	

.globl	blst_sha256_block_data_order_portable
.def	blst_sha256_block_data_order_portable;	.scl 2;	.type 32;	.endef
.p2align	4
blst_sha256_block_data_order_portable:
	.byte	0xf3,0x0f,0x1e,0xfa
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%r11
.LSEH_begin_blst_sha256_block_data_order_portable:
	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx


	pushq	%rbx

	pushq	%rbp

	pushq	%r12

	pushq	%r13

	pushq	%r14

	pushq	%r15

	shlq	$4,%rdx
	subq	$64+24,%rsp

	leaq	(%rsi,%rdx,4),%rdx
	movq	%rdi,64+0(%rsp)
	movq	%rsi,64+8(%rsp)
	movq	%rdx,64+16(%rsp)
.LSEH_body_blst_sha256_block_data_order_portable:


	movl	0(%rdi),%eax
	movl	4(%rdi),%ebx
	movl	8(%rdi),%ecx
	movl	12(%rdi),%edx
	movl	16(%rdi),%r8d
	movl	20(%rdi),%r9d
	movl	24(%rdi),%r10d
	movl	28(%rdi),%r11d
	jmp	.Lloop

.p2align	4
.Lloop:
	movl	%ebx,%edi
	leaq	__sha256_portable_K256(%rip),%rbp
	xorl	%ecx,%edi
	movl	0(%rsi),%r12d
	movl	%r8d,%r13d
	movl	%eax,%r14d
	bswapl	%r12d
	rorl	$14,%r13d
	movl	%r9d,%r15d

	xorl	%r8d,%r13d
	rorl	$9,%r14d
	xorl	%r10d,%r15d

	movl	%r12d,0(%rsp)
	xorl	%eax,%r14d
	andl	%r8d,%r15d

	rorl	$5,%r13d
	addl	%r11d,%r12d
	xorl	%r10d,%r15d

	rorl	$11,%r14d
	xorl	%r8d,%r13d
	addl	%r15d,%r12d

	movl	%eax,%r15d
	addl	0(%rbp),%r12d
	xorl	%eax,%r14d

	xorl	%ebx,%r15d
	rorl	$6,%r13d
	movl	%ebx,%r11d

	andl	%r15d,%edi
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%edi,%r11d
	addl	%r12d,%edx
	addl	%r12d,%r11d
	addl	%r14d,%r11d
	movl	4(%rsi),%r12d
	movl	%edx,%r13d
	movl	%r11d,%r14d
	bswapl	%r12d
	rorl	$14,%r13d
	movl	%r8d,%edi

	xorl	%edx,%r13d
	rorl	$9,%r14d
	xorl	%r9d,%edi

	movl	%r12d,4(%rsp)
	xorl	%r11d,%r14d
	andl	%edx,%edi

	rorl	$5,%r13d
	addl	%r10d,%r12d
	xorl	%r9d,%edi

	rorl	$11,%r14d
	xorl	%edx,%r13d
	addl	%edi,%r12d

	movl	%r11d,%edi
	addl	4(%rbp),%r12d
	xorl	%r11d,%r14d

	xorl	%eax,%edi
	rorl	$6,%r13d
	movl	%eax,%r10d

	andl	%edi,%r15d
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%r15d,%r10d
	addl	%r12d,%ecx
	addl	%r12d,%r10d
	addl	%r14d,%r10d
	movl	8(%rsi),%r12d
	movl	%ecx,%r13d
	movl	%r10d,%r14d
	bswapl	%r12d
	rorl	$14,%r13d
	movl	%edx,%r15d

	xorl	%ecx,%r13d
	rorl	$9,%r14d
	xorl	%r8d,%r15d

	movl	%r12d,8(%rsp)
	xorl	%r10d,%r14d
	andl	%ecx,%r15d

	rorl	$5,%r13d
	addl	%r9d,%r12d
	xorl	%r8d,%r15d

	rorl	$11,%r14d
	xorl	%ecx,%r13d
	addl	%r15d,%r12d

	movl	%r10d,%r15d
	addl	8(%rbp),%r12d
	xorl	%r10d,%r14d

	xorl	%r11d,%r15d
	rorl	$6,%r13d
	movl	%r11d,%r9d

	andl	%r15d,%edi
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%edi,%r9d
	addl	%r12d,%ebx
	addl	%r12d,%r9d
	addl	%r14d,%r9d
	movl	12(%rsi),%r12d
	movl	%ebx,%r13d
	movl	%r9d,%r14d
	bswapl	%r12d
	rorl	$14,%r13d
	movl	%ecx,%edi

	xorl	%ebx,%r13d
	rorl	$9,%r14d
	xorl	%edx,%edi

	movl	%r12d,12(%rsp)
	xorl	%r9d,%r14d
	andl	%ebx,%edi

	rorl	$5,%r13d
	addl	%r8d,%r12d
	xorl	%edx,%edi

	rorl	$11,%r14d
	xorl	%ebx,%r13d
	addl	%edi,%r12d

	movl	%r9d,%edi
	addl	12(%rbp),%r12d
	xorl	%r9d,%r14d

	xorl	%r10d,%edi
	rorl	$6,%r13d
	movl	%r10d,%r8d

	andl	%edi,%r15d
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%r15d,%r8d
	addl	%r12d,%eax
	addl	%r12d,%r8d
	addl	%r14d,%r8d
	movl	16(%rsi),%r12d
	movl	%eax,%r13d
	movl	%r8d,%r14d
	bswapl	%r12d
	rorl	$14,%r13d
	movl	%ebx,%r15d

	xorl	%eax,%r13d
	rorl	$9,%r14d
	xorl	%ecx,%r15d

	movl	%r12d,16(%rsp)
	xorl	%r8d,%r14d
	andl	%eax,%r15d

	rorl	$5,%r13d
	addl	%edx,%r12d
	xorl	%ecx,%r15d

	rorl	$11,%r14d
	xorl	%eax,%r13d
	addl	%r15d,%r12d

	movl	%r8d,%r15d
	addl	16(%rbp),%r12d
	xorl	%r8d,%r14d

	xorl	%r9d,%r15d
	rorl	$6,%r13d
	movl	%r9d,%edx

	andl	%r15d,%edi
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%edi,%edx
	addl	%r12d,%r11d
	addl	%r12d,%edx
	addl	%r14d,%edx
	movl	20(%rsi),%r12d
	movl	%r11d,%r13d
	movl	%edx,%r14d
	bswapl	%r12d
	rorl	$14,%r13d
	movl	%eax,%edi

	xorl	%r11d,%r13d
	rorl	$9,%r14d
	xorl	%ebx,%edi

	movl	%r12d,20(%rsp)
	xorl	%edx,%r14d
	andl	%r11d,%edi

	rorl	$5,%r13d
	addl	%ecx,%r12d
	xorl	%ebx,%edi

	rorl	$11,%r14d
	xorl	%r11d,%r13d
	addl	%edi,%r12d

	movl	%edx,%edi
	addl	20(%rbp),%r12d
	xorl	%edx,%r14d

	xorl	%r8d,%edi
	rorl	$6,%r13d
	movl	%r8d,%ecx

	andl	%edi,%r15d
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%r15d,%ecx
	addl	%r12d,%r10d
	addl	%r12d,%ecx
	addl	%r14d,%ecx
	movl	24(%rsi),%r12d
	movl	%r10d,%r13d
	movl	%ecx,%r14d
	bswapl	%r12d
	rorl	$14,%r13d
	movl	%r11d,%r15d

	xorl	%r10d,%r13d
	rorl	$9,%r14d
	xorl	%eax,%r15d

	movl	%r12d,24(%rsp)
	xorl	%ecx,%r14d
	andl	%r10d,%r15d

	rorl	$5,%r13d
	addl	%ebx,%r12d
	xorl	%eax,%r15d

	rorl	$11,%r14d
	xorl	%r10d,%r13d
	addl	%r15d,%r12d

	movl	%ecx,%r15d
	addl	24(%rbp),%r12d
	xorl	%ecx,%r14d

	xorl	%edx,%r15d
	rorl	$6,%r13d
	movl	%edx,%ebx

	andl	%r15d,%edi
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%edi,%ebx
	addl	%r12d,%r9d
	addl	%r12d,%ebx
	addl	%r14d,%ebx
	movl	28(%rsi),%r12d
	movl	%r9d,%r13d
	movl	%ebx,%r14d
	bswapl	%r12d
	rorl	$14,%r13d
	movl	%r10d,%edi

	xorl	%r9d,%r13d
	rorl	$9,%r14d
	xorl	%r11d,%edi

	movl	%r12d,28(%rsp)
	xorl	%ebx,%r14d
	andl	%r9d,%edi

	rorl	$5,%r13d
	addl	%eax,%r12d
	xorl	%r11d,%edi

	rorl	$11,%r14d
	xorl	%r9d,%r13d
	addl	%edi,%r12d

	movl	%ebx,%edi
	addl	28(%rbp),%r12d
	xorl	%ebx,%r14d

	xorl	%ecx,%edi
	rorl	$6,%r13d
	movl	%ecx,%eax

	andl	%edi,%r15d
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%r15d,%eax
	addl	%r12d,%r8d
	addl	%r12d,%eax
	addl	%r14d,%eax
	movl	32(%rsi),%r12d
	movl	%r8d,%r13d
	movl	%eax,%r14d
	bswapl	%r12d
	rorl	$14,%r13d
	movl	%r9d,%r15d

	xorl	%r8d,%r13d
	rorl	$9,%r14d
	xorl	%r10d,%r15d

	movl	%r12d,32(%rsp)
	xorl	%eax,%r14d
	andl	%r8d,%r15d

	rorl	$5,%r13d
	addl	%r11d,%r12d
	xorl	%r10d,%r15d

	rorl	$11,%r14d
	xorl	%r8d,%r13d
	addl	%r15d,%r12d

	movl	%eax,%r15d
	addl	32(%rbp),%r12d
	xorl	%eax,%r14d

	xorl	%ebx,%r15d
	rorl	$6,%r13d
	movl	%ebx,%r11d

	andl	%r15d,%edi
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%edi,%r11d
	addl	%r12d,%edx
	addl	%r12d,%r11d
	addl	%r14d,%r11d
	movl	36(%rsi),%r12d
	movl	%edx,%r13d
	movl	%r11d,%r14d
	bswapl	%r12d
	rorl	$14,%r13d
	movl	%r8d,%edi

	xorl	%edx,%r13d
	rorl	$9,%r14d
	xorl	%r9d,%edi

	movl	%r12d,36(%rsp)
	xorl	%r11d,%r14d
	andl	%edx,%edi

	rorl	$5,%r13d
	addl	%r10d,%r12d
	xorl	%r9d,%edi

	rorl	$11,%r14d
	xorl	%edx,%r13d
	addl	%edi,%r12d

	movl	%r11d,%edi
	addl	36(%rbp),%r12d
	xorl	%r11d,%r14d

	xorl	%eax,%edi
	rorl	$6,%r13d
	movl	%eax,%r10d

	andl	%edi,%r15d
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%r15d,%r10d
	addl	%r12d,%ecx
	addl	%r12d,%r10d
	addl	%r14d,%r10d
	movl	40(%rsi),%r12d
	movl	%ecx,%r13d
	movl	%r10d,%r14d
	bswapl	%r12d
	rorl	$14,%r13d
	movl	%edx,%r15d

	xorl	%ecx,%r13d
	rorl	$9,%r14d
	xorl	%r8d,%r15d

	movl	%r12d,40(%rsp)
	xorl	%r10d,%r14d
	andl	%ecx,%r15d

	rorl	$5,%r13d
	addl	%r9d,%r12d
	xorl	%r8d,%r15d

	rorl	$11,%r14d
	xorl	%ecx,%r13d
	addl	%r15d,%r12d

	movl	%r10d,%r15d
	addl	40(%rbp),%r12d
	xorl	%r10d,%r14d

	xorl	%r11d,%r15d
	rorl	$6,%r13d
	movl	%r11d,%r9d

	andl	%r15d,%edi
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%edi,%r9d
	addl	%r12d,%ebx
	addl	%r12d,%r9d
	addl	%r14d,%r9d
	movl	44(%rsi),%r12d
	movl	%ebx,%r13d
	movl	%r9d,%r14d
	bswapl	%r12d
	rorl	$14,%r13d
	movl	%ecx,%edi

	xorl	%ebx,%r13d
	rorl	$9,%r14d
	xorl	%edx,%edi

	movl	%r12d,44(%rsp)
	xorl	%r9d,%r14d
	andl	%ebx,%edi

	rorl	$5,%r13d
	addl	%r8d,%r12d
	xorl	%edx,%edi

	rorl	$11,%r14d
	xorl	%ebx,%r13d
	addl	%edi,%r12d

	movl	%r9d,%edi
	addl	44(%rbp),%r12d
	xorl	%r9d,%r14d

	xorl	%r10d,%edi
	rorl	$6,%r13d
	movl	%r10d,%r8d

	andl	%edi,%r15d
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%r15d,%r8d
	addl	%r12d,%eax
	addl	%r12d,%r8d
	addl	%r14d,%r8d
	movl	48(%rsi),%r12d
	movl	%eax,%r13d
	movl	%r8d,%r14d
	bswapl	%r12d
	rorl	$14,%r13d
	movl	%ebx,%r15d

	xorl	%eax,%r13d
	rorl	$9,%r14d
	xorl	%ecx,%r15d

	movl	%r12d,48(%rsp)
	xorl	%r8d,%r14d
	andl	%eax,%r15d

	rorl	$5,%r13d
	addl	%edx,%r12d
	xorl	%ecx,%r15d

	rorl	$11,%r14d
	xorl	%eax,%r13d
	addl	%r15d,%r12d

	movl	%r8d,%r15d
	addl	48(%rbp),%r12d
	xorl	%r8d,%r14d

	xorl	%r9d,%r15d
	rorl	$6,%r13d
	movl	%r9d,%edx

	andl	%r15d,%edi
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%edi,%edx
	addl	%r12d,%r11d
	addl	%r12d,%edx
	addl	%r14d,%edx
	movl	52(%rsi),%r12d
	movl	%r11d,%r13d
	movl	%edx,%r14d
	bswapl	%r12d
	rorl	$14,%r13d
	movl	%eax,%edi

	xorl	%r11d,%r13d
	rorl	$9,%r14d
	xorl	%ebx,%edi

	movl	%r12d,52(%rsp)
	xorl	%edx,%r14d
	andl	%r11d,%edi

	rorl	$5,%r13d
	addl	%ecx,%r12d
	xorl	%ebx,%edi

	rorl	$11,%r14d
	xorl	%r11d,%r13d
	addl	%edi,%r12d

	movl	%edx,%edi
	addl	52(%rbp),%r12d
	xorl	%edx,%r14d

	xorl	%r8d,%edi
	rorl	$6,%r13d
	movl	%r8d,%ecx

	andl	%edi,%r15d
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%r15d,%ecx
	addl	%r12d,%r10d
	addl	%r12d,%ecx
	addl	%r14d,%ecx
	movl	56(%rsi),%r12d
	movl	%r10d,%r13d
	movl	%ecx,%r14d
	bswapl	%r12d
	rorl	$14,%r13d
	movl	%r11d,%r15d

	xorl	%r10d,%r13d
	rorl	$9,%r14d
	xorl	%eax,%r15d

	movl	%r12d,56(%rsp)
	xorl	%ecx,%r14d
	andl	%r10d,%r15d

	rorl	$5,%r13d
	addl	%ebx,%r12d
	xorl	%eax,%r15d

	rorl	$11,%r14d
	xorl	%r10d,%r13d
	addl	%r15d,%r12d

	movl	%ecx,%r15d
	addl	56(%rbp),%r12d
	xorl	%ecx,%r14d

	xorl	%edx,%r15d
	rorl	$6,%r13d
	movl	%edx,%ebx

	andl	%r15d,%edi
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%edi,%ebx
	addl	%r12d,%r9d
	addl	%r12d,%ebx
	addl	%r14d,%ebx
	movl	60(%rsi),%r12d
	movl	%r9d,%r13d
	movl	%ebx,%r14d
	bswapl	%r12d
	rorl	$14,%r13d
	movl	%r10d,%edi

	xorl	%r9d,%r13d
	rorl	$9,%r14d
	xorl	%r11d,%edi

	movl	%r12d,60(%rsp)
	xorl	%ebx,%r14d
	andl	%r9d,%edi

	rorl	$5,%r13d
	addl	%eax,%r12d
	xorl	%r11d,%edi

	rorl	$11,%r14d
	xorl	%r9d,%r13d
	addl	%edi,%r12d

	movl	%ebx,%edi
	addl	60(%rbp),%r12d
	xorl	%ebx,%r14d

	xorl	%ecx,%edi
	rorl	$6,%r13d
	movl	%ecx,%eax

	andl	%edi,%r15d
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%r15d,%eax
	addl	%r12d,%r8d
	addl	%r12d,%eax
	jmp	.Lrounds_16_xx
.p2align	4
.Lrounds_16_xx:
	movl	4(%rsp),%r13d
	movl	56(%rsp),%r15d

	movl	%r13d,%r12d
	rorl	$11,%r13d
	addl	%r14d,%eax
	movl	%r15d,%r14d
	rorl	$2,%r15d

	xorl	%r12d,%r13d
	shrl	$3,%r12d
	rorl	$7,%r13d
	xorl	%r14d,%r15d
	shrl	$10,%r14d

	rorl	$17,%r15d
	xorl	%r13d,%r12d
	xorl	%r14d,%r15d
	addl	36(%rsp),%r12d

	addl	0(%rsp),%r12d
	movl	%r8d,%r13d
	addl	%r15d,%r12d
	movl	%eax,%r14d
	rorl	$14,%r13d
	movl	%r9d,%r15d

	xorl	%r8d,%r13d
	rorl	$9,%r14d
	xorl	%r10d,%r15d

	movl	%r12d,0(%rsp)
	xorl	%eax,%r14d
	andl	%r8d,%r15d

	rorl	$5,%r13d
	addl	%r11d,%r12d
	xorl	%r10d,%r15d

	rorl	$11,%r14d
	xorl	%r8d,%r13d
	addl	%r15d,%r12d

	movl	%eax,%r15d
	addl	64(%rbp),%r12d
	xorl	%eax,%r14d

	xorl	%ebx,%r15d
	rorl	$6,%r13d
	movl	%ebx,%r11d

	andl	%r15d,%edi
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%edi,%r11d
	addl	%r12d,%edx
	addl	%r12d,%r11d
	movl	8(%rsp),%r13d
	movl	60(%rsp),%edi

	movl	%r13d,%r12d
	rorl	$11,%r13d
	addl	%r14d,%r11d
	movl	%edi,%r14d
	rorl	$2,%edi

	xorl	%r12d,%r13d
	shrl	$3,%r12d
	rorl	$7,%r13d
	xorl	%r14d,%edi
	shrl	$10,%r14d

	rorl	$17,%edi
	xorl	%r13d,%r12d
	xorl	%r14d,%edi
	addl	40(%rsp),%r12d

	addl	4(%rsp),%r12d
	movl	%edx,%r13d
	addl	%edi,%r12d
	movl	%r11d,%r14d
	rorl	$14,%r13d
	movl	%r8d,%edi

	xorl	%edx,%r13d
	rorl	$9,%r14d
	xorl	%r9d,%edi

	movl	%r12d,4(%rsp)
	xorl	%r11d,%r14d
	andl	%edx,%edi

	rorl	$5,%r13d
	addl	%r10d,%r12d
	xorl	%r9d,%edi

	rorl	$11,%r14d
	xorl	%edx,%r13d
	addl	%edi,%r12d

	movl	%r11d,%edi
	addl	68(%rbp),%r12d
	xorl	%r11d,%r14d

	xorl	%eax,%edi
	rorl	$6,%r13d
	movl	%eax,%r10d

	andl	%edi,%r15d
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%r15d,%r10d
	addl	%r12d,%ecx
	addl	%r12d,%r10d
	movl	12(%rsp),%r13d
	movl	0(%rsp),%r15d

	movl	%r13d,%r12d
	rorl	$11,%r13d
	addl	%r14d,%r10d
	movl	%r15d,%r14d
	rorl	$2,%r15d

	xorl	%r12d,%r13d
	shrl	$3,%r12d
	rorl	$7,%r13d
	xorl	%r14d,%r15d
	shrl	$10,%r14d

	rorl	$17,%r15d
	xorl	%r13d,%r12d
	xorl	%r14d,%r15d
	addl	44(%rsp),%r12d

	addl	8(%rsp),%r12d
	movl	%ecx,%r13d
	addl	%r15d,%r12d
	movl	%r10d,%r14d
	rorl	$14,%r13d
	movl	%edx,%r15d

	xorl	%ecx,%r13d
	rorl	$9,%r14d
	xorl	%r8d,%r15d

	movl	%r12d,8(%rsp)
	xorl	%r10d,%r14d
	andl	%ecx,%r15d

	rorl	$5,%r13d
	addl	%r9d,%r12d
	xorl	%r8d,%r15d

	rorl	$11,%r14d
	xorl	%ecx,%r13d
	addl	%r15d,%r12d

	movl	%r10d,%r15d
	addl	72(%rbp),%r12d
	xorl	%r10d,%r14d

	xorl	%r11d,%r15d
	rorl	$6,%r13d
	movl	%r11d,%r9d

	andl	%r15d,%edi
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%edi,%r9d
	addl	%r12d,%ebx
	addl	%r12d,%r9d
	movl	16(%rsp),%r13d
	movl	4(%rsp),%edi

	movl	%r13d,%r12d
	rorl	$11,%r13d
	addl	%r14d,%r9d
	movl	%edi,%r14d
	rorl	$2,%edi

	xorl	%r12d,%r13d
	shrl	$3,%r12d
	rorl	$7,%r13d
	xorl	%r14d,%edi
	shrl	$10,%r14d

	rorl	$17,%edi
	xorl	%r13d,%r12d
	xorl	%r14d,%edi
	addl	48(%rsp),%r12d

	addl	12(%rsp),%r12d
	movl	%ebx,%r13d
	addl	%edi,%r12d
	movl	%r9d,%r14d
	rorl	$14,%r13d
	movl	%ecx,%edi

	xorl	%ebx,%r13d
	rorl	$9,%r14d
	xorl	%edx,%edi

	movl	%r12d,12(%rsp)
	xorl	%r9d,%r14d
	andl	%ebx,%edi

	rorl	$5,%r13d
	addl	%r8d,%r12d
	xorl	%edx,%edi

	rorl	$11,%r14d
	xorl	%ebx,%r13d
	addl	%edi,%r12d

	movl	%r9d,%edi
	addl	76(%rbp),%r12d
	xorl	%r9d,%r14d

	xorl	%r10d,%edi
	rorl	$6,%r13d
	movl	%r10d,%r8d

	andl	%edi,%r15d
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%r15d,%r8d
	addl	%r12d,%eax
	addl	%r12d,%r8d
	movl	20(%rsp),%r13d
	movl	8(%rsp),%r15d

	movl	%r13d,%r12d
	rorl	$11,%r13d
	addl	%r14d,%r8d
	movl	%r15d,%r14d
	rorl	$2,%r15d

	xorl	%r12d,%r13d
	shrl	$3,%r12d
	rorl	$7,%r13d
	xorl	%r14d,%r15d
	shrl	$10,%r14d

	rorl	$17,%r15d
	xorl	%r13d,%r12d
	xorl	%r14d,%r15d
	addl	52(%rsp),%r12d

	addl	16(%rsp),%r12d
	movl	%eax,%r13d
	addl	%r15d,%r12d
	movl	%r8d,%r14d
	rorl	$14,%r13d
	movl	%ebx,%r15d

	xorl	%eax,%r13d
	rorl	$9,%r14d
	xorl	%ecx,%r15d

	movl	%r12d,16(%rsp)
	xorl	%r8d,%r14d
	andl	%eax,%r15d

	rorl	$5,%r13d
	addl	%edx,%r12d
	xorl	%ecx,%r15d

	rorl	$11,%r14d
	xorl	%eax,%r13d
	addl	%r15d,%r12d

	movl	%r8d,%r15d
	addl	80(%rbp),%r12d
	xorl	%r8d,%r14d

	xorl	%r9d,%r15d
	rorl	$6,%r13d
	movl	%r9d,%edx

	andl	%r15d,%edi
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%edi,%edx
	addl	%r12d,%r11d
	addl	%r12d,%edx
	movl	24(%rsp),%r13d
	movl	12(%rsp),%edi

	movl	%r13d,%r12d
	rorl	$11,%r13d
	addl	%r14d,%edx
	movl	%edi,%r14d
	rorl	$2,%edi

	xorl	%r12d,%r13d
	shrl	$3,%r12d
	rorl	$7,%r13d
	xorl	%r14d,%edi
	shrl	$10,%r14d

	rorl	$17,%edi
	xorl	%r13d,%r12d
	xorl	%r14d,%edi
	addl	56(%rsp),%r12d

	addl	20(%rsp),%r12d
	movl	%r11d,%r13d
	addl	%edi,%r12d
	movl	%edx,%r14d
	rorl	$14,%r13d
	movl	%eax,%edi

	xorl	%r11d,%r13d
	rorl	$9,%r14d
	xorl	%ebx,%edi

	movl	%r12d,20(%rsp)
	xorl	%edx,%r14d
	andl	%r11d,%edi

	rorl	$5,%r13d
	addl	%ecx,%r12d
	xorl	%ebx,%edi

	rorl	$11,%r14d
	xorl	%r11d,%r13d
	addl	%edi,%r12d

	movl	%edx,%edi
	addl	84(%rbp),%r12d
	xorl	%edx,%r14d

	xorl	%r8d,%edi
	rorl	$6,%r13d
	movl	%r8d,%ecx

	andl	%edi,%r15d
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%r15d,%ecx
	addl	%r12d,%r10d
	addl	%r12d,%ecx
	movl	28(%rsp),%r13d
	movl	16(%rsp),%r15d

	movl	%r13d,%r12d
	rorl	$11,%r13d
	addl	%r14d,%ecx
	movl	%r15d,%r14d
	rorl	$2,%r15d

	xorl	%r12d,%r13d
	shrl	$3,%r12d
	rorl	$7,%r13d
	xorl	%r14d,%r15d
	shrl	$10,%r14d

	rorl	$17,%r15d
	xorl	%r13d,%r12d
	xorl	%r14d,%r15d
	addl	60(%rsp),%r12d

	addl	24(%rsp),%r12d
	movl	%r10d,%r13d
	addl	%r15d,%r12d
	movl	%ecx,%r14d
	rorl	$14,%r13d
	movl	%r11d,%r15d

	xorl	%r10d,%r13d
	rorl	$9,%r14d
	xorl	%eax,%r15d

	movl	%r12d,24(%rsp)
	xorl	%ecx,%r14d
	andl	%r10d,%r15d

	rorl	$5,%r13d
	addl	%ebx,%r12d
	xorl	%eax,%r15d

	rorl	$11,%r14d
	xorl	%r10d,%r13d
	addl	%r15d,%r12d

	movl	%ecx,%r15d
	addl	88(%rbp),%r12d
	xorl	%ecx,%r14d

	xorl	%edx,%r15d
	rorl	$6,%r13d
	movl	%edx,%ebx

	andl	%r15d,%edi
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%edi,%ebx
	addl	%r12d,%r9d
	addl	%r12d,%ebx
	movl	32(%rsp),%r13d
	movl	20(%rsp),%edi

	movl	%r13d,%r12d
	rorl	$11,%r13d
	addl	%r14d,%ebx
	movl	%edi,%r14d
	rorl	$2,%edi

	xorl	%r12d,%r13d
	shrl	$3,%r12d
	rorl	$7,%r13d
	xorl	%r14d,%edi
	shrl	$10,%r14d

	rorl	$17,%edi
	xorl	%r13d,%r12d
	xorl	%r14d,%edi
	addl	0(%rsp),%r12d

	addl	28(%rsp),%r12d
	movl	%r9d,%r13d
	addl	%edi,%r12d
	movl	%ebx,%r14d
	rorl	$14,%r13d
	movl	%r10d,%edi

	xorl	%r9d,%r13d
	rorl	$9,%r14d
	xorl	%r11d,%edi

	movl	%r12d,28(%rsp)
	xorl	%ebx,%r14d
	andl	%r9d,%edi

	rorl	$5,%r13d
	addl	%eax,%r12d
	xorl	%r11d,%edi

	rorl	$11,%r14d
	xorl	%r9d,%r13d
	addl	%edi,%r12d

	movl	%ebx,%edi
	addl	92(%rbp),%r12d
	xorl	%ebx,%r14d

	xorl	%ecx,%edi
	rorl	$6,%r13d
	movl	%ecx,%eax

	andl	%edi,%r15d
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%r15d,%eax
	addl	%r12d,%r8d
	addl	%r12d,%eax
	movl	36(%rsp),%r13d
	movl	24(%rsp),%r15d

	movl	%r13d,%r12d
	rorl	$11,%r13d
	addl	%r14d,%eax
	movl	%r15d,%r14d
	rorl	$2,%r15d

	xorl	%r12d,%r13d
	shrl	$3,%r12d
	rorl	$7,%r13d
	xorl	%r14d,%r15d
	shrl	$10,%r14d

	rorl	$17,%r15d
	xorl	%r13d,%r12d
	xorl	%r14d,%r15d
	addl	4(%rsp),%r12d

	addl	32(%rsp),%r12d
	movl	%r8d,%r13d
	addl	%r15d,%r12d
	movl	%eax,%r14d
	rorl	$14,%r13d
	movl	%r9d,%r15d

	xorl	%r8d,%r13d
	rorl	$9,%r14d
	xorl	%r10d,%r15d

	movl	%r12d,32(%rsp)
	xorl	%eax,%r14d
	andl	%r8d,%r15d

	rorl	$5,%r13d
	addl	%r11d,%r12d
	xorl	%r10d,%r15d

	rorl	$11,%r14d
	xorl	%r8d,%r13d
	addl	%r15d,%r12d

	movl	%eax,%r15d
	addl	96(%rbp),%r12d
	xorl	%eax,%r14d

	xorl	%ebx,%r15d
	rorl	$6,%r13d
	movl	%ebx,%r11d

	andl	%r15d,%edi
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%edi,%r11d
	addl	%r12d,%edx
	addl	%r12d,%r11d
	movl	40(%rsp),%r13d
	movl	28(%rsp),%edi

	movl	%r13d,%r12d
	rorl	$11,%r13d
	addl	%r14d,%r11d
	movl	%edi,%r14d
	rorl	$2,%edi

	xorl	%r12d,%r13d
	shrl	$3,%r12d
	rorl	$7,%r13d
	xorl	%r14d,%edi
	shrl	$10,%r14d

	rorl	$17,%edi
	xorl	%r13d,%r12d
	xorl	%r14d,%edi
	addl	8(%rsp),%r12d

	addl	36(%rsp),%r12d
	movl	%edx,%r13d
	addl	%edi,%r12d
	movl	%r11d,%r14d
	rorl	$14,%r13d
	movl	%r8d,%edi

	xorl	%edx,%r13d
	rorl	$9,%r14d
	xorl	%r9d,%edi

	movl	%r12d,36(%rsp)
	xorl	%r11d,%r14d
	andl	%edx,%edi

	rorl	$5,%r13d
	addl	%r10d,%r12d
	xorl	%r9d,%edi

	rorl	$11,%r14d
	xorl	%edx,%r13d
	addl	%edi,%r12d

	movl	%r11d,%edi
	addl	100(%rbp),%r12d
	xorl	%r11d,%r14d

	xorl	%eax,%edi
	rorl	$6,%r13d
	movl	%eax,%r10d

	andl	%edi,%r15d
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%r15d,%r10d
	addl	%r12d,%ecx
	addl	%r12d,%r10d
	movl	44(%rsp),%r13d
	movl	32(%rsp),%r15d

	movl	%r13d,%r12d
	rorl	$11,%r13d
	addl	%r14d,%r10d
	movl	%r15d,%r14d
	rorl	$2,%r15d

	xorl	%r12d,%r13d
	shrl	$3,%r12d
	rorl	$7,%r13d
	xorl	%r14d,%r15d
	shrl	$10,%r14d

	rorl	$17,%r15d
	xorl	%r13d,%r12d
	xorl	%r14d,%r15d
	addl	12(%rsp),%r12d

	addl	40(%rsp),%r12d
	movl	%ecx,%r13d
	addl	%r15d,%r12d
	movl	%r10d,%r14d
	rorl	$14,%r13d
	movl	%edx,%r15d

	xorl	%ecx,%r13d
	rorl	$9,%r14d
	xorl	%r8d,%r15d

	movl	%r12d,40(%rsp)
	xorl	%r10d,%r14d
	andl	%ecx,%r15d

	rorl	$5,%r13d
	addl	%r9d,%r12d
	xorl	%r8d,%r15d

	rorl	$11,%r14d
	xorl	%ecx,%r13d
	addl	%r15d,%r12d

	movl	%r10d,%r15d
	addl	104(%rbp),%r12d
	xorl	%r10d,%r14d

	xorl	%r11d,%r15d
	rorl	$6,%r13d
	movl	%r11d,%r9d

	andl	%r15d,%edi
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%edi,%r9d
	addl	%r12d,%ebx
	addl	%r12d,%r9d
	movl	48(%rsp),%r13d
	movl	36(%rsp),%edi

	movl	%r13d,%r12d
	rorl	$11,%r13d
	addl	%r14d,%r9d
	movl	%edi,%r14d
	rorl	$2,%edi

	xorl	%r12d,%r13d
	shrl	$3,%r12d
	rorl	$7,%r13d
	xorl	%r14d,%edi
	shrl	$10,%r14d

	rorl	$17,%edi
	xorl	%r13d,%r12d
	xorl	%r14d,%edi
	addl	16(%rsp),%r12d

	addl	44(%rsp),%r12d
	movl	%ebx,%r13d
	addl	%edi,%r12d
	movl	%r9d,%r14d
	rorl	$14,%r13d
	movl	%ecx,%edi

	xorl	%ebx,%r13d
	rorl	$9,%r14d
	xorl	%edx,%edi

	movl	%r12d,44(%rsp)
	xorl	%r9d,%r14d
	andl	%ebx,%edi

	rorl	$5,%r13d
	addl	%r8d,%r12d
	xorl	%edx,%edi

	rorl	$11,%r14d
	xorl	%ebx,%r13d
	addl	%edi,%r12d

	movl	%r9d,%edi
	addl	108(%rbp),%r12d
	xorl	%r9d,%r14d

	xorl	%r10d,%edi
	rorl	$6,%r13d
	movl	%r10d,%r8d

	andl	%edi,%r15d
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%r15d,%r8d
	addl	%r12d,%eax
	addl	%r12d,%r8d
	movl	52(%rsp),%r13d
	movl	40(%rsp),%r15d

	movl	%r13d,%r12d
	rorl	$11,%r13d
	addl	%r14d,%r8d
	movl	%r15d,%r14d
	rorl	$2,%r15d

	xorl	%r12d,%r13d
	shrl	$3,%r12d
	rorl	$7,%r13d
	xorl	%r14d,%r15d
	shrl	$10,%r14d

	rorl	$17,%r15d
	xorl	%r13d,%r12d
	xorl	%r14d,%r15d
	addl	20(%rsp),%r12d

	addl	48(%rsp),%r12d
	movl	%eax,%r13d
	addl	%r15d,%r12d
	movl	%r8d,%r14d
	rorl	$14,%r13d
	movl	%ebx,%r15d

	xorl	%eax,%r13d
	rorl	$9,%r14d
	xorl	%ecx,%r15d

	movl	%r12d,48(%rsp)
	xorl	%r8d,%r14d
	andl	%eax,%r15d

	rorl	$5,%r13d
	addl	%edx,%r12d
	xorl	%ecx,%r15d

	rorl	$11,%r14d
	xorl	%eax,%r13d
	addl	%r15d,%r12d

	movl	%r8d,%r15d
	addl	112(%rbp),%r12d
	xorl	%r8d,%r14d

	xorl	%r9d,%r15d
	rorl	$6,%r13d
	movl	%r9d,%edx

	andl	%r15d,%edi
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%edi,%edx
	addl	%r12d,%r11d
	addl	%r12d,%edx
	movl	56(%rsp),%r13d
	movl	44(%rsp),%edi

	movl	%r13d,%r12d
	rorl	$11,%r13d
	addl	%r14d,%edx
	movl	%edi,%r14d
	rorl	$2,%edi

	xorl	%r12d,%r13d
	shrl	$3,%r12d
	rorl	$7,%r13d
	xorl	%r14d,%edi
	shrl	$10,%r14d

	rorl	$17,%edi
	xorl	%r13d,%r12d
	xorl	%r14d,%edi
	addl	24(%rsp),%r12d

	addl	52(%rsp),%r12d
	movl	%r11d,%r13d
	addl	%edi,%r12d
	movl	%edx,%r14d
	rorl	$14,%r13d
	movl	%eax,%edi

	xorl	%r11d,%r13d
	rorl	$9,%r14d
	xorl	%ebx,%edi

	movl	%r12d,52(%rsp)
	xorl	%edx,%r14d
	andl	%r11d,%edi

	rorl	$5,%r13d
	addl	%ecx,%r12d
	xorl	%ebx,%edi

	rorl	$11,%r14d
	xorl	%r11d,%r13d
	addl	%edi,%r12d

	movl	%edx,%edi
	addl	116(%rbp),%r12d
	xorl	%edx,%r14d

	xorl	%r8d,%edi
	rorl	$6,%r13d
	movl	%r8d,%ecx

	andl	%edi,%r15d
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%r15d,%ecx
	addl	%r12d,%r10d
	addl	%r12d,%ecx
	movl	60(%rsp),%r13d
	movl	48(%rsp),%r15d

	movl	%r13d,%r12d
	rorl	$11,%r13d
	addl	%r14d,%ecx
	movl	%r15d,%r14d
	rorl	$2,%r15d

	xorl	%r12d,%r13d
	shrl	$3,%r12d
	rorl	$7,%r13d
	xorl	%r14d,%r15d
	shrl	$10,%r14d

	rorl	$17,%r15d
	xorl	%r13d,%r12d
	xorl	%r14d,%r15d
	addl	28(%rsp),%r12d

	addl	56(%rsp),%r12d
	movl	%r10d,%r13d
	addl	%r15d,%r12d
	movl	%ecx,%r14d
	rorl	$14,%r13d
	movl	%r11d,%r15d

	xorl	%r10d,%r13d
	rorl	$9,%r14d
	xorl	%eax,%r15d

	movl	%r12d,56(%rsp)
	xorl	%ecx,%r14d
	andl	%r10d,%r15d

	rorl	$5,%r13d
	addl	%ebx,%r12d
	xorl	%eax,%r15d

	rorl	$11,%r14d
	xorl	%r10d,%r13d
	addl	%r15d,%r12d

	movl	%ecx,%r15d
	addl	120(%rbp),%r12d
	xorl	%ecx,%r14d

	xorl	%edx,%r15d
	rorl	$6,%r13d
	movl	%edx,%ebx

	andl	%r15d,%edi
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%edi,%ebx
	addl	%r12d,%r9d
	addl	%r12d,%ebx
	movl	0(%rsp),%r13d
	movl	52(%rsp),%edi

	movl	%r13d,%r12d
	rorl	$11,%r13d
	addl	%r14d,%ebx
	movl	%edi,%r14d
	rorl	$2,%edi

	xorl	%r12d,%r13d
	shrl	$3,%r12d
	rorl	$7,%r13d
	xorl	%r14d,%edi
	shrl	$10,%r14d

	rorl	$17,%edi
	xorl	%r13d,%r12d
	xorl	%r14d,%edi
	addl	32(%rsp),%r12d

	addl	60(%rsp),%r12d
	movl	%r9d,%r13d
	addl	%edi,%r12d
	movl	%ebx,%r14d
	rorl	$14,%r13d
	movl	%r10d,%edi

	xorl	%r9d,%r13d
	rorl	$9,%r14d
	xorl	%r11d,%edi

	movl	%r12d,60(%rsp)
	xorl	%ebx,%r14d
	andl	%r9d,%edi

	rorl	$5,%r13d
	addl	%eax,%r12d
	xorl	%r11d,%edi

	rorl	$11,%r14d
	xorl	%r9d,%r13d
	addl	%edi,%r12d

	movl	%ebx,%edi
	addl	124(%rbp),%r12d
	xorl	%ebx,%r14d

	xorl	%ecx,%edi
	rorl	$6,%r13d
	movl	%ecx,%eax

	andl	%edi,%r15d
	rorl	$2,%r14d
	addl	%r13d,%r12d

	xorl	%r15d,%eax
	addl	%r12d,%r8d
	addl	%r12d,%eax
	leaq	64(%rbp),%rbp
	cmpb	$0x19,3(%rbp)
	jnz	.Lrounds_16_xx

	movq	64+0(%rsp),%rdi
	addl	%r14d,%eax
	leaq	64(%rsi),%rsi

	addl	0(%rdi),%eax
	addl	4(%rdi),%ebx
	addl	8(%rdi),%ecx
	addl	12(%rdi),%edx
	addl	16(%rdi),%r8d
	addl	20(%rdi),%r9d
	addl	24(%rdi),%r10d
	addl	28(%rdi),%r11d

	cmpq	64+16(%rsp),%rsi

	movl	%eax,0(%rdi)
	movl	%ebx,4(%rdi)
	movl	%ecx,8(%rdi)
	movl	%edx,12(%rdi)
	movl	%r8d,16(%rdi)
	movl	%r9d,20(%rdi)
	movl	%r10d,24(%rdi)
	movl	%r11d,28(%rdi)
	jb	.Lloop

	leaq	64+24+48(%rsp),%r11

	movq	64+24(%rsp),%r15

	movq	-40(%r11),%r14

	movq	-32(%r11),%r13

	movq	-24(%r11),%r12

	movq	-16(%r11),%rbp

	movq	-8(%r11),%rbx

.LSEH_epilogue_blst_sha256_block_data_order_portable:
	mov	8(%r11),%rdi
	mov	16(%r11),%rsi

	leaq	(%r11),%rsp
	.byte	0xf3,0xc3

.LSEH_end_blst_sha256_block_data_order_portable:

.p2align	6

__sha256_portable_K256:
.long	0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5
.long	0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5
.long	0xd807aa98,0x12835b01,0x243185be,0x550c7dc3
.long	0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174
.long	0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc
.long	0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da
.long	0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7
.long	0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967
.long	0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13
.long	0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85
.long	0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3
.long	0xd192e819,0xd6990624,0xf40e3585,0x106aa070
.long	0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5
.long	0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3
.long	0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208
.long	0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2

.byte	83,72,65,50,53,54,32,98,108,111,99,107,32,116,114,97,110,115,102,111,114,109,32,102,111,114,32,120,56,54,95,54,52,44,32,67,82,89,80,84,79,71,65,77,83,32,98,121,32,64,100,111,116,45,97,115,109,0
.globl	blst_sha256_emit

.def	blst_sha256_emit;	.scl 2;	.type 32;	.endef
.p2align	4
blst_sha256_emit:
	.byte	0xf3,0x0f,0x1e,0xfa

	movq	0(%rdx),%r8
	movq	8(%rdx),%r9
	movq	16(%rdx),%r10
	bswapq	%r8
	movq	24(%rdx),%r11
	bswapq	%r9
	movl	%r8d,4(%rcx)
	bswapq	%r10
	movl	%r9d,12(%rcx)
	bswapq	%r11
	movl	%r10d,20(%rcx)
	shrq	$32,%r8
	movl	%r11d,28(%rcx)
	shrq	$32,%r9
	movl	%r8d,0(%rcx)
	shrq	$32,%r10
	movl	%r9d,8(%rcx)
	shrq	$32,%r11
	movl	%r10d,16(%rcx)
	movl	%r11d,24(%rcx)
	.byte	0xf3,0xc3


.globl	blst_sha256_bcopy

.def	blst_sha256_bcopy;	.scl 2;	.type 32;	.endef
.p2align	4
blst_sha256_bcopy:
	.byte	0xf3,0x0f,0x1e,0xfa

	subq	%rdx,%rcx
.Loop_bcopy:
	movzbl	(%rdx),%eax
	leaq	1(%rdx),%rdx
	movb	%al,-1(%rcx,%rdx,1)
	decq	%r8
	jnz	.Loop_bcopy
	.byte	0xf3,0xc3


.globl	blst_sha256_hcopy

.def	blst_sha256_hcopy;	.scl 2;	.type 32;	.endef
.p2align	4
blst_sha256_hcopy:
	.byte	0xf3,0x0f,0x1e,0xfa

	movq	0(%rdx),%r8
	movq	8(%rdx),%r9
	movq	16(%rdx),%r10
	movq	24(%rdx),%r11
	movq	%r8,0(%rcx)
	movq	%r9,8(%rcx)
	movq	%r10,16(%rcx)
	movq	%r11,24(%rcx)
	.byte	0xf3,0xc3

.section	.pdata
.p2align	2
.rva	.LSEH_begin_blst_sha256_block_data_order_portable
.rva	.LSEH_body_blst_sha256_block_data_order_portable
.rva	.LSEH_info_blst_sha256_block_data_order_portable_prologue

.rva	.LSEH_body_blst_sha256_block_data_order_portable
.rva	.LSEH_epilogue_blst_sha256_block_data_order_portable
.rva	.LSEH_info_blst_sha256_block_data_order_portable_body

.rva	.LSEH_epilogue_blst_sha256_block_data_order_portable
.rva	.LSEH_end_blst_sha256_block_data_order_portable
.rva	.LSEH_info_blst_sha256_block_data_order_portable_epilogue

.section	.xdata
.p2align	3
.LSEH_info_blst_sha256_block_data_order_portable_prologue:
.byte	1,0,5,0x0b
.byte	0,0x74,1,0
.byte	0,0x64,2,0
.byte	0,0x03
.byte	0,0
.LSEH_info_blst_sha256_block_data_order_portable_body:
.byte	1,0,18,0
.byte	0x00,0xf4,0x0b,0x00
.byte	0x00,0xe4,0x0c,0x00
.byte	0x00,0xd4,0x0d,0x00
.byte	0x00,0xc4,0x0e,0x00
.byte	0x00,0x54,0x0f,0x00
.byte	0x00,0x34,0x10,0x00
.byte	0x00,0x74,0x12,0x00
.byte	0x00,0x64,0x13,0x00
.byte	0x00,0x01,0x11,0x00
.LSEH_info_blst_sha256_block_data_order_portable_epilogue:
.byte	1,0,5,11
.byte	0x00,0x74,0x01,0x00
.byte	0x00,0x64,0x02,0x00
.byte	0x00,0x03
.byte	0x00,0x00

