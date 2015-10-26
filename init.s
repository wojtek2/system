	.file	"init.c"
	.text
.Ltext0:
	.comm	PTE,4,4
	.globl	EnablePaging
	.type	EnablePaging, @function
EnablePaging:
.LFB0:
	.file 1 "init.c"
	.loc 1 16 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 20 0
	movl	KernelPDEA, %eax
	orl	$1, %eax
	movl	%eax, KernelPDEA
	.loc 1 21 0
	movl	KernelPDEA, %eax
	andl	$-3, %eax
	movl	%eax, KernelPDEA
	.loc 1 22 0
	movl	KernelPDEA, %eax
	andl	$-5, %eax
	movl	%eax, KernelPDEA
	.loc 1 23 0
	movl	KernelPDEA, %eax
	andl	$-9, %eax
	movl	%eax, KernelPDEA
	.loc 1 24 0
	movl	KernelPDEA, %eax
	andl	$-17, %eax
	movl	%eax, KernelPDEA
	.loc 1 25 0
	movl	KernelPDEA, %eax
	andl	$-33, %eax
	movl	%eax, KernelPDEA
	.loc 1 26 0
	movl	KernelPDEA, %eax
	andl	$-65, %eax
	movl	%eax, KernelPDEA
	.loc 1 27 0
	movl	KernelPDEA, %eax
	andb	$127, %al
	movl	%eax, KernelPDEA
	.loc 1 28 0
	movl	KernelPDEA, %eax
	andb	$254, %ah
	movl	%eax, KernelPDEA
	.loc 1 29 0
	movl	KernelPDEA, %eax
	andb	$241, %ah
	movl	%eax, KernelPDEA
	.loc 1 31 0
	movl	KernelPTEA, %eax
	orl	$1, %eax
	movl	%eax, KernelPTEA
	.loc 1 32 0
	movl	KernelPTEA, %eax
	andl	$-3, %eax
	movl	%eax, KernelPTEA
	.loc 1 33 0
	movl	KernelPTEA, %eax
	orl	$4, %eax
	movl	%eax, KernelPTEA
	.loc 1 34 0
	movl	KernelPTEA, %eax
	andl	$-9, %eax
	movl	%eax, KernelPTEA
	.loc 1 35 0
	movl	KernelPTEA, %eax
	andl	$-17, %eax
	movl	%eax, KernelPTEA
	.loc 1 36 0
	movl	KernelPTEA, %eax
	andl	$-33, %eax
	movl	%eax, KernelPTEA
	.loc 1 37 0
	movl	KernelPTEA, %eax
	andb	$127, %al
	movl	%eax, KernelPTEA
	.loc 1 38 0
	movl	KernelPTEA, %eax
	andl	$-65, %eax
	movl	%eax, KernelPTEA
	.loc 1 39 0
	movl	KernelPTEA, %eax
	andb	$254, %ah
	movl	%eax, KernelPTEA
	.loc 1 40 0
	movl	KernelPTEA, %eax
	andb	$241, %ah
	movl	%eax, KernelPTEA
	.loc 1 42 0
	subl	$4, %esp
	pushl	$KernelPTEA
	pushl	$KernelPDEA
	pushl	$10485760
	pushl	$0
	pushl	$0
	pushl	$KernelPTEs
	pushl	$KernelPDE
	call	AllocPsyhicalMemory
	addl	$32, %esp
	.loc 1 43 0
#APP
# 43 "init.c" 1
	xchg %bx,%bx
 #BOCHS DEBUG
# 0 "" 2
	.loc 1 46 0
#NO_APP
	movl	$KernelPDE, %edx
#APP
# 46 "init.c" 1
	cli
movl %edx,%eax
movl %eax,%cr3
movl %cr0,%eax
or $0x80000000,%eax
movl %eax,%cr0
ljmp $0x8,$AfterEnablePaging
AfterEnablePaging:
movl $0,%eax

# 0 "" 2
	.loc 1 59 0
#NO_APP
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	EnablePaging, .-EnablePaging
	.globl	Log2Phy
	.type	Log2Phy, @function
Log2Phy:
.LFB1:
	.loc 1 62 0
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
	.loc 1 68 0
	movzwl	CallStack, %eax
	movw	%ax, OldCallStack
	movw	$4, CallStack
	.loc 1 69 0
	movzwl	-20(%ebp), %eax
	movw	%ax, -2(%ebp)
	.loc 1 70 0
	shrw	$12, -2(%ebp)
	.loc 1 71 0
	movl	16(%ebp), %eax
	movzwl	-2(%ebp), %edx
	movw	%dx, (%eax)
	.loc 1 72 0
	movzwl	-20(%ebp), %eax
	movw	%ax, -2(%ebp)
	.loc 1 73 0
	salw	$4, -2(%ebp)
	.loc 1 74 0
	movzwl	-2(%ebp), %edx
	movzwl	-24(%ebp), %eax
	addl	%eax, %edx
	movl	20(%ebp), %eax
	movw	%dx, (%eax)
	.loc 1 75 0
	movzwl	OldCallStack, %eax
	movw	%ax, CallStack
	.loc 1 76 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	Log2Phy, .-Log2Phy
	.globl	CreateGDTIDT
	.type	CreateGDTIDT, @function
CreateGDTIDT:
.LFB2:
	.loc 1 78 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 1 81 0
	movzwl	CallStack, %eax
	movw	%ax, OldCallStack
	movw	$3, CallStack
	.loc 1 83 0
	subl	$12, %esp
	pushl	$0
	pushl	$0
	pushl	$0
	pushl	$0
	pushl	$0
	pushl	$0
	pushl	$0
	pushl	$0
	pushl	$0
	pushl	$0
	pushl	$0
	pushl	$0
	pushl	$0
	call	EditGDTEntry
	addl	$64, %esp
	.loc 1 86 0
	subl	$12, %esp
	pushl	$1
	pushl	$1
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$1
	pushl	$1
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$0
	pushl	$1048575
	pushl	$1
	call	EditGDTEntry
	addl	$64, %esp
	.loc 1 88 0
	subl	$12, %esp
	pushl	$1
	pushl	$1
	pushl	$0
	pushl	$1
	pushl	$3
	pushl	$1
	pushl	$0
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$0
	pushl	$1048575
	pushl	$2
	call	EditGDTEntry
	addl	$64, %esp
	.loc 1 90 0
	subl	$12, %esp
	pushl	$1
	pushl	$1
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$0
	pushl	$1048575
	pushl	$3
	call	EditGDTEntry
	addl	$64, %esp
	.loc 1 93 0
	subl	$12, %esp
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$1
	pushl	$3
	pushl	$1
	pushl	$0
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$753664
	pushl	$4000
	pushl	$4
	call	EditGDTEntry
	addl	$64, %esp
	.loc 1 96 0
	movl	$KernelTSS, %eax
	subl	$12, %esp
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$0
	pushl	$1
	pushl	%eax
	pushl	$104
	pushl	$5
	call	EditGDTEntry
	addl	$64, %esp
	.loc 1 98 0
	subl	$12, %esp
	pushl	$1
	pushl	$1
	pushl	$0
	pushl	$1
	pushl	$1
	pushl	$1
	pushl	$1
	pushl	$1
	pushl	$1
	pushl	$0
	pushl	$0
	pushl	$1048575
	pushl	$6
	call	EditGDTEntry
	addl	$64, %esp
	.loc 1 99 0
	subl	$12, %esp
	pushl	$1
	pushl	$1
	pushl	$0
	pushl	$1
	pushl	$2
	pushl	$1
	pushl	$1
	pushl	$1
	pushl	$1
	pushl	$0
	pushl	$0
	pushl	$1048575
	pushl	$7
	call	EditGDTEntry
	addl	$64, %esp
	.loc 1 100 0
	subl	$12, %esp
	pushl	$1
	pushl	$1
	pushl	$0
	pushl	$1
	pushl	$3
	pushl	$1
	pushl	$1
	pushl	$1
	pushl	$1
	pushl	$0
	pushl	$0
	pushl	$1048575
	pushl	$8
	call	EditGDTEntry
	addl	$64, %esp
	.loc 1 102 0
	movw	$10, GDTC
	.loc 1 104 0
	movw	$2047, GDTDescr
	.loc 1 105 0
	movw	$2047, IDTDescr
	.loc 1 109 0
	movl	$GDTS, -12(%ebp)
	.loc 1 110 0
	andl	$-65536, -12(%ebp)
	.loc 1 111 0
	shrl	$16, -12(%ebp)
	.loc 1 112 0
	movl	-12(%ebp), %eax
	movb	%al, GDTDescr+4
	.loc 1 113 0
	movl	$GDTS, -12(%ebp)
	.loc 1 114 0
	andl	$65535, -12(%ebp)
	.loc 1 116 0
	movl	-12(%ebp), %eax
	movw	%ax, GDTDescr+2
	.loc 1 118 0
	movl	$IDTS, -12(%ebp)
	.loc 1 119 0
	andl	$-65536, -12(%ebp)
	.loc 1 120 0
	shrl	$16, -12(%ebp)
	.loc 1 121 0
	movl	-12(%ebp), %eax
	movb	%al, IDTDescr+4
	.loc 1 122 0
	movl	$IDTS, -12(%ebp)
	.loc 1 123 0
	andl	$65535, -12(%ebp)
	.loc 1 125 0
	movl	-12(%ebp), %eax
	movw	%ax, IDTDescr+2
	.loc 1 126 0
#APP
# 126 "init.c" 1
	lgdt GDTDescr

# 0 "" 2
	.loc 1 127 0
# 127 "init.c" 1
	lidt IDTDescr

# 0 "" 2
	.loc 1 128 0
#NO_APP
	movzwl	OldCallStack, %eax
	movw	%ax, CallStack
	.loc 1 129 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	CreateGDTIDT, .-CreateGDTIDT
	.comm	temp,2,2
	.comm	temp2,4,4
	.globl	InitKernel
	.type	InitKernel, @function
InitKernel:
.LFB3:
	.loc 1 138 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 140 0
	movzwl	CallStack, %eax
	movw	%ax, OldCallStack
	movw	$2, CallStack
	.loc 1 149 0
	movw	$0, temp
	.loc 1 151 0
	call	CreateGDTIDT
	.loc 1 152 0
#APP
# 152 "init.c" 1
	xchg %bx,%bx
 #BOCHS DEBUG
# 0 "" 2
	.loc 1 158 0
# 158 "init.c" 1
	ljmp $0x8,$InitKernelSetRegs
InitKernelSetRegs:
movl $0,%eax
movl %eax,%cr2
movl %eax,%cr3
movl %eax,%cr4
movw $0x13,%ax
movw %ax,%ds
movw %ax,%es
movw %ax,%gs
movw %ax,%fs
movw $0x18,%ax
movw %ax,%ss

# 0 "" 2
	.loc 1 172 0
#NO_APP
	movw	$128, KernelBase
	.loc 1 176 0
	movw	$32, temp
	jmp	.L5
