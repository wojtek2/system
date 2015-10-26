	.file	"protect.c"
#APP
	.code16gcc
#NO_APP
	.text
	.globl	Log2Phy
	.type	Log2Phy, @function
Log2Phy:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	8(%ebp), %edx
	movl	12(%ebp), %eax
	movw	%dx, -20(%ebp)
	movw	%ax, -24(%ebp)
	movzwl	-20(%ebp), %eax
	movw	%ax, -2(%ebp)
	shrw	$12, -2(%ebp)
	movl	16(%ebp), %eax
	movzwl	-2(%ebp), %edx
	movw	%dx, (%eax)
	movzwl	-20(%ebp), %eax
	movw	%ax, -2(%ebp)
	salw	$4, -2(%ebp)
	movzwl	-24(%ebp), %eax
	movzwl	-2(%ebp), %edx
	addl	%eax, %edx
	movl	20(%ebp), %eax
	movw	%dx, (%eax)
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	Log2Phy, .-Log2Phy
	.globl	CreateGDTIDT
	.type	CreateGDTIDT, @function
CreateGDTIDT:
.LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movw	$2039, GDTDescr
	movzwl	KernelSegment, %eax
	movzwl	%ax, %eax
	movl	$GDTDescr+2, 12(%esp)
	movl	$GDTDescr+4, 8(%esp)
	movl	$GDTS, 4(%esp)
	movl	%eax, (%esp)
	call	Log2Phy
	movw	$0, GDTS
	movw	$0, GDTS+2
	movb	$0, GDTS+4
	movzbl	GDTS+5, %eax
	andl	$-2, %eax
	movb	%al, GDTS+5
	movzbl	GDTS+5, %eax
	andl	$-3, %eax
	movb	%al, GDTS+5
	movzbl	GDTS+5, %eax
	andl	$-5, %eax
	movb	%al, GDTS+5
	movzbl	GDTS+5, %eax
	andl	$-9, %eax
	movb	%al, GDTS+5
	movzbl	GDTS+5, %eax
	andl	$-17, %eax
	movb	%al, GDTS+5
	movzbl	GDTS+5, %eax
	andl	$-97, %eax
	movb	%al, GDTS+5
	movzbl	GDTS+5, %eax
	andl	$127, %eax
	movb	%al, GDTS+5
	movzbl	GDTS+6, %eax
	andl	$-16, %eax
	movb	%al, GDTS+6
	movzbl	GDTS+6, %eax
	andl	$-17, %eax
	movb	%al, GDTS+6
	movzbl	GDTS+6, %eax
	andl	$-33, %eax
	movb	%al, GDTS+6
	movzbl	GDTS+6, %eax
	andl	$-65, %eax
	movb	%al, GDTS+6
	movzbl	GDTS+6, %eax
	andl	$127, %eax
	movb	%al, GDTS+6
	movb	$0, GDTS+7
	movw	$-1, GDTS+8
	movzwl	KernelSegment, %eax
	sall	$4, %eax
	movw	%ax, GDTS+10
	movb	$0, GDTS+12
	movzbl	GDTS+13, %eax
	andl	$-2, %eax
	movb	%al, GDTS+13
	movzbl	GDTS+13, %eax
	orl	$2, %eax
	movb	%al, GDTS+13
	movzbl	GDTS+13, %eax
	andl	$-5, %eax
	movb	%al, GDTS+13
	movzbl	GDTS+13, %eax
	orl	$8, %eax
	movb	%al, GDTS+13
	movzbl	GDTS+13, %eax
	orl	$16, %eax
	movb	%al, GDTS+13
	movzbl	GDTS+13, %eax
	andl	$-97, %eax
	movb	%al, GDTS+13
	movb	$0, GDTS+12
	movzbl	GDTS+13, %eax
	orl	$-128, %eax
	movb	%al, GDTS+13
	movzbl	GDTS+14, %eax
	orl	$15, %eax
	movb	%al, GDTS+14
	movzbl	GDTS+14, %eax
	andl	$-17, %eax
	movb	%al, GDTS+14
	movzbl	GDTS+14, %eax
	andl	$-33, %eax
	movb	%al, GDTS+14
	movzbl	GDTS+14, %eax
	orl	$64, %eax
	movb	%al, GDTS+14
	movzbl	GDTS+14, %eax
	andl	$127, %eax
	movb	%al, GDTS+14
	movb	$0, GDTS+15
	movw	$-1, GDTS+16
	movzwl	KernelSegment, %eax
	sall	$4, %eax
	movw	%ax, GDTS+18
	movb	$0, GDTS+20
	movzbl	GDTS+21, %eax
	andl	$-2, %eax
	movb	%al, GDTS+21
	movzbl	GDTS+21, %eax
	orl	$2, %eax
	movb	%al, GDTS+21
	movzbl	GDTS+21, %eax
	andl	$-5, %eax
	movb	%al, GDTS+21
	movzbl	GDTS+21, %eax
	andl	$-9, %eax
	movb	%al, GDTS+21
	movzbl	GDTS+21, %eax
	orl	$16, %eax
	movb	%al, GDTS+21
	movzbl	GDTS+21, %eax
	andl	$-97, %eax
	movb	%al, GDTS+21
	movb	$0, GDTS+20
	movzbl	GDTS+21, %eax
	orl	$-128, %eax
	movb	%al, GDTS+21
	movzbl	GDTS+22, %eax
	orl	$15, %eax
	movb	%al, GDTS+22
	movzbl	GDTS+22, %eax
	andl	$-17, %eax
	movb	%al, GDTS+22
	movzbl	GDTS+22, %eax
	andl	$-33, %eax
	movb	%al, GDTS+22
	movzbl	GDTS+22, %eax
	orl	$64, %eax
	movb	%al, GDTS+22
	movzbl	GDTS+22, %eax
	andl	$127, %eax
	movb	%al, GDTS+22
	movb	$0, GDTS+23
	movw	$-1, GDTS+24
	movzwl	KernelSegment, %eax
	sall	$4, %eax
	movw	%ax, GDTS+26
	movb	$0, GDTS+28
	movzbl	GDTS+29, %eax
	andl	$-2, %eax
	movb	%al, GDTS+29
	movzbl	GDTS+29, %eax
	orl	$2, %eax
	movb	%al, GDTS+29
	movzbl	GDTS+29, %eax
	andl	$-5, %eax
	movb	%al, GDTS+29
	movzbl	GDTS+29, %eax
	andl	$-9, %eax
	movb	%al, GDTS+29
	movzbl	GDTS+29, %eax
	orl	$16, %eax
	movb	%al, GDTS+29
	movzbl	GDTS+29, %eax
	andl	$-97, %eax
	movb	%al, GDTS+29
	movb	$0, GDTS+28
	movzbl	GDTS+29, %eax
	orl	$-128, %eax
	movb	%al, GDTS+29
	movzbl	GDTS+30, %eax
	orl	$15, %eax
	movb	%al, GDTS+30
	movzbl	GDTS+30, %eax
	andl	$-17, %eax
	movb	%al, GDTS+30
	movzbl	GDTS+30, %eax
	andl	$-33, %eax
	movb	%al, GDTS+30
	movzbl	GDTS+30, %eax
	orl	$64, %eax
	movb	%al, GDTS+30
	movzbl	GDTS+30, %eax
	andl	$127, %eax
	movb	%al, GDTS+30
	movb	$0, GDTS+31
	movw	$2039, IDTDescr
	movzwl	KernelSegment, %eax
	movzwl	%ax, %eax
	movl	$IDTDescr+2, 12(%esp)
	movl	$IDTDescr+4, 8(%esp)
	movl	$IDTS, 4(%esp)
	movl	%eax, (%esp)
	call	Log2Phy
