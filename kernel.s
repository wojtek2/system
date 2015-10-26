	.file	"kernel.c"
	.text
.Ltext0:
	.comm	PTE,4,4
	.comm	GDTS,2048,64
	.comm	IDTS,2048,64
	.comm	GDTDescr,6,2
	.comm	IDTDescr,6,2
	.comm	Tasks,1520,64
	.comm	ActTaskTSS,4,4
	.comm	KernelPDEA,4,4
	.comm	KernelPTEA,4,4
	.globl	KernelPDE
	.section	.KernelPDESect,"aw",@progbits
	.align 8192
	.type	KernelPDE, @object
	.size	KernelPDE, 4
KernelPDE:
	.zero	4
	.globl	KernelPTEs
	.section	.KernelPTESect,"aw",@progbits
	.align 8192
	.type	KernelPTEs, @object
	.size	KernelPTEs, 2048
KernelPTEs:
	.zero	2048
	.comm	KernelTSS,104,64
	.globl	TasksN
	.bss
	.align 4
	.type	TasksN, @object
	.size	TasksN, 4
TasksN:
	.zero	4
	.comm	GDTC,2,2
	.comm	KernelSegmentInRM,2,2
	.comm	KernelBase,2,2
	.comm	ActTaskPrvLevel,1,1
	.globl	KernelState
	.type	KernelState, @object
	.size	KernelState, 1
KernelState:
	.zero	1
	.globl	OldCallStack
	.align 2
	.type	OldCallStack, @object
	.size	OldCallStack, 2
OldCallStack:
	.zero	2
	.globl	CallStack
	.align 2
	.type	CallStack, @object
	.size	CallStack, 2
CallStack:
	.zero	2
	.comm	ActTaskN,4,4
	.comm	ActTaskTickCount,4,4
	.comm	ActTaskMaxTick,4,4
	.comm	SystemClockEAX,4,4
	.comm	SystemClockESP,4,4
	.text
	.globl	outb
	.type	outb, @function
outb:
.LFB0:
	.file 1 "kernel.c"
	.loc 1 55 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	movl	8(%ebp), %edx
	movl	12(%ebp), %eax
	movw	%dx, -4(%ebp)
	movb	%al, -8(%ebp)
	.loc 1 56 0
	movzbl	-8(%ebp), %eax
	movzwl	-4(%ebp), %edx
#APP
# 56 "kernel.c" 1
	outb %al, %dx
# 0 "" 2
	.loc 1 57 0
#NO_APP
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	outb, .-outb
	.globl	inb
	.type	inb, @function
inb:
.LFB1:
	.loc 1 59 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$20, %esp
	movl	8(%ebp), %eax
	movw	%ax, -20(%ebp)
	.loc 1 61 0
	movzwl	-20(%ebp), %eax
	movl	%eax, %edx
#APP
# 61 "kernel.c" 1
	inb %dx, %al
# 0 "" 2
#NO_APP
	movb	%al, -1(%ebp)
	.loc 1 62 0
	movzbl	-1(%ebp), %eax
	.loc 1 63 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	inb, .-inb
	.globl	DelayLoop
	.type	DelayLoop, @function
DelayLoop:
.LFB2:
	.loc 1 67 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$20, %esp
	movl	8(%ebp), %eax
	movw	%ax, -20(%ebp)
	.loc 1 69 0
	movw	$0, -2(%ebp)
	jmp	.L5
.L6:
	.loc 1 69 0 is_stmt 0 discriminator 3
	movzwl	-2(%ebp), %eax
	addl	$1, %eax
	movw	%ax, -2(%ebp)
.L5:
	.loc 1 69 0 discriminator 1
	movzwl	-2(%ebp), %eax
	cmpw	-20(%ebp), %ax
	jne	.L6
	.loc 1 71 0 is_stmt 1
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	DelayLoop, .-DelayLoop
	.globl	EmptyInterrupt
	.type	EmptyInterrupt, @function
EmptyInterrupt:
.LFB3:
	.loc 1 77 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	.loc 1 78 0
#APP
# 78 "kernel.c" 1
	leave
iret

# 0 "" 2
	.loc 1 80 0
#NO_APP
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE3:
	.size	EmptyInterrupt, .-EmptyInterrupt
	.globl	EditGDTEntry
	.type	EditGDTEntry, @function