.L6:
	.loc 1 177 0 discriminator 3
	movl	$EmptyInterrupt, %eax
	movl	%eax, temp2
	.loc 1 178 0 discriminator 3
	movzwl	temp, %eax
	movzwl	%ax, %eax
	movl	temp2, %edx
	movw	%dx, IDTS(,%eax,8)
	.loc 1 179 0 discriminator 3
	movzwl	temp, %eax
	movzwl	%ax, %eax
	movw	$8, IDTS+2(,%eax,8)
	.loc 1 180 0 discriminator 3
	movzwl	temp, %eax
	movzwl	%ax, %eax
	movb	$0, IDTS+4(,%eax,8)
	.loc 1 181 0 discriminator 3
	movzwl	temp, %eax
	movzwl	%ax, %eax
	movzbl	IDTS+5(,%eax,8), %edx
	andl	$-2, %edx
	movb	%dl, IDTS+5(,%eax,8)
	.loc 1 182 0 discriminator 3
	movzwl	temp, %eax
	movzwl	%ax, %eax
	movzbl	IDTS+5(,%eax,8), %edx
	orl	$6, %edx
	movb	%dl, IDTS+5(,%eax,8)
	.loc 1 183 0 discriminator 3
	movzwl	temp, %eax
	movzwl	%ax, %eax
	movzbl	IDTS+5(,%eax,8), %edx
	orl	$8, %edx
	movb	%dl, IDTS+5(,%eax,8)
	.loc 1 184 0 discriminator 3
	movzwl	temp, %eax
	movzwl	%ax, %eax
	movzbl	IDTS+5(,%eax,8), %edx
	andl	$-17, %edx
	movb	%dl, IDTS+5(,%eax,8)
	.loc 1 185 0 discriminator 3
	movzwl	temp, %eax
	movzwl	%ax, %eax
	movzbl	IDTS+5(,%eax,8), %edx
	andl	$-97, %edx
	movb	%dl, IDTS+5(,%eax,8)
	.loc 1 186 0 discriminator 3
	movzwl	temp, %eax
	movzwl	%ax, %eax
	movzbl	IDTS+5(,%eax,8), %edx
	orl	$-128, %edx
	movb	%dl, IDTS+5(,%eax,8)
	.loc 1 187 0 discriminator 3
	movl	temp2, %eax
	movw	$0, %ax
	movl	%eax, temp2
	.loc 1 188 0 discriminator 3
	movzwl	temp, %eax
	movzwl	%ax, %eax
	movl	temp2, %edx
	shrl	$16, %edx
	movw	%dx, IDTS+6(,%eax,8)
	.loc 1 176 0 discriminator 3
	movzwl	temp, %eax
	addl	$1, %eax
	movw	%ax, temp
.L5:
	.loc 1 176 0 is_stmt 0 discriminator 1
	movzwl	temp, %eax
	cmpw	$255, %ax
	jbe	.L6
	.loc 1 190 0 is_stmt 1
	movl	$8192, FramesN
	.loc 1 191 0
	call	EnablePaging
	.loc 1 192 0
	call	InitMain
	.loc 1 193 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE3:
	.size	InitKernel, .-InitKernel
#APP
	.code32
#NO_APP
	.globl	NextTask
	.bss
	.type	NextTask, @object
	.size	NextTask, 1
NextTask:
	.zero	1
	.globl	temp10
	.data
	.type	temp10, @object
	.size	temp10, 1
temp10:
	.byte	1
	.comm	TaskTSS,104,64
	.comm	TaskTSS0,104,64
	.comm	TaskTSS1,104,64
	.comm	TaskTSS2,104,64
	.comm	StackTask0,65535,64
	.comm	StackTask1,65535,64
	.comm	StackTask1SS0,65535,64
	.comm	StackTask2,65535,64
	.comm	StackTask2SS0,65535,64
	.comm	StackTask3,65535,64
	.comm	StackTask3SS0,65535,64
	.comm	tempx,4,4
	.text
	.globl	KeybIRQ
	.type	KeybIRQ, @function
KeybIRQ:
.LFB4:
	.file 2 "./include/temp.c"
	.loc 2 33 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 2 34 0
#APP
# 34 "./include/temp.c" 1
	xchg %bx,%bx
 #BOCHS DEBUG
# 0 "" 2
	.loc 2 35 0
# 35 "./include/temp.c" 1
	cli

# 0 "" 2
	.loc 2 36 0
#NO_APP
	movb	$2, TextColor
	.loc 2 37 0
	subl	$8, %esp
	pushl	$7
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
	.loc 2 39 0
	movb	$7, TextColor
	.loc 2 40 0
#APP
# 40 "./include/temp.c" 1
	pushw %ax
movb $0x20,%al
outb %al,$0x20
popw %ax
leave
iret

# 0 "" 2
	.loc 2 46 0
#NO_APP
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE4:
	.size	KeybIRQ, .-KeybIRQ
	.section	.rodata
.LC0:
	.string	"Teraz dziala zadanie nr 1"
	.text
	.globl	Task1
	.type	Task1, @function
Task1:
.LFB5:
	.loc 2 47 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 2 52 0
#APP
# 52 "./include/temp.c" 1
	xchg %bx,%bx
 #BOCHS DEBUG
# 0 "" 2
#NO_APP
.L9:
.LBB2:
	.loc 2 59 0 discriminator 1
	subl	$8, %esp
	pushl	$0
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
	.loc 2 60 0 discriminator 1
	subl	$12, %esp
	pushl	$.LC0
	call	kprintf
	addl	$16, %esp
.LBE2:
	.loc 2 63 0 discriminator 1
	jmp	.L9
	.cfi_endproc
.LFE5:
	.size	Task1, .-Task1
	.section	.rodata
.LC1:
	.string	"Teraz dziala zadanie nr 2"
	.text
	.globl	Task2
	.type	Task2, @function
Task2:
.LFB6:
	.loc 2 69 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 2 73 0
	subl	$8, %esp
	pushl	$0
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
.L11:
	.loc 2 78 0 discriminator 1
	subl	$8, %esp
	pushl	$0
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
	.loc 2 79 0 discriminator 1
	subl	$12, %esp
	pushl	$.LC1
	call	kprintf
	addl	$16, %esp
	.loc 2 82 0 discriminator 1
	jmp	.L11
	.cfi_endproc
.LFE6:
	.size	Task2, .-Task2
	.section	.rodata
.LC2:
	.string	"Teraz dziala zadanie nr 3"
	.text
	.globl	Task3
	.type	Task3, @function
Task3:
.LFB7:
	.loc 2 88 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 2 93 0
	subl	$8, %esp
	pushl	$0
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
.L13:
	.loc 2 98 0 discriminator 1
	subl	$8, %esp
	pushl	$0
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
	.loc 2 99 0 discriminator 1
	subl	$12, %esp
	pushl	$.LC2
	call	kprintf
	addl	$16, %esp
	.loc 2 102 0 discriminator 1
	jmp	.L13
	.cfi_endproc
.LFE7:
	.size	Task3, .-Task3
	.section	.rodata
.LC3:
	.string	"Teraz dziala zadanie nr 4"
	.text
	.globl	Task4
	.type	Task4, @function
Task4:
.LFB8:
	.loc 2 109 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 2 114 0
	subl	$8, %esp
	pushl	$0
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
.L15:
	.loc 2 119 0 discriminator 1
	subl	$8, %esp
	pushl	$0
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
	.loc 2 120 0 discriminator 1
	subl	$12, %esp
	pushl	$.LC3
	call	kprintf
	addl	$16, %esp
	.loc 2 123 0 discriminator 1
	jmp	.L15
	.cfi_endproc
.LFE8:
	.size	Task4, .-Task4
	.section	.rodata
.LC4:
	.string	"Teraz dziala zadanie nr 5"
	.text
	.globl	Task5
	.type	Task5, @function
Task5:
.LFB9:
	.loc 2 130 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 2 135 0
	subl	$8, %esp
	pushl	$0
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
.L17:
	.loc 2 140 0 discriminator 1
	subl	$8, %esp
	pushl	$0
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
	.loc 2 141 0 discriminator 1
	subl	$12, %esp
	pushl	$.LC4
	call	kprintf
	addl	$16, %esp
	.loc 2 144 0 discriminator 1
	jmp	.L17
	.cfi_endproc
.LFE9:
	.size	Task5, .-Task5
	.section	.rodata
.LC5:
	.string	"Teraz dziala zadanie nr 6"
	.text
	.globl	Task6
	.type	Task6, @function
Task6:
.LFB10:
	.loc 2 151 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 2 156 0
	subl	$8, %esp
	pushl	$0
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
.L19:
	.loc 2 161 0 discriminator 1
	subl	$8, %esp
	pushl	$0
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
	.loc 2 162 0 discriminator 1
	subl	$12, %esp
	pushl	$.LC5
	call	kprintf
	addl	$16, %esp
	.loc 2 165 0 discriminator 1
	jmp	.L19
	.cfi_endproc
.LFE10:
	.size	Task6, .-Task6
	.section	.rodata
.LC6:
	.string	"Teraz dziala zadanie nr 7"
	.text
	.globl	Task7
	.type	Task7, @function
Task7:
.LFB11:
	.loc 2 172 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 2 177 0
	subl	$8, %esp
	pushl	$0
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
.L21:
	.loc 2 182 0 discriminator 1
	subl	$8, %esp
	pushl	$0
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
	.loc 2 183 0 discriminator 1
	subl	$12, %esp
	pushl	$.LC6
	call	kprintf
	addl	$16, %esp
	.loc 2 186 0 discriminator 1
	jmp	.L21
	.cfi_endproc
.LFE11:
	.size	Task7, .-Task7
	.section	.rodata
.LC7:
	.string	"Teraz dziala zadanie nr 8"
	.text
	.globl	Task8
	.type	Task8, @function
Task8:
.LFB12:
	.loc 2 193 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 2 198 0
	subl	$8, %esp
	pushl	$0
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
.L23:
	.loc 2 203 0 discriminator 1
	subl	$8, %esp
	pushl	$0
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
	.loc 2 204 0 discriminator 1
	subl	$12, %esp
	pushl	$.LC7
	call	kprintf
	addl	$16, %esp
	.loc 2 207 0 discriminator 1
	jmp	.L23
	.cfi_endproc
.LFE12:
	.size	Task8, .-Task8
	.section	.rodata
.LC8:
	.string	"Teraz dziala zadanie nr 9"
	.text
	.globl	Task9
	.type	Task9, @function
Task9:
.LFB13:
	.loc 2 215 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 2 220 0
	subl	$8, %esp
	pushl	$0
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
.L25:
	.loc 2 225 0 discriminator 1
	subl	$8, %esp
	pushl	$0
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
	.loc 2 226 0 discriminator 1
	subl	$12, %esp
	pushl	$.LC8
	call	kprintf
	addl	$16, %esp
	.loc 2 229 0 discriminator 1
	jmp	.L25
	.cfi_endproc
.LFE13:
	.size	Task9, .-Task9
	.section	.rodata
.LC9:
	.string	"Teraz dziala zadanie nr 10"
	.text
	.globl	Task10
	.type	Task10, @function
Task10:
.LFB14:
	.loc 2 236 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 2 241 0
	subl	$8, %esp
	pushl	$0
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
.L27:
	.loc 2 246 0 discriminator 1
	subl	$8, %esp
	pushl	$0
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
	.loc 2 247 0 discriminator 1
	subl	$12, %esp
	pushl	$.LC9
	call	kprintf
	addl	$16, %esp
	.loc 2 250 0 discriminator 1
	jmp	.L27
	.cfi_endproc
.LFE14:
	.size	Task10, .-Task10
	.section	.rodata
.LC10:
	.string	"xxxcccc\n"
	.text
	.globl	Clock
	.type	Clock, @function