#APP
# 109 "./include/protect.c" 1
	lgdt GDTDescr

# 0 "" 2
# 110 "./include/protect.c" 1
	lidt IDTDescr

# 0 "" 2
#NO_APP
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	CreateGDTIDT, .-CreateGDTIDT
	.globl	GetA20State
	.type	GetA20State, @function
GetA20State:
.LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$16, %esp
	.cfi_offset 3, -12
#APP
# 117 "./include/protect.c" 1
	pusha
movb $0xD0,%al
outb %al,$0x64
.wait:
movb $0,%al
inb $0x64,%al
and $1,%al
cmp $0,%al
je .wait
inb $0x60,%al
and $2,%al
movb %al,%bl

# 0 "" 2
#NO_APP
	movb	%bl, -5(%ebp)
	movzbl	-5(%ebp), %eax
	addl	$16, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	GetA20State, .-GetA20State
	.globl	SetA20State
	.type	SetA20State, @function
SetA20State:
.LFB3:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$4, %esp
	movl	8(%ebp), %eax
	movb	%al, -4(%ebp)
#APP
# 137 "./include/protect.c" 1
	.intel_syntax noprefix
mov al,0xD0
out 0x64,al
.SetA20Statewait:
mov al,0
in al,0x64
and al,1
cmp al,0
je .SetA20Statewait
in al,0x60
cmp cx,0
je .SetA20State0
or al,2
.SetA20StateNext:
mov ah,al
mov al,0x0d1
out 0x64,al
mov al,ah
out 0x60,al
jmp .SetA20StateEnd
.SetA20State0:
and al,0xFD
jmp .SetA20StateNext
.SetA20StateEnd:.att_syntax prefix