EditGDTEntry:
.LFB4:
	.loc 1 85 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$80, %esp
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	movl	8(%ebp), %edx
	movl	20(%ebp), %ebx
	movl	24(%ebp), %edi
	movl	28(%ebp), %eax
	movl	%eax, -76(%ebp)
	movl	32(%ebp), %esi
	movl	%esi, -80(%ebp)
	movl	36(%ebp), %ecx
	movl	%ecx, -84(%ebp)
	movl	40(%ebp), %eax
	movl	%eax, -88(%ebp)
	movl	44(%ebp), %esi
	movl	%esi, -92(%ebp)
	movl	48(%ebp), %esi
	movl	52(%ebp), %ecx
	movl	56(%ebp), %eax
	movb	%dl, -32(%ebp)
	movb	%bl, -36(%ebp)
	movl	%edi, %ebx
	movb	%bl, -40(%ebp)
	movzbl	-76(%ebp), %ebx
	movb	%bl, -44(%ebp)
	movzbl	-80(%ebp), %ebx
	movb	%bl, -48(%ebp)
	movzbl	-84(%ebp), %ebx
	movb	%bl, -52(%ebp)
	movzbl	-88(%ebp), %ebx
	movb	%bl, -56(%ebp)
	movzbl	-92(%ebp), %ebx
	movb	%bl, -60(%ebp)
	movl	%esi, %ebx
	movb	%bl, -64(%ebp)
	movb	%cl, -68(%ebp)
	movb	%al, -72(%ebp)
	.loc 1 90 0
	movl	12(%ebp), %eax
	movl	%eax, -16(%ebp)
	.loc 1 91 0
	movzbl	-32(%ebp), %eax
	movl	-16(%ebp), %edx
	movw	%dx, GDTS(,%eax,8)
	.loc 1 92 0
	movzbl	-32(%ebp), %eax
	movl	16(%ebp), %edx
	movw	%dx, GDTS+2(,%eax,8)
	.loc 1 93 0
	movl	16(%ebp), %eax
	movl	%eax, -16(%ebp)
	.loc 1 94 0
	andl	$16711680, -16(%ebp)
	.loc 1 95 0
	shrl	$16, -16(%ebp)
	.loc 1 96 0
	movzbl	-32(%ebp), %eax
	movl	-16(%ebp), %edx
	movb	%dl, GDTS+4(,%eax,8)
	.loc 1 97 0
	movzbl	-32(%ebp), %eax
	movzbl	-36(%ebp), %edx
	andl	$1, %edx
	movl	%edx, %ecx
	andl	$1, %ecx
	movzbl	GDTS+5(,%eax,8), %edx
	andl	$-2, %edx
	orl	%ecx, %edx
	movb	%dl, GDTS+5(,%eax,8)
	.loc 1 98 0
	movzbl	-32(%ebp), %eax
	movzbl	-40(%ebp), %edx
	andl	$1, %edx
	andl	$1, %edx
	leal	(%edx,%edx), %ecx
	movzbl	GDTS+5(,%eax,8), %edx
	andl	$-3, %edx
	orl	%ecx, %edx
	movb	%dl, GDTS+5(,%eax,8)
	.loc 1 99 0
	movzbl	-32(%ebp), %eax
	movzbl	-44(%ebp), %edx
	andl	$1, %edx
	andl	$1, %edx
	leal	0(,%edx,4), %ecx
	movzbl	GDTS+5(,%eax,8), %edx
	andl	$-5, %edx
	orl	%ecx, %edx
	movb	%dl, GDTS+5(,%eax,8)
	.loc 1 100 0
	movzbl	-32(%ebp), %eax
	movzbl	-48(%ebp), %edx
	andl	$1, %edx
	andl	$1, %edx
	leal	0(,%edx,8), %ecx
	movzbl	GDTS+5(,%eax,8), %edx
	andl	$-9, %edx
	orl	%ecx, %edx
	movb	%dl, GDTS+5(,%eax,8)
	.loc 1 101 0
	movzbl	-32(%ebp), %eax
	movzbl	-52(%ebp), %edx
	andl	$1, %edx
	andl	$1, %edx
	movl	%edx, %ecx
	sall	$4, %ecx
	movzbl	GDTS+5(,%eax,8), %edx
	andl	$-17, %edx
	orl	%ecx, %edx
	movb	%dl, GDTS+5(,%eax,8)
	.loc 1 102 0
	movzbl	-32(%ebp), %eax
	movzbl	-56(%ebp), %edx
	andl	$3, %edx
	andl	$3, %edx
	movl	%edx, %ecx
	sall	$5, %ecx
	movzbl	GDTS+5(,%eax,8), %edx
	andl	$-97, %edx
	orl	%ecx, %edx
	movb	%dl, GDTS+5(,%eax,8)
	.loc 1 103 0
	movzbl	-32(%ebp), %eax
	movzbl	-60(%ebp), %edx
	andl	$1, %edx
	movl	%edx, %ecx
	sall	$7, %ecx
	movzbl	GDTS+5(,%eax,8), %edx
	andl	$127, %edx
	orl	%ecx, %edx
	movb	%dl, GDTS+5(,%eax,8)
	.loc 1 104 0
	movl	12(%ebp), %eax
	movl	%eax, -16(%ebp)
	.loc 1 105 0
	andl	$983040, -16(%ebp)
	.loc 1 106 0
	shrl	$16, -16(%ebp)
	.loc 1 108 0
	movzbl	-32(%ebp), %eax
	movl	-16(%ebp), %edx
	andl	$15, %edx
	movl	%edx, %ecx
	andl	$15, %ecx
	movzbl	GDTS+6(,%eax,8), %edx
	andl	$-16, %edx
	orl	%ecx, %edx
	movb	%dl, GDTS+6(,%eax,8)
	.loc 1 109 0
	movzbl	-32(%ebp), %eax
	movzbl	-64(%ebp), %edx
	andl	$1, %edx
	andl	$1, %edx
	movl	%edx, %ecx
	sall	$4, %ecx
	movzbl	GDTS+6(,%eax,8), %edx
	andl	$-17, %edx
	orl	%ecx, %edx
	movb	%dl, GDTS+6(,%eax,8)
	.loc 1 110 0
	movzbl	-32(%ebp), %eax
	movzbl	GDTS+6(,%eax,8), %edx
	andl	$-33, %edx
	movb	%dl, GDTS+6(,%eax,8)
	.loc 1 111 0
	movzbl	-32(%ebp), %eax
	movzbl	-68(%ebp), %edx
	andl	$1, %edx
	andl	$1, %edx
	movl	%edx, %ecx
	sall	$6, %ecx
	movzbl	GDTS+6(,%eax,8), %edx
	andl	$-65, %edx
	orl	%ecx, %edx
	movb	%dl, GDTS+6(,%eax,8)
	.loc 1 112 0
	movzbl	-32(%ebp), %eax
	movzbl	-72(%ebp), %edx
	andl	$1, %edx
	movl	%edx, %ecx
	sall	$7, %ecx
	movzbl	GDTS+6(,%eax,8), %edx
	andl	$127, %edx
	orl	%ecx, %edx
	movb	%dl, GDTS+6(,%eax,8)
	.loc 1 114 0
	movl	16(%ebp), %eax
	movl	%eax, -16(%ebp)
	.loc 1 115 0
	andl	$-16777216, -16(%ebp)
	.loc 1 116 0
	shrl	$24, -16(%ebp)
	.loc 1 117 0
	movl	$0, %eax
	.loc 1 118 0
	addl	$80, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE4:
	.size	EditGDTEntry, .-EditGDTEntry
	.globl	BOCHSDBGputc
	.type	BOCHSDBGputc, @function
BOCHSDBGputc:
.LFB5:
	.loc 1 121 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$4, %esp
	movl	8(%ebp), %eax
	movb	%al, -4(%ebp)
	.loc 1 124 0
	movzbl	-4(%ebp), %eax
	pushl	%eax
	pushl	$233
	call	outb
	addl	$8, %esp
	.loc 1 133 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE5:
	.size	BOCHSDBGputc, .-BOCHSDBGputc
	.type	IntToStr.1208, @function
IntToStr.1208:
.LFB7:
	.loc 1 139 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	.loc 1 141 0
	movl	$1000000000, -8(%ebp)
	.loc 1 142 0
	movl	8(%ebp), %eax
	movl	%eax, -12(%ebp)
	.loc 1 143 0
	movb	$0, -13(%ebp)
	.loc 1 145 0
	movb	$0, -14(%ebp)
	.loc 1 146 0
	movb	$0, -1(%ebp)
	jmp	.L12