Clock:
.LFB15:
	.loc 2 258 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 2 260 0
	movl	$0, TasksN
	.loc 2 261 0
	movl	$1, ActTaskN
	.loc 2 262 0
	movw	$20, GDTC
	.loc 2 263 0
	movl	$Tasks+172, ActTaskTSS
	.loc 2 268 0
	movl	$StackTask1, %eax
	subl	$12, %esp
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	%eax
	pushl	$65535
	pushl	$9
	call	EditGDTEntry
	addl	$64, %esp
	.loc 2 269 0
	movl	$Task1, %eax
	subl	$8, %esp
	pushl	$0
	pushl	$0
	pushl	$0
	pushl	$65535
	pushl	$65535
	pushl	$65535
	pushl	$65535
	pushl	$72
	pushl	$0
	pushl	$0
	pushl	$72
	pushl	$512
	pushl	$0
	pushl	%eax
	call	AddToProcessList
	addl	$64, %esp
	.loc 2 272 0
	movl	$StackTask2, %eax
	subl	$12, %esp
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$1
	pushl	$3
	pushl	$1
	pushl	$0
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	%eax
	pushl	$65535
	pushl	$10
	call	EditGDTEntry
	addl	$64, %esp
	.loc 2 273 0
	movl	$StackTask2SS0, %eax
	subl	$12, %esp
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	%eax
	pushl	$65535
	pushl	$11
	call	EditGDTEntry
	addl	$64, %esp
	.loc 2 274 0
	movl	$Task2, %eax
	subl	$8, %esp
	pushl	$0
	pushl	$0
	pushl	$0
	pushl	$65535
	pushl	$65535
	pushl	$65535
	pushl	$65535
	pushl	$83
	pushl	$0
	pushl	$0
	pushl	$88
	pushl	$512
	pushl	$3
	pushl	%eax
	call	AddToProcessList
	addl	$64, %esp
	.loc 2 277 0
	movl	$StackTask3, %eax
	subl	$12, %esp
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$1
	pushl	$2
	pushl	$1
	pushl	$0
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	%eax
	pushl	$65535
	pushl	$12
	call	EditGDTEntry
	addl	$64, %esp
	.loc 2 278 0
	movl	$StackTask3SS0, %eax
	subl	$12, %esp
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	%eax
	pushl	$65535
	pushl	$13
	call	EditGDTEntry
	addl	$64, %esp
	.loc 2 279 0
	movl	$Task3, %eax
	subl	$8, %esp
	pushl	$0
	pushl	$0
	pushl	$0
	pushl	$65535
	pushl	$65535
	pushl	$65535
	pushl	$65535
	pushl	$98
	pushl	$98
	pushl	$0
	pushl	$104
	pushl	$512
	pushl	$2
	pushl	%eax
	call	AddToProcessList
	addl	$64, %esp
	.loc 2 282 0
	movl	$Tasks+172, %eax
	subl	$12, %esp
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$0
	pushl	$1
	pushl	%eax
	pushl	$104
	pushl	$5
	call	EditGDTEntry
	addl	$64, %esp
	.loc 2 283 0
#APP
# 283 "./include/temp.c" 1
	movw $0x28,%ax
ltr %ax

# 0 "" 2
	.loc 2 288 0
#NO_APP
	movl	$SystemClock, -12(%ebp)
	.loc 2 289 0
	movl	-12(%ebp), %eax
	movw	%ax, IDTS+256
	.loc 2 290 0
	movw	$8, IDTS+258
	.loc 2 291 0
	movb	$0, IDTS+260
	.loc 2 292 0
	movzbl	IDTS+261, %eax
	andl	$-2, %eax
	movb	%al, IDTS+261
	.loc 2 293 0
	movzbl	IDTS+261, %eax
	orl	$6, %eax
	movb	%al, IDTS+261
	.loc 2 294 0
	movzbl	IDTS+261, %eax
	orl	$8, %eax
	movb	%al, IDTS+261
	.loc 2 295 0
	movzbl	IDTS+261, %eax
	andl	$-17, %eax
	movb	%al, IDTS+261
	.loc 2 296 0
	movzbl	IDTS+261, %eax
	andl	$-97, %eax
	movb	%al, IDTS+261
	.loc 2 297 0
	movzbl	IDTS+261, %eax
	orl	$-128, %eax
	movb	%al, IDTS+261
	.loc 2 298 0
	movl	-12(%ebp), %eax
	shrl	$16, %eax
	movw	%ax, IDTS+262
	.loc 2 299 0
	call	SetClockFrequency
	.loc 2 300 0
	subl	$8, %esp
	pushl	$0
	pushl	$0
	call	EnableIRQ
	addl	$16, %esp
	.loc 2 302 0
	movl	$KeybIRQ, -12(%ebp)
	.loc 2 303 0
	movl	-12(%ebp), %eax
	movw	%ax, IDTS+264
	.loc 2 304 0
	movw	$8, IDTS+266
	.loc 2 305 0
	movb	$0, IDTS+268
	.loc 2 306 0
	movzbl	IDTS+269, %eax
	andl	$-2, %eax
	movb	%al, IDTS+269
	.loc 2 307 0
	movzbl	IDTS+269, %eax
	orl	$6, %eax
	movb	%al, IDTS+269
	.loc 2 308 0
	movzbl	IDTS+269, %eax
	orl	$8, %eax
	movb	%al, IDTS+269
	.loc 2 309 0
	movzbl	IDTS+269, %eax
	andl	$-17, %eax
	movb	%al, IDTS+269
	.loc 2 310 0
	movzbl	IDTS+269, %eax
	andl	$-97, %eax
	movb	%al, IDTS+269
	.loc 2 311 0
	movzbl	IDTS+269, %eax
	orl	$-128, %eax
	movb	%al, IDTS+269
	.loc 2 312 0
	movl	-12(%ebp), %eax
	shrl	$16, %eax
	movw	%ax, IDTS+270
	.loc 2 313 0
	subl	$8, %esp
	pushl	$0
	pushl	$1
	call	EnableIRQ
	addl	$16, %esp
	.loc 2 314 0
	subl	$12, %esp
	pushl	$.LC10
	call	BOCHSDBGprintf
	addl	$16, %esp
	.loc 2 315 0
#APP
# 315 "./include/temp.c" 1
	xchg %bx,%bx
 #BOCHS DEBUG
# 0 "" 2
	.loc 2 316 0
# 316 "./include/temp.c" 1
	movl $0xFFFF,%esp
movw $0x48,%ax
movw %ax,%ss
sti

# 0 "" 2
#NO_APP
.L29:
	.loc 2 322 0 discriminator 1
	call	Task1
	.loc 2 323 0 discriminator 1
	jmp	.L29
	.cfi_endproc
.LFE15:
	.size	Clock, .-Clock
	.comm	tempxxx,4,4
	.comm	tempxxx2,4,4
	.globl	putc
	.type	putc, @function
putc:
.LFB16:
	.loc 2 332 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%esi
	subl	$20, %esp
	.cfi_offset 6, -12
	movl	8(%ebp), %eax
	movb	%al, -24(%ebp)
	.loc 2 335 0
	movzbl	CurY, %eax
	movzbl	%al, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$4, %eax
	movl	%eax, %edx
	movzbl	CurX, %eax
	movzbl	%al, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movw	%ax, -6(%ebp)
	.loc 2 336 0
#APP
# 336 "./include/temp.c" 1
	xchg %bx,%bx
 #BOCHS DEBUG
# 0 "" 2
	.loc 2 337 0
#NO_APP
	movzwl	-6(%ebp), %edx
	movzbl	-24(%ebp), %ecx
	movl	%edx, %esi
#APP
# 337 "./include/temp.c" 1
	movw $0x20,%ax
movw %ax,%es
movb %cl,%es:(%si)
inc %si
movb TextColor,%al
movb %al,%es:(%si)
inc %si

# 0 "" 2
	.loc 2 351 0
#NO_APP
	movzbl	CurX, %eax
	addl	$1, %eax
	movb	%al, CurX
	.loc 2 352 0
	movzbl	CurX, %eax
	cmpb	$79, %al
	jbe	.L30
	.loc 2 353 0
	movb	$0, CurX
	.loc 2 354 0
	movzbl	CurY, %eax
	addl	$1, %eax
	movb	%al, CurY
	.loc 2 355 0
	movzbl	CurY, %eax
	cmpb	$24, %al
	jbe	.L30
	.loc 2 355 0 is_stmt 0 discriminator 1
	movb	$0, CurY
.L30:
	.loc 2 358 0 is_stmt 1
	addl	$20, %esp
	popl	%esi
	.cfi_restore 6
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE16:
	.size	putc, .-putc
#APP
	.code32

#NO_APP
	.type	IntToStr.1261, @function
IntToStr.1261:
.LFB18:
	.loc 2 363 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	.loc 2 365 0
	movl	$1000000000, -8(%ebp)
	.loc 2 366 0
	movl	8(%ebp), %eax
	movl	%eax, -12(%ebp)
	.loc 2 367 0
	movb	$0, -13(%ebp)
	.loc 2 369 0
	movb	$0, -14(%ebp)
	.loc 2 370 0
	movb	$0, -1(%ebp)
	jmp	.L33