# 0 "" 2
#NO_APP
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE3:
	.size	SetA20State, .-SetA20State
#APP
	.code32
#NO_APP
	.globl	GoToPM
	.type	GoToPM, @function
GoToPM:
.LFB4:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
#APP
# 167 "./include/protect.c" 1
	cli
smsw %ax
or $1,%ax
lmsw %ax
xchg %bx,%bx
ljmp $8,$GoToPMAfterPM
GoToPMAfterPM:
.code32
movw $0x10,%ax
movw %ax,%ds
movw %ax,%es
movw $0x18,%ax
movw %ax,%ss

# 0 "" 2
#NO_APP
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE4:
	.size	GoToPM, .-GoToPM
	.globl	GoToRM
	.type	GoToRM, @function
GoToRM:
.LFB5:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movw	$-1, GDTS+8
	movzbl	GDTS+13, %eax
	andl	$-2, %eax
	movb	%al, GDTS+13
	movzbl	GDTS+13, %eax
	andl	$-3, %eax
	movb	%al, GDTS+13
	movzbl	GDTS+13, %eax
	andl	$-5, %eax
	movb	%al, GDTS+13
	movzbl	GDTS+13, %eax
	orl	$8, %eax
	movb	%al, GDTS+13
	movzbl	GDTS+13, %eax
	orl	$16, %eax
	movb	%al, GDTS+13
	movzbl	GDTS+13, %eax
	andl	$-97, %eax
	movb	%al, GDTS+13
	movzbl	GDTS+13, %eax
	orl	$-128, %eax
	movb	%al, GDTS+13
	movzbl	GDTS+14, %eax
	andl	$-16, %eax
	movb	%al, GDTS+14
	movzbl	GDTS+14, %eax
	andl	$-17, %eax
	movb	%al, GDTS+14
	movzbl	GDTS+14, %eax
	andl	$-33, %eax
	movb	%al, GDTS+14
	movzbl	GDTS+14, %eax
	andl	$-65, %eax
	movb	%al, GDTS+14
	movzbl	GDTS+14, %eax
	andl	$127, %eax
	movb	%al, GDTS+14
	movw	$-1, GDTS+16
	movzbl	GDTS+21, %eax
	andl	$-2, %eax
	movb	%al, GDTS+21
	movzbl	GDTS+21, %eax
	orl	$2, %eax
	movb	%al, GDTS+21
	movzbl	GDTS+21, %eax
	andl	$-5, %eax
	movb	%al, GDTS+21
	movzbl	GDTS+21, %eax
	andl	$-9, %eax
	movb	%al, GDTS+21
	movzbl	GDTS+21, %eax
	orl	$16, %eax
	movb	%al, GDTS+21
	movzbl	GDTS+21, %eax
	andl	$-97, %eax
	movb	%al, GDTS+21
	movzbl	GDTS+21, %eax
	orl	$-128, %eax
	movb	%al, GDTS+21
	movzbl	GDTS+22, %eax
	andl	$-16, %eax
	movb	%al, GDTS+22
	movzbl	GDTS+22, %eax
	andl	$-17, %eax
	movb	%al, GDTS+22
	movzbl	GDTS+22, %eax
	andl	$-33, %eax
	movb	%al, GDTS+22
	movzbl	GDTS+22, %eax
	andl	$-65, %eax
	movb	%al, GDTS+22
	movzbl	GDTS+22, %eax
	andl	$127, %eax
	movb	%al, GDTS+22
	movw	$1023, IDTDescr
	movw	$0, IDTDescr+2
	movb	$0, IDTDescr+4
#APP
# 220 "./include/protect.c" 1
	cli
lidt IDTDescr
movw $0x10,%ax
movw %ax,%ds
movw %ax,%es
movw %ax,%ss
ljmp $0x8,$GoToRMSetCSDescr
GoToRMSetCSDescr:
movl %CR0,%eax
andl $0xFFFFFFFE,%eax
movl %eax,%CR0
.code16gcc
pushl KernelSegmentInRM
pushl $GoToRMSetRegs
retf
GoToRMSetRegs:
movw KernelSegmentInRM,%ax
movw %ax,%ds
movw %ax,%es
movw %ax,%ss

# 0 "" 2
#NO_APP
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE5:
	.size	GoToRM, .-GoToRM
	.ident	"GCC: (Debian 4.7.2-5) 4.7.2"
	.section	.note.GNU-stack,"",@progbits