.L14:
	.loc 1 147 0
	movl	-12(%ebp), %eax
	movl	$0, %edx
	divl	-8(%ebp)
	movb	%al, -15(%ebp)
	.loc 1 148 0
	movl	-12(%ebp), %eax
	movl	$0, %edx
	divl	-8(%ebp)
	movl	%edx, -12(%ebp)
	.loc 1 149 0
	cmpb	$0, -15(%ebp)
	setne	%dl
	cmpb	$1, -14(%ebp)
	sete	%al
	orl	%edx, %eax
	testb	%al, %al
	je	.L13
	.loc 1 150 0
	movb	$1, -14(%ebp)
	.loc 1 151 0
	movzbl	-13(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movzbl	-15(%ebp), %edx
	addl	$48, %edx
	movb	%dl, (%eax)
	.loc 1 152 0
	movzbl	-13(%ebp), %eax
	addl	$1, %eax
	movb	%al, -13(%ebp)
.L13:
	.loc 1 154 0 discriminator 2
	movl	-8(%ebp), %eax
	movl	$-858993459, %edx
	mull	%edx
	movl	%edx, %eax
	shrl	$3, %eax
	movl	%eax, -8(%ebp)
	.loc 1 146 0 discriminator 2
	movzbl	-1(%ebp), %eax
	addl	$1, %eax
	movb	%al, -1(%ebp)
.L12:
	.loc 1 146 0 is_stmt 0 discriminator 1
	cmpb	$9, -1(%ebp)
	jbe	.L14
	.loc 1 156 0 is_stmt 1
	cmpb	$0, -14(%ebp)
	jne	.L15
	.loc 1 157 0
	movl	12(%ebp), %eax
	movb	$48, (%eax)
	.loc 1 158 0
	movl	$1, %eax
	jmp	.L16
.L15:
	.loc 1 159 0
	movzbl	-13(%ebp), %eax
.L16:
	.loc 1 160 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE7:
	.size	IntToStr.1208, .-IntToStr.1208
	.globl	BOCHSDBGprintf
	.type	BOCHSDBGprintf, @function
BOCHSDBGprintf:
.LFB6:
	.loc 1 135 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	.loc 1 213 0
	movb	$0, -13(%ebp)
	.loc 1 215 0
	leal	12(%ebp), %eax
	movl	%eax, -28(%ebp)
	.loc 1 216 0
	movw	$0, -10(%ebp)
	.loc 1 217 0
	movw	$0, -12(%ebp)
	.loc 1 218 0
	movb	$0, -14(%ebp)
	.loc 1 219 0
	movl	$0, -20(%ebp)
	.loc 1 221 0
	movw	$0, -10(%ebp)
	jmp	.L18
.L36:
	.loc 1 222 0
	movzwl	-10(%ebp), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	cmpl	$10, %eax
	je	.L20
	cmpl	$13, %eax
	je	.L21
	jmp	.L37
.L20:
.LBB2:
	.loc 1 224 0
	movzbl	CurY, %eax
	movzbl	%al, %eax
	addl	$1, %eax
	subl	$8, %esp
	pushl	%eax
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
	.loc 1 225 0
	jmp	.L22
.L21:
	.loc 1 227 0
	movzbl	CurY, %eax
	movzbl	%al, %eax
	subl	$8, %esp
	pushl	%eax
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
	.loc 1 228 0
	jmp	.L22
.L37:
	.loc 1 230 0
	movzwl	-10(%ebp), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	cmpb	$37, %al
	jne	.L23
	.loc 1 231 0
	movzwl	-10(%ebp), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	cmpl	$117, %eax
	je	.L25
	cmpl	$120, %eax
	je	.L26
	cmpl	$99, %eax
	je	.L27
	jmp	.L38
.L26:
	.loc 1 233 0
	movl	-28(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, -28(%ebp)
	movl	(%eax), %eax
	movl	%eax, -20(%ebp)
	.loc 1 234 0
	subl	$8, %esp
	leal	-39(%ebp), %eax
	pushl	%eax
	pushl	-20(%ebp)
	call	IntToHex.1221
	addl	$16, %esp
	movb	%al, -14(%ebp)
	.loc 1 236 0
	subl	$12, %esp
	pushl	$48
	call	BOCHSDBGputc
	addl	$16, %esp
	.loc 1 237 0
	subl	$12, %esp
	pushl	$120
	call	BOCHSDBGputc
	addl	$16, %esp
	.loc 1 238 0
	movw	$0, -12(%ebp)
	jmp	.L28
.L29:
	.loc 1 239 0 discriminator 3
	movzwl	-12(%ebp), %eax
	movzbl	-39(%ebp,%eax), %eax
	movzbl	%al, %eax
	subl	$12, %esp
	pushl	%eax
	call	BOCHSDBGputc
	addl	$16, %esp
	.loc 1 238 0 discriminator 3
	movzwl	-12(%ebp), %eax
	addl	$1, %eax
	movw	%ax, -12(%ebp)
.L28:
	.loc 1 238 0 is_stmt 0 discriminator 1
	movzbl	-14(%ebp), %eax
	cmpw	-12(%ebp), %ax
	ja	.L29
	.loc 1 241 0 is_stmt 1
	jmp	.L30
.L25:
	.loc 1 243 0
	movl	-28(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, -28(%ebp)
	movl	(%eax), %eax
	movl	%eax, -20(%ebp)
	.loc 1 244 0
	subl	$8, %esp
	leal	-39(%ebp), %eax
	pushl	%eax
	pushl	-20(%ebp)
	call	IntToStr.1208
	addl	$16, %esp
	movb	%al, -14(%ebp)
	.loc 1 246 0
	movw	$0, -12(%ebp)
	jmp	.L31
.L32:
	.loc 1 247 0 discriminator 3
	movzwl	-12(%ebp), %eax
	movzbl	-39(%ebp,%eax), %eax
	movzbl	%al, %eax
	subl	$12, %esp
	pushl	%eax
	call	BOCHSDBGputc
	addl	$16, %esp
	.loc 1 246 0 discriminator 3
	movzwl	-12(%ebp), %eax
	addl	$1, %eax
	movw	%ax, -12(%ebp)
.L31:
	.loc 1 246 0 is_stmt 0 discriminator 1
	movzbl	-14(%ebp), %eax
	cmpw	-12(%ebp), %ax
	ja	.L32
	.loc 1 249 0 is_stmt 1
	jmp	.L30
.L27:
	.loc 1 251 0
	movl	-28(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, -28(%ebp)
	movl	(%eax), %eax
	movl	%eax, -24(%ebp)
	.loc 1 252 0
	movw	$0, -12(%ebp)
	jmp	.L33
.L34:
	.loc 1 252 0 is_stmt 0 discriminator 3
	movzwl	-12(%ebp), %edx
	movl	-24(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	subl	$12, %esp
	pushl	%eax
	call	BOCHSDBGputc
	addl	$16, %esp
	movzwl	-12(%ebp), %eax
	addl	$1, %eax
	movw	%ax, -12(%ebp)
.L33:
	.loc 1 252 0 discriminator 1
	movzwl	-12(%ebp), %edx
	movl	-24(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L34
	.loc 1 253 0 is_stmt 1
	jmp	.L30
.L38:
	.loc 1 255 0
	subl	$12, %esp
	pushl	$37
	call	BOCHSDBGputc
	addl	$16, %esp
	.loc 1 256 0
	movzwl	-10(%ebp), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	subl	$12, %esp
	pushl	%eax
	call	BOCHSDBGputc
	addl	$16, %esp
	.loc 1 257 0
	nop
.L30:
	.loc 1 259 0
	movzwl	-10(%ebp), %eax
	addl	$1, %eax
	movw	%ax, -10(%ebp)
	.loc 1 264 0
	jmp	.L39
.L23:
	.loc 1 262 0
	movzwl	-10(%ebp), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	subl	$12, %esp
	pushl	%eax
	call	BOCHSDBGputc
	addl	$16, %esp
.L39:
	.loc 1 264 0
	nop
.L22:
.LBE2:
	.loc 1 221 0 discriminator 2
	movzwl	-10(%ebp), %eax
	addl	$1, %eax
	movw	%ax, -10(%ebp)
.L18:
	.loc 1 221 0 is_stmt 0 discriminator 1
	movzwl	-10(%ebp), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L36
	.loc 1 272 0 is_stmt 1
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE6:
	.size	BOCHSDBGprintf, .-BOCHSDBGprintf
	.type	IntToHex.1221, @function
IntToHex.1221:
.LFB8:
	.loc 1 163 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	.loc 1 165 0
	movl	$268435456, -8(%ebp)
	.loc 1 166 0
	movl	8(%ebp), %eax
	movl	%eax, -12(%ebp)
	.loc 1 167 0
	movb	$0, -13(%ebp)
	.loc 1 169 0
	movb	$0, -14(%ebp)
	.loc 1 170 0
	movb	$0, -1(%ebp)
	jmp	.L41
.L52:
	.loc 1 171 0
	movl	-12(%ebp), %eax
	movl	$0, %edx
	divl	-8(%ebp)
	movb	%al, -15(%ebp)
	.loc 1 172 0
	movl	-12(%ebp), %eax
	movl	$0, %edx
	divl	-8(%ebp)
	movl	%edx, -12(%ebp)
	.loc 1 173 0
	cmpb	$0, -15(%ebp)
	setne	%dl
	cmpb	$1, -14(%ebp)
	sete	%al
	orl	%edx, %eax
	testb	%al, %al
	je	.L42
	.loc 1 174 0
	movb	$1, -14(%ebp)
	.loc 1 175 0
	movzbl	-15(%ebp), %eax
	subl	$10, %eax
	cmpl	$5, %eax
	ja	.L43
	movl	.L45(,%eax,4), %eax
	jmp	*%eax
	.section	.rodata
	.align 4
	.align 4
.L45:
	.long	.L44
	.long	.L46
	.long	.L47
	.long	.L48
	.long	.L49
	.long	.L50
	.text
.L44:
	.loc 1 177 0
	movzbl	-13(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movb	$65, (%eax)
	.loc 1 178 0
	jmp	.L51
.L46:
	.loc 1 180 0
	movzbl	-13(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movb	$66, (%eax)
	.loc 1 181 0
	jmp	.L51
.L47:
	.loc 1 183 0
	movzbl	-13(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movb	$67, (%eax)
	.loc 1 184 0
	jmp	.L51
.L48:
	.loc 1 186 0
	movzbl	-13(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movb	$68, (%eax)
	.loc 1 187 0
	jmp	.L51
.L49:
	.loc 1 189 0
	movzbl	-13(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movb	$69, (%eax)
	.loc 1 190 0
	jmp	.L51
.L50:
	.loc 1 192 0
	movzbl	-13(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movb	$70, (%eax)
	.loc 1 193 0
	jmp	.L51
.L43:
	.loc 1 195 0
	movzbl	-13(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movzbl	-15(%ebp), %edx
	addl	$48, %edx
	movb	%dl, (%eax)
	.loc 1 196 0
	nop
.L51:
	.loc 1 198 0
	movzbl	-13(%ebp), %eax
	addl	$1, %eax
	movb	%al, -13(%ebp)
.L42:
	.loc 1 200 0 discriminator 2
	movl	-8(%ebp), %eax
	shrl	$4, %eax
	movl	%eax, -8(%ebp)
	.loc 1 170 0 discriminator 2
	movzbl	-1(%ebp), %eax
	addl	$1, %eax
	movb	%al, -1(%ebp)
.L41:
	.loc 1 170 0 is_stmt 0 discriminator 1
	cmpb	$7, -1(%ebp)
	jbe	.L52
	.loc 1 202 0 is_stmt 1
	cmpb	$0, -14(%ebp)
	jne	.L53
	.loc 1 203 0
	movl	12(%ebp), %eax
	movb	$48, (%eax)
	.loc 1 204 0
	movl	$1, %eax
	jmp	.L54
.L53:
	.loc 1 205 0
	movzbl	-13(%ebp), %eax
.L54:
	.loc 1 206 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE8:
	.size	IntToHex.1221, .-IntToHex.1221
	.comm	SystemClockSS,2,2
.Letext0:
	.file 2 "./include/data.h"
	.file 3 "/usr/lib/gcc/x86_64-linux-gnu/4.9/include/stdarg.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0xb91
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.long	.LASF104
	.byte	0x1
	.long	.LASF105
	.long	.LASF106
	.long	.Ltext0
	.long	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0x2
	.long	.LASF3
	.byte	0x2
	.byte	0x3a
	.long	0x30
	.uleb128 0x3
	.byte	0x2
	.byte	0x7
	.long	.LASF0
	.uleb128 0x3
	.byte	0x2
	.byte	0x5
	.long	.LASF1
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.long	.LASF2
	.uleb128 0x2
	.long	.LASF4
	.byte	0x2
	.byte	0x3d
	.long	0x50
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.long	.LASF5
	.uleb128 0x2
	.long	.LASF6
	.byte	0x2
	.byte	0x3e
	.long	0x62
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.long	.LASF7
	.uleb128 0x4
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x5
	.long	.LASF14
	.byte	0x8
	.byte	0x2
	.byte	0x47
	.long	0x153
	.uleb128 0x6
	.long	.LASF8
	.byte	0x2
	.byte	0x48
	.long	0x25
	.byte	0
	.uleb128 0x6
	.long	.LASF9
	.byte	0x2
	.byte	0x49
	.long	0x25
	.byte	0x2
	.uleb128 0x6
	.long	.LASF10
	.byte	0x2
	.byte	0x4a
	.long	0x45
	.byte	0x4
	.uleb128 0x7
	.string	"A"
	.byte	0x2
	.byte	0x4c
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x7
	.byte	0x4
	.uleb128 0x7
	.string	"RW"
	.byte	0x2
	.byte	0x4d
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x6
	.byte	0x4
	.uleb128 0x7
	.string	"CE"
	.byte	0x2
	.byte	0x4e
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x5
	.byte	0x4
	.uleb128 0x7
	.string	"T"
	.byte	0x2
	.byte	0x4f
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x4
	.byte	0x4
	.uleb128 0x7
	.string	"S"
	.byte	0x2
	.byte	0x50
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x3
	.byte	0x4
	.uleb128 0x7
	.string	"DPL"
	.byte	0x2
	.byte	0x51
	.long	0x25
	.byte	0x2
	.byte	0x2
	.byte	0x1
	.byte	0x4
	.uleb128 0x7
	.string	"P"
	.byte	0x2
	.byte	0x52
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0
	.byte	0x4
	.uleb128 0x8
	.long	.LASF11
	.byte	0x2
	.byte	0x54
	.long	0x25
	.byte	0x2
	.byte	0x4
	.byte	0xc
	.byte	0x6
	.uleb128 0x7
	.string	"AVL"
	.byte	0x2
	.byte	0x55
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xb
	.byte	0x6
	.uleb128 0x8
	.long	.LASF12
	.byte	0x2
	.byte	0x56
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xa
	.byte	0x6
	.uleb128 0x7
	.string	"D"
	.byte	0x2
	.byte	0x57
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x9
	.byte	0x6
	.uleb128 0x7
	.string	"G"
	.byte	0x2
	.byte	0x58
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x8
	.byte	0x6
	.uleb128 0x6
	.long	.LASF13
	.byte	0x2
	.byte	0x59
	.long	0x45
	.byte	0x7
	.byte	0
	.uleb128 0x5
	.long	.LASF15
	.byte	0x8
	.byte	0x2
	.byte	0x5c
	.long	0x1e4
	.uleb128 0x6
	.long	.LASF16
	.byte	0x2
	.byte	0x5d
	.long	0x25
	.byte	0
	.uleb128 0x6
	.long	.LASF17
	.byte	0x2
	.byte	0x5e
	.long	0x25
	.byte	0x2
	.uleb128 0x6
	.long	.LASF12
	.byte	0x2
	.byte	0x5f
	.long	0x45
	.byte	0x4
	.uleb128 0x7
	.string	"W"
	.byte	0x2
	.byte	0x60
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x7
	.byte	0x4
	.uleb128 0x7
	.string	"MB3"
	.byte	0x2
	.byte	0x61
	.long	0x25
	.byte	0x2
	.byte	0x2
	.byte	0x5
	.byte	0x4
	.uleb128 0x7
	.string	"D"
	.byte	0x2
	.byte	0x62
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x4
	.byte	0x4
	.uleb128 0x8
	.long	.LASF18
	.byte	0x2
	.byte	0x63
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x3
	.byte	0x4
	.uleb128 0x7
	.string	"DPL"
	.byte	0x2
	.byte	0x64
	.long	0x25
	.byte	0x2
	.byte	0x2
	.byte	0x1
	.byte	0x4
	.uleb128 0x7
	.string	"P"
	.byte	0x2
	.byte	0x65
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0
	.byte	0x4
	.uleb128 0x6
	.long	.LASF19
	.byte	0x2
	.byte	0x66
	.long	0x25
	.byte	0x6
	.byte	0
	.uleb128 0x5
	.long	.LASF20
	.byte	0x6
	.byte	0x2
	.byte	0x69
	.long	0x215
	.uleb128 0x6
	.long	.LASF21
	.byte	0x2
	.byte	0x6a
	.long	0x25
	.byte	0
	.uleb128 0x6
	.long	.LASF22
	.byte	0x2
	.byte	0x6b
	.long	0x25
	.byte	0x2
	.uleb128 0x6
	.long	.LASF23
	.byte	0x2
	.byte	0x6c
	.long	0x45
	.byte	0x4
	.byte	0
	.uleb128 0x5
	.long	.LASF24
	.byte	0x6
	.byte	0x2
	.byte	0x6f
	.long	0x246
	.uleb128 0x6
	.long	.LASF21
	.byte	0x2
	.byte	0x70
	.long	0x25
	.byte	0
	.uleb128 0x6
	.long	.LASF22
	.byte	0x2
	.byte	0x71
	.long	0x25
	.byte	0x2
	.uleb128 0x6
	.long	.LASF23
	.byte	0x2
	.byte	0x72
	.long	0x45
	.byte	0x4
	.byte	0
	.uleb128 0x5
	.long	.LASF25
	.byte	0x68
	.byte	0x2
	.byte	0x77
	.long	0x391
	.uleb128 0x6
	.long	.LASF26
	.byte	0x2
	.byte	0x7c
	.long	0x57
	.byte	0
	.uleb128 0x6
	.long	.LASF27
	.byte	0x2
	.byte	0x7d
	.long	0x57
	.byte	0x4
	.uleb128 0x9
	.string	"SS0"
	.byte	0x2
	.byte	0x7e
	.long	0x57
	.byte	0x8
	.uleb128 0x6
	.long	.LASF28
	.byte	0x2
	.byte	0x7f
	.long	0x57
	.byte	0xc
	.uleb128 0x9
	.string	"SS1"
	.byte	0x2
	.byte	0x80
	.long	0x57
	.byte	0x10
	.uleb128 0x6
	.long	.LASF29
	.byte	0x2
	.byte	0x81
	.long	0x57
	.byte	0x14
	.uleb128 0x9
	.string	"SS2"
	.byte	0x2
	.byte	0x82
	.long	0x57
	.byte	0x18
	.uleb128 0x9
	.string	"CR3"
	.byte	0x2
	.byte	0x83
	.long	0x57
	.byte	0x1c
	.uleb128 0x9
	.string	"ES"
	.byte	0x2
	.byte	0x84
	.long	0x57
	.byte	0x20
	.uleb128 0x9
	.string	"FS"
	.byte	0x2
	.byte	0x87
	.long	0x57
	.byte	0x24
	.uleb128 0x9
	.string	"EDI"
	.byte	0x2
	.byte	0x89
	.long	0x57
	.byte	0x28
	.uleb128 0x9
	.string	"ESI"
	.byte	0x2
	.byte	0x8a
	.long	0x57
	.byte	0x2c
	.uleb128 0x9
	.string	"EBP"
	.byte	0x2
	.byte	0x8b
	.long	0x57
	.byte	0x30
	.uleb128 0x9
	.string	"DS"
	.byte	0x2
	.byte	0x8d
	.long	0x57
	.byte	0x34
	.uleb128 0x9
	.string	"EBX"
	.byte	0x2
	.byte	0x8e
	.long	0x57
	.byte	0x38
	.uleb128 0x9
	.string	"EDX"
	.byte	0x2
	.byte	0x8f
	.long	0x57
	.byte	0x3c
	.uleb128 0x9
	.string	"ECX"
	.byte	0x2
	.byte	0x90
	.long	0x57
	.byte	0x40
	.uleb128 0x9
	.string	"EAX"
	.byte	0x2
	.byte	0x91
	.long	0x57
	.byte	0x44
	.uleb128 0x9
	.string	"EIP"
	.byte	0x2
	.byte	0x93
	.long	0x57
	.byte	0x48
	.uleb128 0x9
	.string	"CS"
	.byte	0x2
	.byte	0x94
	.long	0x57
	.byte	0x4c
	.uleb128 0x6
	.long	.LASF30
	.byte	0x2
	.byte	0x95
	.long	0x57
	.byte	0x50
	.uleb128 0x9
	.string	"ESP"
	.byte	0x2
	.byte	0x96
	.long	0x57
	.byte	0x54
	.uleb128 0x9
	.string	"SS"
	.byte	0x2
	.byte	0x97
	.long	0x57
	.byte	0x58
	.uleb128 0x9
	.string	"GS"
	.byte	0x2
	.byte	0x98
	.long	0x57
	.byte	0x5c
	.uleb128 0x9
	.string	"LDT"
	.byte	0x2
	.byte	0x99
	.long	0x57
	.byte	0x60
	.uleb128 0x6
	.long	.LASF31
	.byte	0x2
	.byte	0x9a
	.long	0x25
	.byte	0x64
	.uleb128 0x6
	.long	.LASF32
	.byte	0x2
	.byte	0x9b
	.long	0x25
	.byte	0x66
	.byte	0
	.uleb128 0x5
	.long	.LASF33
	.byte	0x4
	.byte	0x2
	.byte	0xc0
	.long	0x43b
	.uleb128 0x7
	.string	"P"
	.byte	0x2
	.byte	0xc1
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xf
	.byte	0
	.uleb128 0x7
	.string	"RW"
	.byte	0x2
	.byte	0xc2
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xe
	.byte	0
	.uleb128 0x7
	.string	"US"
	.byte	0x2
	.byte	0xc3
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xd
	.byte	0
	.uleb128 0x7
	.string	"PWT"
	.byte	0x2
	.byte	0xc4
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xc
	.byte	0
	.uleb128 0x7
	.string	"PCD"
	.byte	0x2
	.byte	0xc5
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xb
	.byte	0
	.uleb128 0x7
	.string	"A"
	.byte	0x2
	.byte	0xc6
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xa
	.byte	0
	.uleb128 0x8
	.long	.LASF12
	.byte	0x2
	.byte	0xc7
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x9
	.byte	0
	.uleb128 0x8
	.long	.LASF34
	.byte	0x2
	.byte	0xc8
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x8
	.byte	0
	.uleb128 0x7
	.string	"G"
	.byte	0x2
	.byte	0xc9
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x7
	.byte	0
	.uleb128 0x7
	.string	"AVL"
	.byte	0x2
	.byte	0xca
	.long	0x25
	.byte	0x2
	.byte	0x3
	.byte	0x4
	.byte	0
	.uleb128 0x8
	.long	.LASF35
	.byte	0x2
	.byte	0xcb
	.long	0x57
	.byte	0x4
	.byte	0x14
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x5
	.long	.LASF36
	.byte	0x4
	.byte	0x2
	.byte	0xce
	.long	0x4e3
	.uleb128 0x7
	.string	"P"
	.byte	0x2
	.byte	0xcf
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xf
	.byte	0
	.uleb128 0x7
	.string	"RW"
	.byte	0x2
	.byte	0xd0
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xe
	.byte	0
	.uleb128 0x7
	.string	"US"
	.byte	0x2
	.byte	0xd1
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xd
	.byte	0
	.uleb128 0x7
	.string	"PWT"
	.byte	0x2
	.byte	0xd2
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xc
	.byte	0
	.uleb128 0x7
	.string	"PCD"
	.byte	0x2
	.byte	0xd3
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xb
	.byte	0
	.uleb128 0x7
	.string	"A"
	.byte	0x2
	.byte	0xd4
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xa
	.byte	0
	.uleb128 0x7
	.string	"D"
	.byte	0x2
	.byte	0xd5
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x9
	.byte	0
	.uleb128 0x8
	.long	.LASF12
	.byte	0x2
	.byte	0xd6
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x8
	.byte	0
	.uleb128 0x7
	.string	"G"
	.byte	0x2
	.byte	0xd7
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x7
	.byte	0
	.uleb128 0x7
	.string	"AVL"
	.byte	0x2
	.byte	0xd8
	.long	0x25
	.byte	0x2
	.byte	0x3
	.byte	0x4
	.byte	0
	.uleb128 0x8
	.long	.LASF35
	.byte	0x2
	.byte	0xd9
	.long	0x57
	.byte	0x4
	.byte	0x14
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x5
	.long	.LASF37
	.byte	0x98
	.byte	0x2
	.byte	0xdb
	.long	0x5c8
	.uleb128 0x9
	.string	"PID"
	.byte	0x2
	.byte	0xdc
	.long	0x57
	.byte	0
	.uleb128 0x6
	.long	.LASF38
	.byte	0x2
	.byte	0xdd
	.long	0x57
	.byte	0x4
	.uleb128 0x6
	.long	.LASF39
	.byte	0x2
	.byte	0xde
	.long	0x25
	.byte	0x8
	.uleb128 0x6
	.long	.LASF40
	.byte	0x2
	.byte	0xdf
	.long	0x25
	.byte	0xa
	.uleb128 0x6
	.long	.LASF41
	.byte	0x2
	.byte	0xe0
	.long	0x25
	.byte	0xc
	.uleb128 0x6
	.long	.LASF42
	.byte	0x2
	.byte	0xe1
	.long	0x45
	.byte	0xe
	.uleb128 0x6
	.long	.LASF43
	.byte	0x2
	.byte	0xe2
	.long	0x45
	.byte	0xf
	.uleb128 0x6
	.long	.LASF44
	.byte	0x2
	.byte	0xe3
	.long	0x45
	.byte	0x10
	.uleb128 0x6
	.long	.LASF45
	.byte	0x2
	.byte	0xe4
	.long	0x45
	.byte	0x11
	.uleb128 0x9
	.string	"TSS"
	.byte	0x2
	.byte	0xe6
	.long	0x246
	.byte	0x14
	.uleb128 0x6
	.long	.LASF46
	.byte	0x2
	.byte	0xe8
	.long	0x5c8
	.byte	0x7c
	.uleb128 0x6
	.long	.LASF47
	.byte	0x2
	.byte	0xe9
	.long	0x391
	.byte	0x80
	.uleb128 0x6
	.long	.LASF48
	.byte	0x2
	.byte	0xea
	.long	0x43b
	.byte	0x84
	.uleb128 0x6
	.long	.LASF49
	.byte	0x2
	.byte	0xeb
	.long	0x57
	.byte	0x88
	.uleb128 0x6
	.long	.LASF50
	.byte	0x2
	.byte	0xec
	.long	0x57
	.byte	0x8c
	.uleb128 0x6
	.long	.LASF51
	.byte	0x2
	.byte	0xed
	.long	0x25
	.byte	0x90
	.uleb128 0x6
	.long	.LASF52
	.byte	0x2
	.byte	0xee
	.long	0x25
	.byte	0x92
	.uleb128 0x6
	.long	.LASF53
	.byte	0x2
	.byte	0xef
	.long	0x57
	.byte	0x94
	.byte	0
	.uleb128 0xa
	.byte	0x4
	.long	0x246
	.uleb128 0x2
	.long	.LASF54
	.byte	0x3
	.byte	0x28
	.long	0x5d9
	.uleb128 0xb
	.byte	0x4
	.long	.LASF107
	.long	0x5e3
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.long	.LASF55
	.uleb128 0x2
	.long	.LASF56
	.byte	0x3
	.byte	0x62
	.long	0x5ce
	.uleb128 0xc
	.long	.LASF59
	.byte	0x1
	.byte	0x37
	.long	.LFB0
	.long	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.long	0x627
	.uleb128 0xd
	.long	.LASF57
	.byte	0x1
	.byte	0x37
	.long	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.uleb128 0xd
	.long	.LASF58
	.byte	0x1
	.byte	0x37
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.byte	0
	.uleb128 0xe
	.string	"inb"
	.byte	0x1
	.byte	0x3b
	.long	0x45
	.long	.LFB1
	.long	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.long	0x65d
	.uleb128 0xd
	.long	.LASF57
	.byte	0x1
	.byte	0x3b
	.long	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0xf
	.string	"ret"
	.byte	0x1
	.byte	0x3c
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -9
	.byte	0
	.uleb128 0xc
	.long	.LASF60
	.byte	0x1
	.byte	0x43
	.long	.LFB2
	.long	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.long	0x68d
	.uleb128 0x10
	.string	"x"
	.byte	0x1
	.byte	0x43
	.long	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x11
	.long	.LASF61
	.byte	0x1
	.byte	0x44
	.long	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -10
	.byte	0
	.uleb128 0x12
	.long	.LASF108
	.byte	0x1
	.byte	0x4d
	.long	.LFB3
	.long	.LFE3-.LFB3
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x13
	.long	.LASF62
	.byte	0x1
	.byte	0x55
	.long	0x45
	.long	.LFB4
	.long	.LFE4-.LFB4
	.uleb128 0x1
	.byte	0x9c
	.long	0x772
	.uleb128 0xd
	.long	.LASF63
	.byte	0x1
	.byte	0x55
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0xd
	.long	.LASF21
	.byte	0x1
	.byte	0x55
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0xd
	.long	.LASF35
	.byte	0x1
	.byte	0x55
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.uleb128 0x10
	.string	"A"
	.byte	0x1
	.byte	0x55
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -44
	.uleb128 0x10
	.string	"RW"
	.byte	0x1
	.byte	0x55
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x10
	.string	"CE"
	.byte	0x1
	.byte	0x55
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -52
	.uleb128 0x10
	.string	"T"
	.byte	0x1
	.byte	0x55
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x10
	.string	"S"
	.byte	0x1
	.byte	0x55
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -60
	.uleb128 0x10
	.string	"DPL"
	.byte	0x1
	.byte	0x55
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x10
	.string	"P"
	.byte	0x1
	.byte	0x55
	.long	0x45
	.uleb128 0x3
	.byte	0x91
	.sleb128 -68
	.uleb128 0x10
	.string	"AVL"
	.byte	0x1
	.byte	0x55
	.long	0x45
	.uleb128 0x3
	.byte	0x91
	.sleb128 -72
	.uleb128 0x10
	.string	"D"
	.byte	0x1
	.byte	0x55
	.long	0x45
	.uleb128 0x3
	.byte	0x91
	.sleb128 -76
	.uleb128 0x10
	.string	"G"
	.byte	0x1
	.byte	0x55
	.long	0x45
	.uleb128 0x3
	.byte	0x91
	.sleb128 -80
	.uleb128 0x11
	.long	.LASF61
	.byte	0x1
	.byte	0x56
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0x14
	.long	.LASF64
	.byte	0x1
	.byte	0x79
	.long	.LFB5
	.long	.LFE5-.LFB5
	.uleb128 0x1
	.byte	0x9c
	.long	0x794
	.uleb128 0x10
	.string	"c"
	.byte	0x1
	.byte	0x79
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0xa
	.byte	0x4
	.long	0x45
	.uleb128 0x14
	.long	.LASF65
	.byte	0x1
	.byte	0x87
	.long	.LFB6
	.long	.LFE6-.LFB6
	.uleb128 0x1
	.byte	0x9c
	.long	0x952
	.uleb128 0xd
	.long	.LASF66
	.byte	0x1
	.byte	0x87
	.long	0x794
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x15
	.uleb128 0x16
	.long	.LASF69
	.byte	0x1
	.byte	0x8b
	.long	0x45
	.long	.LFB7
	.long	.LFE7-.LFB7
	.uleb128 0x1
	.byte	0x9c
	.long	0x844
	.uleb128 0xd
	.long	.LASF58
	.byte	0x1
	.byte	0x8b
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x10
	.string	"str"
	.byte	0x1
	.byte	0x8b
	.long	0x794
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x11
	.long	.LASF61
	.byte	0x1
	.byte	0x8c
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -9
	.uleb128 0x11
	.long	.LASF67
	.byte	0x1
	.byte	0x8d
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.uleb128 0x11
	.long	.LASF68
	.byte	0x1
	.byte	0x8e
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xf
	.string	"len"
	.byte	0x1
	.byte	0x8f
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -21
	.uleb128 0xf
	.string	"c"
	.byte	0x1
	.byte	0x90
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -23
	.uleb128 0xf
	.string	"z"
	.byte	0x1
	.byte	0x91
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -22
	.byte	0
	.uleb128 0x16
	.long	.LASF70
	.byte	0x1
	.byte	0xa3
	.long	0x45
	.long	.LFB8
	.long	.LFE8-.LFB8
	.uleb128 0x1
	.byte	0x9c
	.long	0x8ca
	.uleb128 0xd
	.long	.LASF58
	.byte	0x1
	.byte	0xa3
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x10
	.string	"Hex"
	.byte	0x1
	.byte	0xa3
	.long	0x794
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x11
	.long	.LASF61
	.byte	0x1
	.byte	0xa4
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -9
	.uleb128 0x11
	.long	.LASF67
	.byte	0x1
	.byte	0xa5
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.uleb128 0x11
	.long	.LASF68
	.byte	0x1
	.byte	0xa6
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xf
	.string	"len"
	.byte	0x1
	.byte	0xa7
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -21
	.uleb128 0xf
	.string	"c"
	.byte	0x1
	.byte	0xa8
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -23
	.uleb128 0xf
	.string	"z"
	.byte	0x1
	.byte	0xa9
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -22
	.byte	0
	.uleb128 0x11
	.long	.LASF71
	.byte	0x1
	.byte	0xd0
	.long	0x5ea
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0x11
	.long	.LASF61
	.byte	0x1
	.byte	0xd1
	.long	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -18
	.uleb128 0x11
	.long	.LASF67
	.byte	0x1
	.byte	0xd1
	.long	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x11
	.long	.LASF72
	.byte	0x1
	.byte	0xd2
	.long	0x952
	.uleb128 0x2
	.byte	0x91
	.sleb128 -47
	.uleb128 0x11
	.long	.LASF73
	.byte	0x1
	.byte	0xd3
	.long	0x794
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x11
	.long	.LASF74
	.byte	0x1
	.byte	0xd4
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -22
	.uleb128 0x11
	.long	.LASF75
	.byte	0x1
	.byte	0xd5
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -21
	.uleb128 0x11
	.long	.LASF76
	.byte	0x1
	.byte	0xd6
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x17
	.long	.LBB2
	.long	.LBE2-.LBB2
	.uleb128 0x18
	.long	.LASF109
	.byte	0x1
	.byte	0xe0
	.long	0x69
	.uleb128 0x15
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x19
	.long	0x45
	.long	0x962
	.uleb128 0x1a
	.long	0x962
	.byte	0xa
	.byte	0
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.long	.LASF77
	.uleb128 0x1b
	.string	"PTE"
	.byte	0x2
	.byte	0xda
	.long	0x43b
	.uleb128 0x5
	.byte	0x3
	.long	PTE
	.uleb128 0x19
	.long	0x70
	.long	0x98a
	.uleb128 0x1a
	.long	0x962
	.byte	0xff
	.byte	0
	.uleb128 0x1c
	.long	.LASF78
	.byte	0x1
	.byte	0xf
	.long	0x97a
	.uleb128 0x5
	.byte	0x3
	.long	GDTS
	.uleb128 0x19
	.long	0x153
	.long	0x9ab
	.uleb128 0x1a
	.long	0x962
	.byte	0xff
	.byte	0
	.uleb128 0x1c
	.long	.LASF79
	.byte	0x1
	.byte	0x10
	.long	0x99b
	.uleb128 0x5
	.byte	0x3
	.long	IDTS
	.uleb128 0x1c
	.long	.LASF80
	.byte	0x1
	.byte	0x11
	.long	0x1e4
	.uleb128 0x5
	.byte	0x3
	.long	GDTDescr
	.uleb128 0x1c
	.long	.LASF81
	.byte	0x1
	.byte	0x12
	.long	0x215
	.uleb128 0x5
	.byte	0x3
	.long	IDTDescr
	.uleb128 0x1c
	.long	.LASF82
	.byte	0x1
	.byte	0x15
	.long	0x5c8
	.uleb128 0x5
	.byte	0x3
	.long	ActTaskTSS
	.uleb128 0x1c
	.long	.LASF83
	.byte	0x1
	.byte	0x1d
	.long	0xa00
	.uleb128 0x5
	.byte	0x3
	.long	KernelTSS
	.uleb128 0x1d
	.long	0x246
	.uleb128 0x1c
	.long	.LASF84
	.byte	0x1
	.byte	0x1b
	.long	0xa16
	.uleb128 0x5
	.byte	0x3
	.long	KernelPDE
	.uleb128 0x1d
	.long	0x391
	.uleb128 0x19
	.long	0x43b
	.long	0xa2c
	.uleb128 0x1e
	.long	0x962
	.value	0x1ff
	.byte	0
	.uleb128 0x1c
	.long	.LASF85
	.byte	0x1
	.byte	0x1c
	.long	0xa3d
	.uleb128 0x5
	.byte	0x3
	.long	KernelPTEs
	.uleb128 0x1d
	.long	0xa1b
	.uleb128 0x1c
	.long	.LASF86
	.byte	0x1
	.byte	0x21
	.long	0x25
	.uleb128 0x5
	.byte	0x3
	.long	GDTC
	.uleb128 0x19
	.long	0x4e3
	.long	0xa63
	.uleb128 0x1a
	.long	0x962
	.byte	0x9
	.byte	0
	.uleb128 0x1c
	.long	.LASF87
	.byte	0x1
	.byte	0x14
	.long	0xa53
	.uleb128 0x5
	.byte	0x3
	.long	Tasks
	.uleb128 0x1c
	.long	.LASF88
	.byte	0x1
	.byte	0x22
	.long	0xa85
	.uleb128 0x5
	.byte	0x3
	.long	KernelSegmentInRM
	.uleb128 0x1d
	.long	0x25
	.uleb128 0x1c
	.long	.LASF89
	.byte	0x1
	.byte	0x23
	.long	0xa85
	.uleb128 0x5
	.byte	0x3
	.long	KernelBase
	.uleb128 0x1c
	.long	.LASF90
	.byte	0x1
	.byte	0x28
	.long	0x45
	.uleb128 0x5
	.byte	0x3
	.long	KernelState
	.uleb128 0x1c
	.long	.LASF91
	.byte	0x1
	.byte	0x29
	.long	0x25
	.uleb128 0x5
	.byte	0x3
	.long	OldCallStack
	.uleb128 0x1c
	.long	.LASF92
	.byte	0x1
	.byte	0x2a
	.long	0x25
	.uleb128 0x5
	.byte	0x3
	.long	CallStack
	.uleb128 0x1c
	.long	.LASF93
	.byte	0x1
	.byte	0x20
	.long	0xadf
	.uleb128 0x5
	.byte	0x3
	.long	TasksN
	.uleb128 0x1d
	.long	0x57
	.uleb128 0x1c
	.long	.LASF94
	.byte	0x1
	.byte	0x2c
	.long	0xadf
	.uleb128 0x5
	.byte	0x3
	.long	ActTaskN
	.uleb128 0x1c
	.long	.LASF95
	.byte	0x1
	.byte	0x25
	.long	0xb06
	.uleb128 0x5
	.byte	0x3
	.long	ActTaskPrvLevel
	.uleb128 0x1d
	.long	0x45
	.uleb128 0x1c
	.long	.LASF96
	.byte	0x1
	.byte	0x2f
	.long	0xadf
	.uleb128 0x5
	.byte	0x3
	.long	ActTaskTickCount
	.uleb128 0x1c
	.long	.LASF97
	.byte	0x1
	.byte	0x30
	.long	0xadf
	.uleb128 0x5
	.byte	0x3
	.long	ActTaskMaxTick
	.uleb128 0x1f
	.long	.LASF98
	.byte	0x2
	.value	0x126
	.long	0x45
	.uleb128 0x1c
	.long	.LASF99
	.byte	0x1
	.byte	0x33
	.long	0xadf
	.uleb128 0x5
	.byte	0x3
	.long	SystemClockEAX
	.uleb128 0x1c
	.long	.LASF100
	.byte	0x1
	.byte	0x35
	.long	0xadf
	.uleb128 0x5
	.byte	0x3
	.long	SystemClockESP
	.uleb128 0x1c
	.long	.LASF101
	.byte	0x1
	.byte	0x17
	.long	0xa16
	.uleb128 0x5
	.byte	0x3
	.long	KernelPDEA
	.uleb128 0x1c
	.long	.LASF102
	.byte	0x1
	.byte	0x18
	.long	0xb7d
	.uleb128 0x5
	.byte	0x3
	.long	KernelPTEA
	.uleb128 0x1d
	.long	0x43b
	.uleb128 0x20
	.long	.LASF103
	.byte	0x1
	.value	0x113
	.long	0xa85
	.uleb128 0x5
	.byte	0x3
	.long	SystemClockSS
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0xd
	.uleb128 0xb
	.uleb128 0xc
	.uleb128 0xb
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0xd
	.uleb128 0xb
	.uleb128 0xc
	.uleb128 0xb
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x19
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1a
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x1b
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x1c
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x1d
	.uleb128 0x35
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1e
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0x5
	.byte	0
	.byte	0
	.uleb128 0x1f
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x20
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.long	0x1c
	.value	0x2
	.long	.Ldebug_info0
	.byte	0x4
	.byte	0
	.value	0
	.value	0
	.long	.Ltext0
	.long	.Letext0-.Ltext0
	.long	0
	.long	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF17:
	.string	"Selector"
.LASF63:
	.string	"Index"
.LASF39:
	.string	"CodeSegment"
.LASF6:
	.string	"u32int"
.LASF90:
	.string	"KernelState"
.LASF60:
	.string	"DelayLoop"
.LASF62:
	.string	"EditGDTEntry"
.LASF1:
	.string	"short int"
.LASF74:
	.string	"strlen"
.LASF91:
	.string	"OldCallStack"
.LASF96:
	.string	"ActTaskTickCount"
.LASF68:
	.string	"value2"
.LASF89:
	.string	"KernelBase"
.LASF46:
	.string	"TSSNext"
.LASF15:
	.string	"_IDTS"
.LASF108:
	.string	"EmptyInterrupt"
.LASF25:
	.string	"TSSSeg"
.LASF69:
	.string	"IntToStr"
.LASF9:
	.string	"Base1"
.LASF10:
	.string	"Base2"
.LASF13:
	.string	"Base3"
.LASF84:
	.string	"KernelPDE"
.LASF58:
	.string	"value"
.LASF101:
	.string	"KernelPDEA"
.LASF56:
	.string	"va_list"
.LASF67:
	.string	"temp2"
.LASF59:
	.string	"outb"
.LASF66:
	.string	"text"
.LASF107:
	.string	"__builtin_va_list"
.LASF45:
	.string	"PrvLevel"
.LASF26:
	.string	"Back"
.LASF21:
	.string	"Size"
.LASF92:
	.string	"CallStack"
.LASF61:
	.string	"temp"
.LASF102:
	.string	"KernelPTEA"
.LASF20:
	.string	"_GDTDescr"
.LASF30:
	.string	"EFLAGS"
.LASF42:
	.string	"State"
.LASF55:
	.string	"char"
.LASF73:
	.string	"ArgStrP"
.LASF3:
	.string	"u16int"
.LASF105:
	.string	"kernel.c"
.LASF47:
	.string	"PDEDefault"
.LASF40:
	.string	"DataSegment"
.LASF8:
	.string	"Size1"
.LASF11:
	.string	"Size2"
.LASF18:
	.string	"Zero2"
.LASF12:
	.string	"Zero"
.LASF33:
	.string	"_PDE"
.LASF48:
	.string	"PTEDefault"
.LASF43:
	.string	"TickCount"
.LASF79:
	.string	"IDTS"
.LASF50:
	.string	"PDBR"
.LASF53:
	.string	"MemSize"
.LASF5:
	.string	"unsigned char"
.LASF27:
	.string	"ESP0"
.LASF28:
	.string	"ESP1"
.LASF29:
	.string	"ESP2"
.LASF81:
	.string	"IDTDescr"
.LASF95:
	.string	"ActTaskPrvLevel"
.LASF2:
	.string	"signed char"
.LASF24:
	.string	"_IDTDescr"
.LASF4:
	.string	"uchar"
.LASF36:
	.string	"_PTE"
.LASF41:
	.string	"StackSegment"
.LASF93:
	.string	"TasksN"
.LASF87:
	.string	"Tasks"
.LASF0:
	.string	"short unsigned int"
.LASF31:
	.string	"TRAP"
.LASF70:
	.string	"IntToHex"
.LASF14:
	.string	"_GDTS"
.LASF35:
	.string	"Base"
.LASF109:
	.string	"SetCurPos"
.LASF104:
	.string	"GNU C 4.9.2 -m32 -mtune=generic -march=i586 -g -O0 -fno-builtin"
.LASF65:
	.string	"BOCHSDBGprintf"
.LASF16:
	.string	"Offset1"
.LASF19:
	.string	"Offset2"
.LASF85:
	.string	"KernelPTEs"
.LASF86:
	.string	"GDTC"
.LASF57:
	.string	"port"
.LASF51:
	.string	"PDEsN"
.LASF106:
	.string	"/home/wojtek/programowanie/system/i386"
.LASF100:
	.string	"SystemClockESP"
.LASF38:
	.string	"EntryPoint"
.LASF83:
	.string	"KernelTSS"
.LASF44:
	.string	"MaxTick"
.LASF64:
	.string	"BOCHSDBGputc"
.LASF82:
	.string	"ActTaskTSS"
.LASF88:
	.string	"KernelSegmentInRM"
.LASF72:
	.string	"ArgStr"
.LASF34:
	.string	"PageSize"
.LASF75:
	.string	"paramscount"
.LASF98:
	.string	"CurY"
.LASF77:
	.string	"sizetype"
.LASF54:
	.string	"__gnuc_va_list"
.LASF32:
	.string	"IOMAP"
.LASF52:
	.string	"PTEsN"
.LASF23:
	.string	"AddrH"
.LASF97:
	.string	"ActTaskMaxTick"
.LASF76:
	.string	"ArgInt"
.LASF22:
	.string	"AddrL"
.LASF71:
	.string	"parg"
.LASF7:
	.string	"unsigned int"
.LASF94:
	.string	"ActTaskN"
.LASF78:
	.string	"GDTS"
.LASF49:
	.string	"Next"
.LASF37:
	.string	"_Tasks"
.LASF80:
	.string	"GDTDescr"
.LASF103:
	.string	"SystemClockSS"
.LASF99:
	.string	"SystemClockEAX"
	.ident	"GCC: (Debian 4.9.2-10) 4.9.2"
	.section	.note.GNU-stack,"",@progbits
