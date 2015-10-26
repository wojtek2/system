	.file	"bdds.c"
#APP
	.code32
	.section	.rodata
.LC0:
	.string	"\n"
.LC1:
	.string	"\r"
#NO_APP
	.text
	.globl	printpm
	.type	printpm, @function
printpm:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%esi
	subl	$16, %esp
	.cfi_offset 6, -12
	movw	$2000, GDTS+32
	movw	$-32768, GDTS+34
	movb	$11, GDTS+36
	movzbl	GDTS+37, %eax
	andl	$-2, %eax
	movb	%al, GDTS+37
	movzbl	GDTS+37, %eax
	orl	$2, %eax
	movb	%al, GDTS+37
	movzbl	GDTS+37, %eax
	andl	$-5, %eax
	movb	%al, GDTS+37
	movzbl	GDTS+37, %eax
	andl	$-9, %eax
	movb	%al, GDTS+37
	movzbl	GDTS+37, %eax
	orl	$16, %eax
	movb	%al, GDTS+37
	movzbl	GDTS+37, %eax
	andl	$-97, %eax
	movb	%al, GDTS+37
	movzbl	GDTS+37, %eax
	orl	$-128, %eax
	movb	%al, GDTS+37
	movzbl	GDTS+38, %eax
	andl	$-16, %eax
	movb	%al, GDTS+38
	movzbl	GDTS+38, %eax
	andl	$-17, %eax
	movb	%al, GDTS+38
	movzbl	GDTS+38, %eax
	andl	$-33, %eax
	movb	%al, GDTS+38
	movzbl	GDTS+38, %eax
	orl	$64, %eax
	movb	%al, GDTS+38
	movzbl	GDTS+38, %eax
	andl	$127, %eax
	movb	%al, GDTS+38
	movw	$0, -6(%ebp)
	jmp	.L2
.L6:
	movzwl	-6(%ebp), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	movb	%al, -7(%ebp)
	movsbl	-7(%ebp), %eax
	cmpl	$.LC0, %eax
	jne	.L3
	movzbl	y.1441, %eax
	addl	$1, %eax
	movb	%al, y.1441
	movzbl	y.1441, %eax
	cmpb	$25, %al
	jne	.L4
	movb	$0, y.1441
	jmp	.L4
.L3:
	movsbl	-7(%ebp), %eax
	cmpl	$.LC1, %eax
	jne	.L5
	movb	$0, x.1440
	jmp	.L4
.L5:
	movzbl	y.1441, %eax
	movzbl	%al, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$4, %eax
	movl	%eax, %edx
	movzbl	x.1440, %eax
	movzbl	%al, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movw	%ax, count.1439
	movzwl	count.1439, %edx
	movzbl	-7(%ebp), %ecx
	movl	%edx, %esi
#APP
# 44 "./include/bdds.c" 1
	movw $0x20,%ax
movw %ax,%es
movb %cl,%es:(%si)
inc %si
movb $0x7,%es:(1)

# 0 "" 2
#NO_APP
	movzbl	x.1440, %eax
	addl	$1, %eax
	movb	%al, x.1440
.L4:
	addw	$1, -6(%ebp)
.L2:
	movzwl	-6(%ebp), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L6
	addl	$16, %esp
	popl	%esi
	.cfi_restore 6
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	printpm, .-printpm
#APP
	.code16gcc
#NO_APP
	.globl	printrm
	.type	printrm, @function
printrm:
.LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movb	$14, -2(%ebp)
	movb	$0, -1(%ebp)
	jmp	.L8
.L9:
	movsbl	-1(%ebp), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	movb	%al, -2(%ebp)
	movzbl	-2(%ebp), %eax
#APP
# 71 "./include/bdds.c" 1
	.intel_syntax noprefix
push ax
push bx
push cx
push dx
mov ah,0xE
mov al,%al
mov bl,7
mov bh,0
int 0x10
pop dx
pop cx
pop bx
pop ax
.att_syntax prefix

# 0 "" 2
#NO_APP
	addb	$1, -1(%ebp)
.L8:
	movsbl	-1(%ebp), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L9
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	printrm, .-printrm
	.local	y.1441
	.comm	y.1441,1,1
	.local	x.1440
	.comm	x.1440,1,1
	.local	count.1439
	.comm	count.1439,2,2
	.ident	"GCC: (Debian 4.7.2-5) 4.7.2"
	.section	.note.GNU-stack,"",@progbits