.L35:
	.loc 2 371 0
	movl	-12(%ebp), %eax
	movl	$0, %edx
	divl	-8(%ebp)
	movb	%al, -15(%ebp)
	.loc 2 372 0
	movl	-12(%ebp), %eax
	movl	$0, %edx
	divl	-8(%ebp)
	movl	%edx, -12(%ebp)
	.loc 2 373 0
	cmpb	$0, -15(%ebp)
	setne	%dl
	cmpb	$1, -14(%ebp)
	sete	%al
	orl	%edx, %eax
	testb	%al, %al
	je	.L34
	.loc 2 374 0
	movb	$1, -14(%ebp)
	.loc 2 375 0
	movzbl	-13(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movzbl	-15(%ebp), %edx
	addl	$48, %edx
	movb	%dl, (%eax)
	.loc 2 376 0
	movzbl	-13(%ebp), %eax
	addl	$1, %eax
	movb	%al, -13(%ebp)
.L34:
	.loc 2 378 0 discriminator 2
	movl	-8(%ebp), %eax
	movl	$-858993459, %edx
	mull	%edx
	movl	%edx, %eax
	shrl	$3, %eax
	movl	%eax, -8(%ebp)
	.loc 2 370 0 discriminator 2
	movzbl	-1(%ebp), %eax
	addl	$1, %eax
	movb	%al, -1(%ebp)
.L33:
	.loc 2 370 0 is_stmt 0 discriminator 1
	cmpb	$9, -1(%ebp)
	jbe	.L35
	.loc 2 380 0 is_stmt 1
	cmpb	$0, -14(%ebp)
	jne	.L36
	.loc 2 381 0
	movl	12(%ebp), %eax
	movb	$48, (%eax)
	.loc 2 382 0
	movl	$1, %eax
	jmp	.L37
.L36:
	.loc 2 383 0
	movzbl	-13(%ebp), %eax
.L37:
	.loc 2 384 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE18:
	.size	IntToStr.1261, .-IntToStr.1261
	.globl	printf
	.type	printf, @function
printf:
.LFB17:
	.loc 2 361 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$56, %esp
	.loc 2 437 0
	movb	$0, -13(%ebp)
	.loc 2 439 0
	leal	12(%ebp), %eax
	movl	%eax, -32(%ebp)
	.loc 2 441 0
	movw	$0, -10(%ebp)
	jmp	.L39
.L57:
	.loc 2 442 0
	movzwl	-10(%ebp), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	cmpl	$10, %eax
	je	.L41
	cmpl	$13, %eax
	je	.L42
	jmp	.L58
.L41:
.LBB3:
	.loc 2 444 0
	movzbl	CurY, %eax
	movzbl	%al, %eax
	leal	1(%eax), %edx
	movzbl	CurX, %eax
	movzbl	%al, %eax
	subl	$8, %esp
	pushl	%edx
	pushl	%eax
	call	SetCurPos
	addl	$16, %esp
	.loc 2 445 0
	jmp	.L43
.L42:
	.loc 2 447 0
	movzbl	CurY, %eax
	movzbl	%al, %eax
	subl	$8, %esp
	pushl	%eax
	pushl	$0
	call	SetCurPos
	addl	$16, %esp
	.loc 2 448 0
	jmp	.L43
.L58:
	.loc 2 450 0
	movzwl	-10(%ebp), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	cmpb	$37, %al
	jne	.L44
	.loc 2 451 0
	movzwl	-10(%ebp), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	cmpl	$117, %eax
	je	.L46
	cmpl	$120, %eax
	je	.L47
	cmpl	$99, %eax
	je	.L48
	jmp	.L59
.L47:
	.loc 2 453 0
	movl	-32(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, -32(%ebp)
	movl	(%eax), %eax
	movl	%eax, -20(%ebp)
	.loc 2 454 0
	subl	$8, %esp
	leal	-43(%ebp), %eax
	pushl	%eax
	pushl	-20(%ebp)
	call	IntToHex.1274
	addl	$16, %esp
	movb	%al, -21(%ebp)
	.loc 2 456 0
	subl	$12, %esp
	pushl	$48
	call	putc
	addl	$16, %esp
	.loc 2 457 0
	subl	$12, %esp
	pushl	$120
	call	putc
	addl	$16, %esp
	.loc 2 458 0
	movw	$0, -12(%ebp)
	jmp	.L49
.L50:
	.loc 2 459 0 discriminator 3
	movzwl	-12(%ebp), %eax
	movzbl	-43(%ebp,%eax), %eax
	movzbl	%al, %eax
	subl	$12, %esp
	pushl	%eax
	call	putc
	addl	$16, %esp
	.loc 2 458 0 discriminator 3
	movzwl	-12(%ebp), %eax
	addl	$1, %eax
	movw	%ax, -12(%ebp)
.L49:
	.loc 2 458 0 is_stmt 0 discriminator 1
	movzbl	-21(%ebp), %eax
	cmpw	-12(%ebp), %ax
	ja	.L50
	.loc 2 461 0 is_stmt 1
	jmp	.L51
.L46:
	.loc 2 463 0
	movl	-32(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, -32(%ebp)
	movl	(%eax), %eax
	movl	%eax, -20(%ebp)
	.loc 2 464 0
	subl	$8, %esp
	leal	-43(%ebp), %eax
	pushl	%eax
	pushl	-20(%ebp)
	call	IntToStr.1261
	addl	$16, %esp
	movb	%al, -21(%ebp)
	.loc 2 466 0
	movw	$0, -12(%ebp)
	jmp	.L52
.L53:
	.loc 2 467 0 discriminator 3
	movzwl	-12(%ebp), %eax
	movzbl	-43(%ebp,%eax), %eax
	movzbl	%al, %eax
	subl	$12, %esp
	pushl	%eax
	call	putc
	addl	$16, %esp
	.loc 2 466 0 discriminator 3
	movzwl	-12(%ebp), %eax
	addl	$1, %eax
	movw	%ax, -12(%ebp)
.L52:
	.loc 2 466 0 is_stmt 0 discriminator 1
	movzbl	-21(%ebp), %eax
	cmpw	-12(%ebp), %ax
	ja	.L53
	.loc 2 469 0 is_stmt 1
	jmp	.L51
.L48:
	.loc 2 471 0
	movl	-32(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, -32(%ebp)
	movl	(%eax), %eax
	movl	%eax, -28(%ebp)
	.loc 2 472 0
	movw	$0, -12(%ebp)
	jmp	.L54
.L55:
	.loc 2 472 0 is_stmt 0 discriminator 3
	movzwl	-12(%ebp), %edx
	movl	-28(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	subl	$12, %esp
	pushl	%eax
	call	putc
	addl	$16, %esp
	movzwl	-12(%ebp), %eax
	addl	$1, %eax
	movw	%ax, -12(%ebp)
.L54:
	.loc 2 472 0 discriminator 1
	movzwl	-12(%ebp), %edx
	movl	-28(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L55
	.loc 2 473 0 is_stmt 1
	jmp	.L51
.L59:
	.loc 2 475 0
	subl	$12, %esp
	pushl	$37
	call	putc
	addl	$16, %esp
	.loc 2 476 0
	movzwl	-10(%ebp), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	subl	$12, %esp
	pushl	%eax
	call	putc
	addl	$16, %esp
	.loc 2 477 0
	nop
.L51:
	.loc 2 479 0
	movzwl	-10(%ebp), %eax
	addl	$1, %eax
	movw	%ax, -10(%ebp)
	.loc 2 484 0
	jmp	.L60
.L44:
	.loc 2 482 0
	movzwl	-10(%ebp), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	subl	$12, %esp
	pushl	%eax
	call	putc
	addl	$16, %esp
.L60:
	.loc 2 484 0
	nop
.L43:
.LBE3:
	.loc 2 441 0 discriminator 2
	movzwl	-10(%ebp), %eax
	addl	$1, %eax
	movw	%ax, -10(%ebp)
.L39:
	.loc 2 441 0 is_stmt 0 discriminator 1
	movzwl	-10(%ebp), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L57
	.loc 2 489 0 is_stmt 1
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE17:
	.size	printf, .-printf
	.type	IntToHex.1274, @function
IntToHex.1274:
.LFB19:
	.loc 2 387 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	.loc 2 389 0
	movl	$268435456, -8(%ebp)
	.loc 2 390 0
	movl	8(%ebp), %eax
	movl	%eax, -12(%ebp)
	.loc 2 391 0
	movb	$0, -13(%ebp)
	.loc 2 393 0
	movb	$0, -14(%ebp)
	.loc 2 394 0
	movb	$0, -1(%ebp)
	jmp	.L62
.L73:
	.loc 2 395 0
	movl	-12(%ebp), %eax
	movl	$0, %edx
	divl	-8(%ebp)
	movb	%al, -15(%ebp)
	.loc 2 396 0
	movl	-12(%ebp), %eax
	movl	$0, %edx
	divl	-8(%ebp)
	movl	%edx, -12(%ebp)
	.loc 2 397 0
	cmpb	$0, -15(%ebp)
	setne	%dl
	cmpb	$1, -14(%ebp)
	sete	%al
	orl	%edx, %eax
	testb	%al, %al
	je	.L63
	.loc 2 398 0
	movb	$1, -14(%ebp)
	.loc 2 399 0
	movzbl	-15(%ebp), %eax
	subl	$10, %eax
	cmpl	$5, %eax
	ja	.L64
	movl	.L66(,%eax,4), %eax
	jmp	*%eax
	.section	.rodata
	.align 4
	.align 4
.L66:
	.long	.L65
	.long	.L67
	.long	.L68
	.long	.L69
	.long	.L70
	.long	.L71
	.text
.L65:
	.loc 2 401 0
	movzbl	-13(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movb	$65, (%eax)
	.loc 2 402 0
	jmp	.L72
.L67:
	.loc 2 404 0
	movzbl	-13(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movb	$66, (%eax)
	.loc 2 405 0
	jmp	.L72
.L68:
	.loc 2 407 0
	movzbl	-13(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movb	$67, (%eax)
	.loc 2 408 0
	jmp	.L72
.L69:
	.loc 2 410 0
	movzbl	-13(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movb	$68, (%eax)
	.loc 2 411 0
	jmp	.L72
.L70:
	.loc 2 413 0
	movzbl	-13(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movb	$69, (%eax)
	.loc 2 414 0
	jmp	.L72
.L71:
	.loc 2 416 0
	movzbl	-13(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movb	$70, (%eax)
	.loc 2 417 0
	jmp	.L72
.L64:
	.loc 2 419 0
	movzbl	-13(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movzbl	-15(%ebp), %edx
	addl	$48, %edx
	movb	%dl, (%eax)
	.loc 2 420 0
	nop
.L72:
	.loc 2 422 0
	movzbl	-13(%ebp), %eax
	addl	$1, %eax
	movb	%al, -13(%ebp)
.L63:
	.loc 2 424 0 discriminator 2
	movl	-8(%ebp), %eax
	shrl	$4, %eax
	movl	%eax, -8(%ebp)
	.loc 2 394 0 discriminator 2
	movzbl	-1(%ebp), %eax
	addl	$1, %eax
	movb	%al, -1(%ebp)
.L62:
	.loc 2 394 0 is_stmt 0 discriminator 1
	cmpb	$7, -1(%ebp)
	jbe	.L73
	.loc 2 426 0 is_stmt 1
	cmpb	$0, -14(%ebp)
	jne	.L74
	.loc 2 427 0
	movl	12(%ebp), %eax
	movb	$48, (%eax)
	.loc 2 428 0
	movl	$1, %eax
	jmp	.L75
.L74:
	.loc 2 429 0
	movzbl	-13(%ebp), %eax
.L75:
	.loc 2 430 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE19:
	.size	IntToHex.1274, .-IntToHex.1274
	.section	.rodata
.LC11:
	.string	"GRUB"
	.align 4
.LC12:
	.string	"Set vectors of internal exceptions"
	.align 4
.LC13:
	.string	"PIC registers set to protected mode"
.LC14:
	.string	"Enable paging"
.LC15:
	.string	"Clock \nTest\n"
	.text
	.globl	InitMain
	.type	InitMain, @function
InitMain:
.LFB20:
	.loc 1 197 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 1 199 0
	call	ClearScreen
	.loc 1 200 0
	subl	$12, %esp
	pushl	$.LC11
	call	kprintf
	addl	$16, %esp
	.loc 1 201 0
	call	kprintOK
	.loc 1 202 0
	call	SetExceptions
	.loc 1 203 0
	subl	$12, %esp
	pushl	$.LC12
	call	kprintf
	addl	$16, %esp
	.loc 1 204 0
	call	kprintOK
	.loc 1 205 0
	call	PICInitInPM
	.loc 1 206 0
	subl	$12, %esp
	pushl	$.LC13
	call	kprintf
	addl	$16, %esp
	.loc 1 207 0
	call	kprintOK
	.loc 1 208 0
	subl	$12, %esp
	pushl	$.LC14
	call	kprintf
	addl	$16, %esp
	.loc 1 209 0
	call	kprintOK
	.loc 1 210 0
	call	kprintOK
	.loc 1 211 0
#APP
# 211 "init.c" 1
	xchg %bx,%bx
 #BOCHS DEBUG
# 0 "" 2
	.loc 1 212 0
#NO_APP
	subl	$12, %esp
	pushl	$.LC15
	call	BOCHSDBGprintf
	addl	$16, %esp
	.loc 1 213 0
#APP
# 213 "init.c" 1
	pushl %eax 
 movl %cr0,%eax
  andl $0x7FFFFFFF,%eax
 movl %eax,%cr0
 popl %eax
# 0 "" 2
	.loc 1 214 0
#NO_APP
	call	SetClosestFreeFrameBit
	movl	%eax, Tasks+140
	.loc 1 215 0
	movw	$1, Tasks+144
	.loc 1 216 0
	movw	$1, Tasks+146
	.loc 1 217 0
	movl	Tasks+140, %eax
	movl	%eax, -12(%ebp)
	.loc 1 218 0
	call	SetClosestFreeFrameBit
	shrl	$12, %eax
	andl	$1048575, %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	movl	%edx, %ecx
	sall	$12, %ecx
	movl	(%eax), %edx
	andl	$4095, %edx
	orl	%ecx, %edx
	movl	%edx, (%eax)
	.loc 1 219 0
#APP
# 219 "init.c" 1
	pushl %eax 
 movl %cr0,%eax
  or $0x80000000,%eax 
 movl %eax,%cr0 
 popl %eax
# 0 "" 2
	.loc 1 220 0
#NO_APP
	movl	KernelPTEA, %eax
	pushl	%eax
	movl	KernelPDEA, %eax
	pushl	%eax
	pushl	$4096
	pushl	$0
	call	AllocMemoryWithAttribs
	addl	$16, %esp
	.loc 1 232 0
#APP
# 232 "init.c" 1
	cli
hlt

# 0 "" 2
#NO_APP
.L77:
	.loc 1 235 0 discriminator 1
	jmp	.L77
	.cfi_endproc
.LFE20:
	.size	InitMain, .-InitMain
.Letext0:
	.file 3 "./include/data.h"
	.file 4 "/usr/lib/gcc/x86_64-linux-gnu/4.9/include/stdarg.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0xe5f
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.long	.LASF140
	.byte	0x1
	.long	.LASF141
	.long	.LASF142
	.long	.Ltext0
	.long	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0x2
	.long	.LASF3
	.byte	0x3
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
	.byte	0x3
	.byte	0x3d
	.long	0x50
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.long	.LASF5
	.uleb128 0x2
	.long	.LASF6
	.byte	0x3
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
	.byte	0x3
	.byte	0x47
	.long	0x153
	.uleb128 0x6
	.long	.LASF8
	.byte	0x3
	.byte	0x48
	.long	0x25
	.byte	0
	.uleb128 0x6
	.long	.LASF9
	.byte	0x3
	.byte	0x49
	.long	0x25
	.byte	0x2
	.uleb128 0x6
	.long	.LASF10
	.byte	0x3
	.byte	0x4a
	.long	0x45
	.byte	0x4
	.uleb128 0x7
	.string	"A"
	.byte	0x3
	.byte	0x4c
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x7
	.byte	0x4
	.uleb128 0x7
	.string	"RW"
	.byte	0x3
	.byte	0x4d
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x6
	.byte	0x4
	.uleb128 0x7
	.string	"CE"
	.byte	0x3
	.byte	0x4e
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x5
	.byte	0x4
	.uleb128 0x7
	.string	"T"
	.byte	0x3
	.byte	0x4f
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x4
	.byte	0x4
	.uleb128 0x7
	.string	"S"
	.byte	0x3
	.byte	0x50
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x3
	.byte	0x4
	.uleb128 0x7
	.string	"DPL"
	.byte	0x3
	.byte	0x51
	.long	0x25
	.byte	0x2
	.byte	0x2
	.byte	0x1
	.byte	0x4
	.uleb128 0x7
	.string	"P"
	.byte	0x3
	.byte	0x52
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0
	.byte	0x4
	.uleb128 0x8
	.long	.LASF11
	.byte	0x3
	.byte	0x54
	.long	0x25
	.byte	0x2
	.byte	0x4
	.byte	0xc
	.byte	0x6
	.uleb128 0x7
	.string	"AVL"
	.byte	0x3
	.byte	0x55
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xb
	.byte	0x6
	.uleb128 0x8
	.long	.LASF12
	.byte	0x3
	.byte	0x56
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xa
	.byte	0x6
	.uleb128 0x7
	.string	"D"
	.byte	0x3
	.byte	0x57
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x9
	.byte	0x6
	.uleb128 0x7
	.string	"G"
	.byte	0x3
	.byte	0x58
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x8
	.byte	0x6
	.uleb128 0x6
	.long	.LASF13
	.byte	0x3
	.byte	0x59
	.long	0x45
	.byte	0x7
	.byte	0
	.uleb128 0x5
	.long	.LASF15
	.byte	0x8
	.byte	0x3
	.byte	0x5c
	.long	0x1e4
	.uleb128 0x6
	.long	.LASF16
	.byte	0x3
	.byte	0x5d
	.long	0x25
	.byte	0
	.uleb128 0x6
	.long	.LASF17
	.byte	0x3
	.byte	0x5e
	.long	0x25
	.byte	0x2
	.uleb128 0x6
	.long	.LASF12
	.byte	0x3
	.byte	0x5f
	.long	0x45
	.byte	0x4
	.uleb128 0x7
	.string	"W"
	.byte	0x3
	.byte	0x60
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x7
	.byte	0x4
	.uleb128 0x7
	.string	"MB3"
	.byte	0x3
	.byte	0x61
	.long	0x25
	.byte	0x2
	.byte	0x2
	.byte	0x5
	.byte	0x4
	.uleb128 0x7
	.string	"D"
	.byte	0x3
	.byte	0x62
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x4
	.byte	0x4
	.uleb128 0x8
	.long	.LASF18
	.byte	0x3
	.byte	0x63
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x3
	.byte	0x4
	.uleb128 0x7
	.string	"DPL"
	.byte	0x3
	.byte	0x64
	.long	0x25
	.byte	0x2
	.byte	0x2
	.byte	0x1
	.byte	0x4
	.uleb128 0x7
	.string	"P"
	.byte	0x3
	.byte	0x65
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0
	.byte	0x4
	.uleb128 0x6
	.long	.LASF19
	.byte	0x3
	.byte	0x66
	.long	0x25
	.byte	0x6
	.byte	0
	.uleb128 0x5
	.long	.LASF20
	.byte	0x6
	.byte	0x3
	.byte	0x69
	.long	0x215
	.uleb128 0x6
	.long	.LASF21
	.byte	0x3
	.byte	0x6a
	.long	0x25
	.byte	0
	.uleb128 0x6
	.long	.LASF22
	.byte	0x3
	.byte	0x6b
	.long	0x25
	.byte	0x2
	.uleb128 0x6
	.long	.LASF23
	.byte	0x3
	.byte	0x6c
	.long	0x45
	.byte	0x4
	.byte	0
	.uleb128 0x5
	.long	.LASF24
	.byte	0x6
	.byte	0x3
	.byte	0x6f
	.long	0x246
	.uleb128 0x6
	.long	.LASF21
	.byte	0x3
	.byte	0x70
	.long	0x25
	.byte	0
	.uleb128 0x6
	.long	.LASF22
	.byte	0x3
	.byte	0x71
	.long	0x25
	.byte	0x2
	.uleb128 0x6
	.long	.LASF23
	.byte	0x3
	.byte	0x72
	.long	0x45
	.byte	0x4
	.byte	0
	.uleb128 0x5
	.long	.LASF25
	.byte	0x68
	.byte	0x3
	.byte	0x77
	.long	0x391
	.uleb128 0x6
	.long	.LASF26
	.byte	0x3
	.byte	0x7c
	.long	0x57
	.byte	0
	.uleb128 0x6
	.long	.LASF27
	.byte	0x3
	.byte	0x7d
	.long	0x57
	.byte	0x4
	.uleb128 0x9
	.string	"SS0"
	.byte	0x3
	.byte	0x7e
	.long	0x57
	.byte	0x8
	.uleb128 0x6
	.long	.LASF28
	.byte	0x3
	.byte	0x7f
	.long	0x57
	.byte	0xc
	.uleb128 0x9
	.string	"SS1"
	.byte	0x3
	.byte	0x80
	.long	0x57
	.byte	0x10
	.uleb128 0x6
	.long	.LASF29
	.byte	0x3
	.byte	0x81
	.long	0x57
	.byte	0x14
	.uleb128 0x9
	.string	"SS2"
	.byte	0x3
	.byte	0x82
	.long	0x57
	.byte	0x18
	.uleb128 0x9
	.string	"CR3"
	.byte	0x3
	.byte	0x83
	.long	0x57
	.byte	0x1c
	.uleb128 0x9
	.string	"ES"
	.byte	0x3
	.byte	0x84
	.long	0x57
	.byte	0x20
	.uleb128 0x9
	.string	"FS"
	.byte	0x3
	.byte	0x87
	.long	0x57
	.byte	0x24
	.uleb128 0x9
	.string	"EDI"
	.byte	0x3
	.byte	0x89
	.long	0x57
	.byte	0x28
	.uleb128 0x9
	.string	"ESI"
	.byte	0x3
	.byte	0x8a
	.long	0x57
	.byte	0x2c
	.uleb128 0x9
	.string	"EBP"
	.byte	0x3
	.byte	0x8b
	.long	0x57
	.byte	0x30
	.uleb128 0x9
	.string	"DS"
	.byte	0x3
	.byte	0x8d
	.long	0x57
	.byte	0x34
	.uleb128 0x9
	.string	"EBX"
	.byte	0x3
	.byte	0x8e
	.long	0x57
	.byte	0x38
	.uleb128 0x9
	.string	"EDX"
	.byte	0x3
	.byte	0x8f
	.long	0x57
	.byte	0x3c
	.uleb128 0x9
	.string	"ECX"
	.byte	0x3
	.byte	0x90
	.long	0x57
	.byte	0x40
	.uleb128 0x9
	.string	"EAX"
	.byte	0x3
	.byte	0x91
	.long	0x57
	.byte	0x44
	.uleb128 0x9
	.string	"EIP"
	.byte	0x3
	.byte	0x93
	.long	0x57
	.byte	0x48
	.uleb128 0x9
	.string	"CS"
	.byte	0x3
	.byte	0x94
	.long	0x57
	.byte	0x4c
	.uleb128 0x6
	.long	.LASF30
	.byte	0x3
	.byte	0x95
	.long	0x57
	.byte	0x50
	.uleb128 0x9
	.string	"ESP"
	.byte	0x3
	.byte	0x96
	.long	0x57
	.byte	0x54
	.uleb128 0x9
	.string	"SS"
	.byte	0x3
	.byte	0x97
	.long	0x57
	.byte	0x58
	.uleb128 0x9
	.string	"GS"
	.byte	0x3
	.byte	0x98
	.long	0x57
	.byte	0x5c
	.uleb128 0x9
	.string	"LDT"
	.byte	0x3
	.byte	0x99
	.long	0x57
	.byte	0x60
	.uleb128 0x6
	.long	.LASF31
	.byte	0x3
	.byte	0x9a
	.long	0x25
	.byte	0x64
	.uleb128 0x6
	.long	.LASF32
	.byte	0x3
	.byte	0x9b
	.long	0x25
	.byte	0x66
	.byte	0
	.uleb128 0x5
	.long	.LASF33
	.byte	0x4
	.byte	0x3
	.byte	0xc0
	.long	0x43b
	.uleb128 0x7
	.string	"P"
	.byte	0x3
	.byte	0xc1
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xf
	.byte	0
	.uleb128 0x7
	.string	"RW"
	.byte	0x3
	.byte	0xc2
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xe
	.byte	0
	.uleb128 0x7
	.string	"US"
	.byte	0x3
	.byte	0xc3
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xd
	.byte	0
	.uleb128 0x7
	.string	"PWT"
	.byte	0x3
	.byte	0xc4
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xc
	.byte	0
	.uleb128 0x7
	.string	"PCD"
	.byte	0x3
	.byte	0xc5
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xb
	.byte	0
	.uleb128 0x7
	.string	"A"
	.byte	0x3
	.byte	0xc6
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xa
	.byte	0
	.uleb128 0x8
	.long	.LASF12
	.byte	0x3
	.byte	0xc7
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x9
	.byte	0
	.uleb128 0x8
	.long	.LASF34
	.byte	0x3
	.byte	0xc8
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x8
	.byte	0
	.uleb128 0x7
	.string	"G"
	.byte	0x3
	.byte	0xc9
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x7
	.byte	0
	.uleb128 0x7
	.string	"AVL"
	.byte	0x3
	.byte	0xca
	.long	0x25
	.byte	0x2
	.byte	0x3
	.byte	0x4
	.byte	0
	.uleb128 0x8
	.long	.LASF35
	.byte	0x3
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
	.byte	0x3
	.byte	0xce
	.long	0x4e3
	.uleb128 0x7
	.string	"P"
	.byte	0x3
	.byte	0xcf
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xf
	.byte	0
	.uleb128 0x7
	.string	"RW"
	.byte	0x3
	.byte	0xd0
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xe
	.byte	0
	.uleb128 0x7
	.string	"US"
	.byte	0x3
	.byte	0xd1
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xd
	.byte	0
	.uleb128 0x7
	.string	"PWT"
	.byte	0x3
	.byte	0xd2
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xc
	.byte	0
	.uleb128 0x7
	.string	"PCD"
	.byte	0x3
	.byte	0xd3
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xb
	.byte	0
	.uleb128 0x7
	.string	"A"
	.byte	0x3
	.byte	0xd4
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0xa
	.byte	0
	.uleb128 0x7
	.string	"D"
	.byte	0x3
	.byte	0xd5
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x9
	.byte	0
	.uleb128 0x8
	.long	.LASF12
	.byte	0x3
	.byte	0xd6
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x8
	.byte	0
	.uleb128 0x7
	.string	"G"
	.byte	0x3
	.byte	0xd7
	.long	0x25
	.byte	0x2
	.byte	0x1
	.byte	0x7
	.byte	0
	.uleb128 0x7
	.string	"AVL"
	.byte	0x3
	.byte	0xd8
	.long	0x25
	.byte	0x2
	.byte	0x3
	.byte	0x4
	.byte	0
	.uleb128 0x8
	.long	.LASF35
	.byte	0x3
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
	.byte	0x3
	.byte	0xdb
	.long	0x5c8
	.uleb128 0x9
	.string	"PID"
	.byte	0x3
	.byte	0xdc
	.long	0x57
	.byte	0
	.uleb128 0x6
	.long	.LASF38
	.byte	0x3
	.byte	0xdd
	.long	0x57
	.byte	0x4
	.uleb128 0x6
	.long	.LASF39
	.byte	0x3
	.byte	0xde
	.long	0x25
	.byte	0x8
	.uleb128 0x6
	.long	.LASF40
	.byte	0x3
	.byte	0xdf
	.long	0x25
	.byte	0xa
	.uleb128 0x6
	.long	.LASF41
	.byte	0x3
	.byte	0xe0
	.long	0x25
	.byte	0xc
	.uleb128 0x6
	.long	.LASF42
	.byte	0x3
	.byte	0xe1
	.long	0x45
	.byte	0xe
	.uleb128 0x6
	.long	.LASF43
	.byte	0x3
	.byte	0xe2
	.long	0x45
	.byte	0xf
	.uleb128 0x6
	.long	.LASF44
	.byte	0x3
	.byte	0xe3
	.long	0x45
	.byte	0x10
	.uleb128 0x6
	.long	.LASF45
	.byte	0x3
	.byte	0xe4
	.long	0x45
	.byte	0x11
	.uleb128 0x9
	.string	"TSS"
	.byte	0x3
	.byte	0xe6
	.long	0x246
	.byte	0x14
	.uleb128 0x6
	.long	.LASF46
	.byte	0x3
	.byte	0xe8
	.long	0x5c8
	.byte	0x7c
	.uleb128 0x6
	.long	.LASF47
	.byte	0x3
	.byte	0xe9
	.long	0x391
	.byte	0x80
	.uleb128 0x6
	.long	.LASF48
	.byte	0x3
	.byte	0xea
	.long	0x43b
	.byte	0x84
	.uleb128 0x6
	.long	.LASF49
	.byte	0x3
	.byte	0xeb
	.long	0x57
	.byte	0x88
	.uleb128 0x6
	.long	.LASF50
	.byte	0x3
	.byte	0xec
	.long	0x57
	.byte	0x8c
	.uleb128 0x6
	.long	.LASF51
	.byte	0x3
	.byte	0xed
	.long	0x25
	.byte	0x90
	.uleb128 0x6
	.long	.LASF52
	.byte	0x3
	.byte	0xee
	.long	0x25
	.byte	0x92
	.uleb128 0x6
	.long	.LASF53
	.byte	0x3
	.byte	0xef
	.long	0x57
	.byte	0x94
	.byte	0
	.uleb128 0xa
	.byte	0x4
	.long	0x246
	.uleb128 0x2
	.long	.LASF54
	.byte	0x4
	.byte	0x28
	.long	0x5d9
	.uleb128 0xb
	.byte	0x4
	.long	.LASF143
	.long	0x5e3
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.long	.LASF55
	.uleb128 0x2
	.long	.LASF56
	.byte	0x4
	.byte	0x62
	.long	0x5ce
	.uleb128 0xc
	.long	.LASF59
	.byte	0x1
	.byte	0x10
	.long	.LFB0
	.long	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.long	0x62e
	.uleb128 0xd
	.long	.LASF57
	.byte	0x1
	.byte	0x11
	.long	0x57
	.uleb128 0xd
	.long	.LASF58
	.byte	0x1
	.byte	0x12
	.long	0x57
	.uleb128 0xe
	.long	.LASF63
	.byte	0x1
	.byte	0x2a
	.long	0x69
	.uleb128 0xf
	.byte	0
	.byte	0
	.uleb128 0x10
	.long	.LASF60
	.byte	0x1
	.byte	0x3d
	.long	.LFB1
	.long	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.long	0x685
	.uleb128 0x11
	.string	"s"
	.byte	0x1
	.byte	0x3d
	.long	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x11
	.string	"o"
	.byte	0x1
	.byte	0x3d
	.long	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x12
	.long	.LASF23
	.byte	0x1
	.byte	0x3d
	.long	0x685
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.uleb128 0x12
	.long	.LASF22
	.byte	0x1
	.byte	0x3d
	.long	0x685
	.uleb128 0x2
	.byte	0x91
	.sleb128 12
	.uleb128 0x13
	.string	"t1"
	.byte	0x1
	.byte	0x43
	.long	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -10
	.byte	0
	.uleb128 0xa
	.byte	0x4
	.long	0x25
	.uleb128 0xc
	.long	.LASF61
	.byte	0x1
	.byte	0x4e
	.long	.LFB2
	.long	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.long	0x6bc
	.uleb128 0x14
	.long	.LASF62
	.byte	0x1
	.byte	0x50
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xe
	.long	.LASF64
	.byte	0x1
	.byte	0x53
	.long	0x69
	.uleb128 0xf
	.byte	0
	.byte	0
	.uleb128 0xc
	.long	.LASF65
	.byte	0x1
	.byte	0x8a
	.long	.LFB3
	.long	.LFE3-.LFB3
	.uleb128 0x1
	.byte	0x9c
	.long	0x6df
	.uleb128 0xe
	.long	.LASF66
	.byte	0x1
	.byte	0xc0
	.long	0x69
	.uleb128 0xf
	.byte	0
	.byte	0
	.uleb128 0xc
	.long	.LASF67
	.byte	0x2
	.byte	0x21
	.long	.LFB4
	.long	.LFE4-.LFB4
	.uleb128 0x1
	.byte	0x9c
	.long	0x702
	.uleb128 0xe
	.long	.LASF68
	.byte	0x2
	.byte	0x25
	.long	0x69
	.uleb128 0xf
	.byte	0
	.byte	0
	.uleb128 0xc
	.long	.LASF69
	.byte	0x2
	.byte	0x2f
	.long	.LFB5
	.long	.LFE5-.LFB5
	.uleb128 0x1
	.byte	0x9c
	.long	0x72f
	.uleb128 0x15
	.long	.LBB2
	.long	.LBE2-.LBB2
	.uleb128 0xe
	.long	.LASF68
	.byte	0x2
	.byte	0x25
	.long	0x69
	.uleb128 0xf
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0xc
	.long	.LASF70
	.byte	0x2
	.byte	0x45
	.long	.LFB6
	.long	.LFE6-.LFB6
	.uleb128 0x1
	.byte	0x9c
	.long	0x752
	.uleb128 0xe
	.long	.LASF68
	.byte	0x2
	.byte	0x25
	.long	0x69
	.uleb128 0xf
	.byte	0
	.byte	0
	.uleb128 0xc
	.long	.LASF71
	.byte	0x2
	.byte	0x58
	.long	.LFB7
	.long	.LFE7-.LFB7
	.uleb128 0x1
	.byte	0x9c
	.long	0x775
	.uleb128 0xe
	.long	.LASF68
	.byte	0x2
	.byte	0x25
	.long	0x69
	.uleb128 0xf
	.byte	0
	.byte	0
	.uleb128 0xc
	.long	.LASF72
	.byte	0x2
	.byte	0x6d
	.long	.LFB8
	.long	.LFE8-.LFB8
	.uleb128 0x1
	.byte	0x9c
	.long	0x798
	.uleb128 0xe
	.long	.LASF68
	.byte	0x2
	.byte	0x25
	.long	0x69
	.uleb128 0xf
	.byte	0
	.byte	0
	.uleb128 0xc
	.long	.LASF73
	.byte	0x2
	.byte	0x82
	.long	.LFB9
	.long	.LFE9-.LFB9
	.uleb128 0x1
	.byte	0x9c
	.long	0x7bb
	.uleb128 0xe
	.long	.LASF68
	.byte	0x2
	.byte	0x25
	.long	0x69
	.uleb128 0xf
	.byte	0
	.byte	0
	.uleb128 0xc
	.long	.LASF74
	.byte	0x2
	.byte	0x97
	.long	.LFB10
	.long	.LFE10-.LFB10
	.uleb128 0x1
	.byte	0x9c
	.long	0x7de
	.uleb128 0xe
	.long	.LASF68
	.byte	0x2
	.byte	0x25
	.long	0x69
	.uleb128 0xf
	.byte	0
	.byte	0
	.uleb128 0xc
	.long	.LASF75
	.byte	0x2
	.byte	0xac
	.long	.LFB11
	.long	.LFE11-.LFB11
	.uleb128 0x1
	.byte	0x9c
	.long	0x801
	.uleb128 0xe
	.long	.LASF68
	.byte	0x2
	.byte	0x25
	.long	0x69
	.uleb128 0xf
	.byte	0
	.byte	0
	.uleb128 0xc
	.long	.LASF76
	.byte	0x2
	.byte	0xc1
	.long	.LFB12
	.long	.LFE12-.LFB12
	.uleb128 0x1
	.byte	0x9c
	.long	0x824
	.uleb128 0xe
	.long	.LASF68
	.byte	0x2
	.byte	0x25
	.long	0x69
	.uleb128 0xf
	.byte	0
	.byte	0
	.uleb128 0xc
	.long	.LASF77
	.byte	0x2
	.byte	0xd7
	.long	.LFB13
	.long	.LFE13-.LFB13
	.uleb128 0x1
	.byte	0x9c
	.long	0x847
	.uleb128 0xe
	.long	.LASF68
	.byte	0x2
	.byte	0x25
	.long	0x69
	.uleb128 0xf
	.byte	0
	.byte	0
	.uleb128 0xc
	.long	.LASF78
	.byte	0x2
	.byte	0xec
	.long	.LFB14
	.long	.LFE14-.LFB14
	.uleb128 0x1
	.byte	0x9c
	.long	0x86a
	.uleb128 0xe
	.long	.LASF68
	.byte	0x2
	.byte	0x25
	.long	0x69
	.uleb128 0xf
	.byte	0
	.byte	0
	.uleb128 0x16
	.long	.LASF79
	.byte	0x2
	.value	0x102
	.long	.LFB15
	.long	.LFE15-.LFB15
	.uleb128 0x1
	.byte	0x9c
	.long	0x8e5
	.uleb128 0x17
	.long	.LASF57
	.byte	0x2
	.value	0x103
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x18
	.long	.LASF64
	.byte	0x1
	.byte	0x53
	.long	0x69
	.long	0x8a0
	.uleb128 0xf
	.byte	0
	.uleb128 0x19
	.long	.LASF80
	.byte	0x2
	.value	0x10d
	.long	0x69
	.long	0x8b2
	.uleb128 0xf
	.byte	0
	.uleb128 0x19
	.long	.LASF81
	.byte	0x2
	.value	0x12b
	.long	0x69
	.long	0x8c4
	.uleb128 0xf
	.byte	0
	.uleb128 0x19
	.long	.LASF82
	.byte	0x2
	.value	0x12c
	.long	0x69
	.long	0x8d6
	.uleb128 0xf
	.byte	0
	.uleb128 0x1a
	.long	.LASF83
	.byte	0x2
	.value	0x13a
	.long	0x69
	.uleb128 0xf
	.byte	0
	.byte	0
	.uleb128 0x1b
	.long	.LASF84
	.byte	0x2
	.value	0x14c
	.long	.LFB16
	.long	.LFE16-.LFB16
	.uleb128 0x1
	.byte	0x9c
	.long	0x918
	.uleb128 0x1c
	.string	"c"
	.byte	0x2
	.value	0x14c
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x17
	.long	.LASF62
	.byte	0x2
	.value	0x14d
	.long	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -14
	.byte	0
	.uleb128 0xa
	.byte	0x4
	.long	0x45
	.uleb128 0x1d
	.long	.LASF85
	.byte	0x2
	.value	0x169
	.long	.LFB17
	.long	.LFE17-.LFB17
	.uleb128 0x1
	.byte	0x9c
	.long	0xaf2
	.uleb128 0x1e
	.long	.LASF86
	.byte	0x2
	.value	0x169
	.long	0x918
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xf
	.uleb128 0x1f
	.long	.LASF89
	.byte	0x2
	.value	0x16b
	.long	0x45
	.long	.LFB18
	.long	.LFE18-.LFB18
	.uleb128 0x1
	.byte	0x9c
	.long	0x9d3
	.uleb128 0x1e
	.long	.LASF87
	.byte	0x2
	.value	0x16b
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x1c
	.string	"str"
	.byte	0x2
	.value	0x16b
	.long	0x918
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x17
	.long	.LASF62
	.byte	0x2
	.value	0x16c
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -9
	.uleb128 0x17
	.long	.LASF57
	.byte	0x2
	.value	0x16d
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.uleb128 0x17
	.long	.LASF88
	.byte	0x2
	.value	0x16e
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x20
	.string	"len"
	.byte	0x2
	.value	0x16f
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -21
	.uleb128 0x20
	.string	"c"
	.byte	0x2
	.value	0x170
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -23
	.uleb128 0x20
	.string	"z"
	.byte	0x2
	.value	0x171
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -22
	.byte	0
	.uleb128 0x1f
	.long	.LASF90
	.byte	0x2
	.value	0x183
	.long	0x45
	.long	.LFB19
	.long	.LFE19-.LFB19
	.uleb128 0x1
	.byte	0x9c
	.long	0xa62
	.uleb128 0x1e
	.long	.LASF87
	.byte	0x2
	.value	0x183
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x1c
	.string	"Hex"
	.byte	0x2
	.value	0x183
	.long	0x918
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x17
	.long	.LASF62
	.byte	0x2
	.value	0x184
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -9
	.uleb128 0x17
	.long	.LASF57
	.byte	0x2
	.value	0x185
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.uleb128 0x17
	.long	.LASF88
	.byte	0x2
	.value	0x186
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x20
	.string	"len"
	.byte	0x2
	.value	0x187
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -21
	.uleb128 0x20
	.string	"c"
	.byte	0x2
	.value	0x188
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -23
	.uleb128 0x20
	.string	"z"
	.byte	0x2
	.value	0x189
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -22
	.byte	0
	.uleb128 0x17
	.long	.LASF91
	.byte	0x2
	.value	0x1b0
	.long	0x5ea
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x17
	.long	.LASF62
	.byte	0x2
	.value	0x1b1
	.long	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -18
	.uleb128 0x17
	.long	.LASF57
	.byte	0x2
	.value	0x1b1
	.long	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x17
	.long	.LASF92
	.byte	0x2
	.value	0x1b2
	.long	0xaf2
	.uleb128 0x2
	.byte	0x91
	.sleb128 -51
	.uleb128 0x17
	.long	.LASF93
	.byte	0x2
	.value	0x1b3
	.long	0x918
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0x17
	.long	.LASF94
	.byte	0x2
	.value	0x1b4
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -29
	.uleb128 0x17
	.long	.LASF95
	.byte	0x2
	.value	0x1b5
	.long	0x45
	.uleb128 0x2
	.byte	0x91
	.sleb128 -21
	.uleb128 0x17
	.long	.LASF96
	.byte	0x2
	.value	0x1b6
	.long	0x57
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x15
	.long	.LBB3
	.long	.LBE3-.LBB3
	.uleb128 0xe
	.long	.LASF68
	.byte	0x2
	.byte	0x25
	.long	0x69
	.uleb128 0xf
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x21
	.long	0x45
	.long	0xb02
	.uleb128 0x22
	.long	0xb02
	.byte	0xa
	.byte	0
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.long	.LASF97
	.uleb128 0xc
	.long	.LASF66
	.byte	0x1
	.byte	0xc5
	.long	.LFB20
	.long	.LFE20-.LFB20
	.uleb128 0x1
	.byte	0x9c
	.long	0xb90
	.uleb128 0x14
	.long	.LASF62
	.byte	0x1
	.byte	0xc6
	.long	0xb90
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x18
	.long	.LASF98
	.byte	0x1
	.byte	0xc7
	.long	0x69
	.long	0xb3d
	.uleb128 0xf
	.byte	0
	.uleb128 0x18
	.long	.LASF99
	.byte	0x1
	.byte	0xc9
	.long	0x69
	.long	0xb4e
	.uleb128 0xf
	.byte	0
	.uleb128 0x18
	.long	.LASF100
	.byte	0x1
	.byte	0xca
	.long	0x69
	.long	0xb5f
	.uleb128 0xf
	.byte	0
	.uleb128 0x18
	.long	.LASF101
	.byte	0x1
	.byte	0xcd
	.long	0x69
	.long	0xb70
	.uleb128 0xf
	.byte	0
	.uleb128 0x19
	.long	.LASF83
	.byte	0x2
	.value	0x13a
	.long	0x69
	.long	0xb82
	.uleb128 0xf
	.byte	0
	.uleb128 0xe
	.long	.LASF102
	.byte	0x1
	.byte	0xdc
	.long	0x69
	.uleb128 0xf
	.byte	0
	.byte	0
	.uleb128 0xa
	.byte	0x4
	.long	0x391
	.uleb128 0x23
	.string	"PTE"
	.byte	0x3
	.byte	0xda
	.long	0x43b
	.uleb128 0x5
	.byte	0x3
	.long	PTE
	.uleb128 0x21
	.long	0x70
	.long	0xbb7
	.uleb128 0x22
	.long	0xb02
	.byte	0xff
	.byte	0
	.uleb128 0x24
	.long	.LASF103
	.byte	0x3
	.byte	0xf5
	.long	0xba7
	.uleb128 0x21
	.long	0x153
	.long	0xbd2
	.uleb128 0x22
	.long	0xb02
	.byte	0xff
	.byte	0
	.uleb128 0x24
	.long	.LASF104
	.byte	0x3
	.byte	0xf6
	.long	0xbc2
	.uleb128 0x24
	.long	.LASF105
	.byte	0x3
	.byte	0xf7
	.long	0x1e4
	.uleb128 0x24
	.long	.LASF106
	.byte	0x3
	.byte	0xf8
	.long	0x215
	.uleb128 0x24
	.long	.LASF107
	.byte	0x3
	.byte	0xf9
	.long	0x5c8
	.uleb128 0x24
	.long	.LASF108
	.byte	0x3
	.byte	0xfa
	.long	0xc09
	.uleb128 0x25
	.long	0x246
	.uleb128 0x24
	.long	.LASF109
	.byte	0x3
	.byte	0xfe
	.long	0xc19
	.uleb128 0x25
	.long	0x391
	.uleb128 0x21
	.long	0x43b
	.long	0xc2f
	.uleb128 0x26
	.long	0xb02
	.value	0x1ff
	.byte	0
	.uleb128 0x24
	.long	.LASF110
	.byte	0x3
	.byte	0xff
	.long	0xc3a
	.uleb128 0x25
	.long	0xc1e
	.uleb128 0x27
	.long	.LASF111
	.byte	0x3
	.value	0x103
	.long	0x25
	.uleb128 0x21
	.long	0x4e3
	.long	0xc5b
	.uleb128 0x22
	.long	0xb02
	.byte	0x9
	.byte	0
	.uleb128 0x27
	.long	.LASF112
	.byte	0x3
	.value	0x107
	.long	0xc4b
	.uleb128 0x27
	.long	.LASF113
	.byte	0x3
	.value	0x10a
	.long	0x57
	.uleb128 0x27
	.long	.LASF114
	.byte	0x3
	.value	0x115
	.long	0xc7f
	.uleb128 0x25
	.long	0x25
	.uleb128 0x27
	.long	.LASF115
	.byte	0x3
	.value	0x118
	.long	0x25
	.uleb128 0x27
	.long	.LASF116
	.byte	0x3
	.value	0x119
	.long	0x25
	.uleb128 0x27
	.long	.LASF117
	.byte	0x3
	.value	0x11a
	.long	0xca8
	.uleb128 0x25
	.long	0x57
	.uleb128 0x27
	.long	.LASF118
	.byte	0x3
	.value	0x11b
	.long	0xca8
	.uleb128 0x27
	.long	.LASF119
	.byte	0x3
	.value	0x124
	.long	0x45
	.uleb128 0x27
	.long	.LASF120
	.byte	0x3
	.value	0x125
	.long	0x45
	.uleb128 0x27
	.long	.LASF121
	.byte	0x3
	.value	0x126
	.long	0x45
	.uleb128 0x27
	.long	.LASF122
	.byte	0x3
	.value	0x137
	.long	0xc19
	.uleb128 0x27
	.long	.LASF123
	.byte	0x3
	.value	0x138
	.long	0xcf5
	.uleb128 0x25
	.long	0x43b
	.uleb128 0x28
	.long	.LASF62
	.byte	0x1
	.byte	0x85
	.long	0x25
	.uleb128 0x5
	.byte	0x3
	.long	temp
	.uleb128 0x28
	.long	.LASF57
	.byte	0x1
	.byte	0x86
	.long	0x57
	.uleb128 0x5
	.byte	0x3
	.long	temp2
	.uleb128 0x28
	.long	.LASF124
	.byte	0x2
	.byte	0xd
	.long	0x45
	.uleb128 0x5
	.byte	0x3
	.long	NextTask
	.uleb128 0x28
	.long	.LASF125
	.byte	0x2
	.byte	0xe
	.long	0x45
	.uleb128 0x5
	.byte	0x3
	.long	temp10
	.uleb128 0x28
	.long	.LASF126
	.byte	0x2
	.byte	0xf
	.long	0x246
	.uleb128 0x5
	.byte	0x3
	.long	TaskTSS
	.uleb128 0x28
	.long	.LASF127
	.byte	0x2
	.byte	0x10
	.long	0x246
	.uleb128 0x5
	.byte	0x3
	.long	TaskTSS0
	.uleb128 0x28
	.long	.LASF128
	.byte	0x2
	.byte	0x11
	.long	0x246
	.uleb128 0x5
	.byte	0x3
	.long	TaskTSS1
	.uleb128 0x28
	.long	.LASF129
	.byte	0x2
	.byte	0x12
	.long	0x246
	.uleb128 0x5
	.byte	0x3
	.long	TaskTSS2
	.uleb128 0x21
	.long	0x45
	.long	0xd93
	.uleb128 0x26
	.long	0xb02
	.value	0xfffe
	.byte	0
	.uleb128 0x28
	.long	.LASF130
	.byte	0x2
	.byte	0x13
	.long	0xda4
	.uleb128 0x5
	.byte	0x3
	.long	StackTask0
	.uleb128 0x25
	.long	0xd82
	.uleb128 0x28
	.long	.LASF131
	.byte	0x2
	.byte	0x14
	.long	0xdba
	.uleb128 0x5
	.byte	0x3
	.long	StackTask1
	.uleb128 0x25
	.long	0xd82
	.uleb128 0x28
	.long	.LASF132
	.byte	0x2
	.byte	0x15
	.long	0xdd0
	.uleb128 0x5
	.byte	0x3
	.long	StackTask1SS0
	.uleb128 0x25
	.long	0xd82
	.uleb128 0x28
	.long	.LASF133
	.byte	0x2
	.byte	0x18
	.long	0xde6
	.uleb128 0x5
	.byte	0x3
	.long	StackTask2
	.uleb128 0x25
	.long	0xd82
	.uleb128 0x28
	.long	.LASF134
	.byte	0x2
	.byte	0x19
	.long	0xdfc
	.uleb128 0x5
	.byte	0x3
	.long	StackTask2SS0
	.uleb128 0x25
	.long	0xd82
	.uleb128 0x28
	.long	.LASF135
	.byte	0x2
	.byte	0x1c
	.long	0xe12
	.uleb128 0x5
	.byte	0x3
	.long	StackTask3
	.uleb128 0x25
	.long	0xd82
	.uleb128 0x28
	.long	.LASF136
	.byte	0x2
	.byte	0x1d
	.long	0xe28
	.uleb128 0x5
	.byte	0x3
	.long	StackTask3SS0
	.uleb128 0x25
	.long	0xd82
	.uleb128 0x28
	.long	.LASF137
	.byte	0x2
	.byte	0x1e
	.long	0x57
	.uleb128 0x5
	.byte	0x3
	.long	tempx
	.uleb128 0x29
	.long	.LASF138
	.byte	0x2
	.value	0x146
	.long	0x57
	.uleb128 0x5
	.byte	0x3
	.long	tempxxx
	.uleb128 0x29
	.long	.LASF139
	.byte	0x2
	.value	0x147
	.long	0x57
	.uleb128 0x5
	.byte	0x3
	.long	tempxxx2
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
	.uleb128 0xd
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
	.byte	0
	.byte	0
	.uleb128 0xe
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
	.uleb128 0xf
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x10
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
	.uleb128 0x11
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
	.uleb128 0x12
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
	.uleb128 0x13
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
	.uleb128 0x14
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
	.uleb128 0x15
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
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
	.uleb128 0x17
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
	.uleb128 0x2
	.uleb128 0x18
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
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x19
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1a
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x1b
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
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
	.uleb128 0x1c
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x1d
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
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
	.uleb128 0x1e
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x1f
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
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
	.uleb128 0x20
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x21
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x22
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x23
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
	.uleb128 0x24
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
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x25
	.uleb128 0x35
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x26
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0x5
	.byte	0
	.byte	0
	.uleb128 0x27
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
	.uleb128 0x28
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
	.uleb128 0x29
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
.LASF35:
	.string	"Base"
.LASF87:
	.string	"value"
.LASF131:
	.string	"StackTask1"
.LASF137:
	.string	"tempx"
.LASF80:
	.string	"AddToProcessList"
.LASF15:
	.string	"_IDTS"
.LASF51:
	.string	"PDEsN"
.LASF130:
	.string	"StackTask0"
.LASF56:
	.string	"va_list"
.LASF112:
	.string	"Tasks"
.LASF85:
	.string	"printf"
.LASF98:
	.string	"ClearScreen"
.LASF31:
	.string	"TRAP"
.LASF86:
	.string	"text"
.LASF120:
	.string	"CurX"
.LASF121:
	.string	"CurY"
.LASF43:
	.string	"TickCount"
.LASF138:
	.string	"tempxxx"
.LASF88:
	.string	"value2"
.LASF2:
	.string	"signed char"
.LASF126:
	.string	"TaskTSS"
.LASF109:
	.string	"KernelPDE"
.LASF106:
	.string	"IDTDescr"
.LASF64:
	.string	"EditGDTEntry"
.LASF34:
	.string	"PageSize"
.LASF118:
	.string	"ActTaskN"
.LASF81:
	.string	"SetClockFrequency"
.LASF107:
	.string	"ActTaskTSS"
.LASF132:
	.string	"StackTask1SS0"
.LASF143:
	.string	"__builtin_va_list"
.LASF50:
	.string	"PDBR"
.LASF89:
	.string	"IntToStr"
.LASF30:
	.string	"EFLAGS"
.LASF60:
	.string	"Log2Phy"
.LASF44:
	.string	"MaxTick"
.LASF14:
	.string	"_GDTS"
.LASF134:
	.string	"StackTask2SS0"
.LASF110:
	.string	"KernelPTEs"
.LASF52:
	.string	"PTEsN"
.LASF102:
	.string	"AllocMemoryWithAttribs"
.LASF38:
	.string	"EntryPoint"
.LASF62:
	.string	"temp"
.LASF49:
	.string	"Next"
.LASF7:
	.string	"unsigned int"
.LASF33:
	.string	"_PDE"
.LASF127:
	.string	"TaskTSS0"
.LASF94:
	.string	"strlen"
.LASF129:
	.string	"TaskTSS2"
.LASF23:
	.string	"AddrH"
.LASF104:
	.string	"IDTS"
.LASF22:
	.string	"AddrL"
.LASF68:
	.string	"SetCurPos"
.LASF95:
	.string	"paramscount"
.LASF37:
	.string	"_Tasks"
.LASF8:
	.string	"Size1"
.LASF140:
	.string	"GNU C 4.9.2 -m32 -mtune=generic -march=i586 -g -O0 -fno-builtin"
.LASF0:
	.string	"short unsigned int"
.LASF105:
	.string	"GDTDescr"
.LASF24:
	.string	"_IDTDescr"
.LASF82:
	.string	"EnableIRQ"
.LASF93:
	.string	"ArgStrP"
.LASF108:
	.string	"KernelTSS"
.LASF117:
	.string	"TasksN"
.LASF39:
	.string	"CodeSegment"
.LASF84:
	.string	"putc"
.LASF11:
	.string	"Size2"
.LASF27:
	.string	"ESP0"
.LASF28:
	.string	"ESP1"
.LASF29:
	.string	"ESP2"
.LASF6:
	.string	"u32int"
.LASF97:
	.string	"sizetype"
.LASF99:
	.string	"kprintOK"
.LASF65:
	.string	"InitKernel"
.LASF12:
	.string	"Zero"
.LASF54:
	.string	"__gnuc_va_list"
.LASF139:
	.string	"tempxxx2"
.LASF41:
	.string	"StackSegment"
.LASF90:
	.string	"IntToHex"
.LASF111:
	.string	"GDTC"
.LASF103:
	.string	"GDTS"
.LASF4:
	.string	"uchar"
.LASF133:
	.string	"StackTask2"
.LASF135:
	.string	"StackTask3"
.LASF47:
	.string	"PDEDefault"
.LASF122:
	.string	"KernelPDEA"
.LASF83:
	.string	"BOCHSDBGprintf"
.LASF115:
	.string	"OldCallStack"
.LASF21:
	.string	"Size"
.LASF114:
	.string	"KernelBase"
.LASF67:
	.string	"KeybIRQ"
.LASF5:
	.string	"unsigned char"
.LASF16:
	.string	"Offset1"
.LASF19:
	.string	"Offset2"
.LASF101:
	.string	"PICInitInPM"
.LASF1:
	.string	"short int"
.LASF17:
	.string	"Selector"
.LASF48:
	.string	"PTEDefault"
.LASF57:
	.string	"temp2"
.LASF58:
	.string	"temp3"
.LASF128:
	.string	"TaskTSS1"
.LASF78:
	.string	"Task10"
.LASF20:
	.string	"_GDTDescr"
.LASF142:
	.string	"/home/wojtek/programowanie/system/i386"
.LASF141:
	.string	"init.c"
.LASF116:
	.string	"CallStack"
.LASF66:
	.string	"InitMain"
.LASF36:
	.string	"_PTE"
.LASF40:
	.string	"DataSegment"
.LASF63:
	.string	"AllocPsyhicalMemory"
.LASF59:
	.string	"EnablePaging"
.LASF55:
	.string	"char"
.LASF45:
	.string	"PrvLevel"
.LASF42:
	.string	"State"
.LASF25:
	.string	"TSSSeg"
.LASF3:
	.string	"u16int"
.LASF32:
	.string	"IOMAP"
.LASF91:
	.string	"parg"
.LASF124:
	.string	"NextTask"
.LASF113:
	.string	"FramesN"
.LASF79:
	.string	"Clock"
.LASF9:
	.string	"Base1"
.LASF10:
	.string	"Base2"
.LASF13:
	.string	"Base3"
.LASF92:
	.string	"ArgStr"
.LASF46:
	.string	"TSSNext"
.LASF71:
	.string	"Task3"
.LASF96:
	.string	"ArgInt"
.LASF125:
	.string	"temp10"
.LASF26:
	.string	"Back"
.LASF119:
	.string	"TextColor"
.LASF61:
	.string	"CreateGDTIDT"
.LASF69:
	.string	"Task1"
.LASF70:
	.string	"Task2"
.LASF72:
	.string	"Task4"
.LASF73:
	.string	"Task5"
.LASF74:
	.string	"Task6"
.LASF75:
	.string	"Task7"
.LASF76:
	.string	"Task8"
.LASF77:
	.string	"Task9"
.LASF100:
	.string	"SetExceptions"
.LASF53:
	.string	"MemSize"
.LASF136:
	.string	"StackTask3SS0"
.LASF123:
	.string	"KernelPTEA"
.LASF18:
	.string	"Zero2"
	.ident	"GCC: (Debian 4.9.2-10) 4.9.2"
	.section	.note.GNU-stack,"",@progbits
