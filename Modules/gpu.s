	.syntax unified
	.arch armv7-a
	.eabi_attribute 27, 3
	.eabi_attribute 28, 1
	.fpu vfpv3-d16
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.thumb
	.file	"gpu.c"
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.comm	virtual_base,4,4
	.comm	h2p_lw_dataA_addr,4,4
	.comm	h2p_lw_dataB_addr,4,4
	.comm	h2p_lw_wrReg_addr,4,4
	.comm	h2p_lw_wrFull_addr,4,4
	.comm	h2p_lw_screen_addr,4,4
	.comm	h2p_lw_result_pulseCounter_addr,4,4
	.comm	fd,4,4
	.section	.rodata
	.align	2
.LC0:
	.ascii	"/dev/mem\000"
	.align	2
.LC1:
	.ascii	"[ERROR]: could not open \"/dev/mem\"...\000"
	.align	2
.LC2:
	.ascii	"[ERROR]: mmap() failed...\000"
	.text
	.align	2
	.global	createMappingMemory
	.thumb
	.thumb_func
	.type	createMappingMemory, %function
createMappingMemory:
.LFB0:
	.file 1 "gpu.c"
	.loc 1 26 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
.LCFI0:
	.cfi_def_cfa_offset 8
	.cfi_offset 14, -4
	.cfi_offset 7, -8
	sub	sp, sp, #8
.LCFI1:
	.cfi_def_cfa_offset 16
	add	r7, sp, #8
.LCFI2:
	.cfi_def_cfa 7, 8
	.loc 1 27 0
	movw	r0, #:lower16:.LC0
	movt	r0, #:upper16:.LC0
	movw	r1, #4098
	movt	r1, 16
	bl	open
	mov	r2, r0
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	str	r2, [r3, #0]
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	ldr	r3, [r3, #0]
	cmp	r3, #-1
	bne	.L2
	.loc 1 28 0
	movw	r0, #:lower16:.LC1
	movt	r0, #:upper16:.LC1
	bl	puts
	.loc 1 29 0
	mov	r3, #-1
	b	.L3
.L2:
	.loc 1 31 0
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	ldr	r3, [r3, #0]
	str	r3, [sp, #0]
	mov	r3, #-67108864
	str	r3, [sp, #4]
	mov	r0, #0
	mov	r1, #67108864
	mov	r2, #3
	mov	r3, #1
	bl	mmap
	mov	r2, r0
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	str	r2, [r3, #0]
	.loc 1 32 0
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	cmp	r3, #-1
	bne	.L4
	.loc 1 33 0
	movw	r0, #:lower16:.LC2
	movt	r0, #:upper16:.LC2
	bl	puts
	.loc 1 34 0
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	ldr	r3, [r3, #0]
	mov	r0, r3
	bl	close
	.loc 1 35 0
	mov	r3, #-1
	b	.L3
.L4:
	.loc 1 37 0
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	add	r2, r3, #52428800
	add	r2, r2, #128
	movw	r3, #:lower16:h2p_lw_dataA_addr
	movt	r3, #:upper16:h2p_lw_dataA_addr
	str	r2, [r3, #0]
	.loc 1 38 0
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	add	r2, r3, #52428800
	add	r2, r2, #112
	movw	r3, #:lower16:h2p_lw_dataB_addr
	movt	r3, #:upper16:h2p_lw_dataB_addr
	str	r2, [r3, #0]
	.loc 1 39 0
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	add	r2, r3, #52428800
	add	r2, r2, #192
	movw	r3, #:lower16:h2p_lw_wrReg_addr
	movt	r3, #:upper16:h2p_lw_wrReg_addr
	str	r2, [r3, #0]
	.loc 1 40 0
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	add	r2, r3, #52428800
	add	r2, r2, #176
	movw	r3, #:lower16:h2p_lw_wrFull_addr
	movt	r3, #:upper16:h2p_lw_wrFull_addr
	str	r2, [r3, #0]
	.loc 1 41 0
	mov	r3, #1
.L3:
	.loc 1 42 0
	mov	r0, r3
	mov	sp, r7
	pop	{r7, pc}
	.cfi_endproc
.LFE0:
	.size	createMappingMemory, .-createMappingMemory
	.section	.rodata
	.align	2
.LC3:
	.ascii	"[ERROR]: munmap() failed...\000"
	.text
	.align	2
	.global	closeMappingMemory
	.thumb
	.thumb_func
	.type	closeMappingMemory, %function
closeMappingMemory:
.LFB1:
	.loc 1 44 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
.LCFI3:
	.cfi_def_cfa_offset 8
	.cfi_offset 14, -4
	.cfi_offset 7, -8
	add	r7, sp, #0
.LCFI4:
	.cfi_def_cfa_register 7
	.loc 1 46 0
	movw	r3, #:lower16:virtual_base
	movt	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	mov	r0, r3
	mov	r1, #67108864
	bl	munmap
	mov	r3, r0
	cmp	r3, #0
	beq	.L5
	.loc 1 47 0
	movw	r0, #:lower16:.LC3
	movt	r0, #:upper16:.LC3
	bl	puts
	.loc 1 48 0
	movw	r3, #:lower16:fd
	movt	r3, #:upper16:fd
	ldr	r3, [r3, #0]
	mov	r0, r3
	bl	close
.L5:
	.loc 1 50 0
	pop	{r7, pc}
	.cfi_endproc
.LFE1:
	.size	closeMappingMemory, .-closeMappingMemory
	.align	2
	.global	isFull
	.thumb
	.thumb_func
	.type	isFull, %function
isFull:
.LFB2:
	.loc 1 55 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
.LCFI5:
	.cfi_def_cfa_offset 4
	.cfi_offset 7, -4
	add	r7, sp, #0
.LCFI6:
	.cfi_def_cfa_register 7
	.loc 1 56 0
	movw	r3, #:lower16:h2p_lw_wrFull_addr
	movt	r3, #:upper16:h2p_lw_wrFull_addr
	ldr	r3, [r3, #0]
	ldr	r3, [r3, #0]
	.loc 1 57 0
	mov	r0, r3
	mov	sp, r7
	pop	{r7}
	bx	lr
	.cfi_endproc
.LFE2:
	.size	isFull, .-isFull
	.align	2
	.global	sendInstruction
	.thumb
	.thumb_func
	.type	sendInstruction, %function
sendInstruction:
.LFB3:
	.loc 1 59 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
.LCFI7:
	.cfi_def_cfa_offset 8
	.cfi_offset 14, -4
	.cfi_offset 7, -8
	sub	sp, sp, #8
.LCFI8:
	.cfi_def_cfa_offset 16
	add	r7, sp, #0
.LCFI9:
	.cfi_def_cfa_register 7
	str	r0, [r7, #4]
	str	r1, [r7, #0]
	.loc 1 60 0
	bl	isFull
	mov	r3, r0
	cmp	r3, #0
	bne	.L8
	.loc 1 61 0
	movw	r3, #:lower16:h2p_lw_wrReg_addr
	movt	r3, #:upper16:h2p_lw_wrReg_addr
	ldr	r3, [r3, #0]
	mov	r2, #0
	str	r2, [r3, #0]
	.loc 1 62 0
	movw	r3, #:lower16:h2p_lw_dataA_addr
	movt	r3, #:upper16:h2p_lw_dataA_addr
	ldr	r3, [r3, #0]
	ldr	r2, [r7, #4]
	str	r2, [r3, #0]
	.loc 1 63 0
	movw	r3, #:lower16:h2p_lw_dataB_addr
	movt	r3, #:upper16:h2p_lw_dataB_addr
	ldr	r3, [r3, #0]
	ldr	r2, [r7, #0]
	str	r2, [r3, #0]
	.loc 1 64 0
	movw	r3, #:lower16:h2p_lw_wrReg_addr
	movt	r3, #:upper16:h2p_lw_wrReg_addr
	ldr	r3, [r3, #0]
	mov	r2, #1
	str	r2, [r3, #0]
	.loc 1 65 0
	movw	r3, #:lower16:h2p_lw_wrReg_addr
	movt	r3, #:upper16:h2p_lw_wrReg_addr
	ldr	r3, [r3, #0]
	mov	r2, #0
	str	r2, [r3, #0]
.L8:
	.loc 1 67 0
	add	r7, r7, #8
	mov	sp, r7
	pop	{r7, pc}
	.cfi_endproc
.LFE3:
	.size	sendInstruction, .-sendInstruction
	.align	2
	.thumb
	.thumb_func
	.type	dataA_builder, %function
dataA_builder:
.LFB4:
	.loc 1 72 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
.LCFI10:
	.cfi_def_cfa_offset 4
	.cfi_offset 7, -4
	sub	sp, sp, #28
.LCFI11:
	.cfi_def_cfa_offset 32
	add	r7, sp, #0
.LCFI12:
	.cfi_def_cfa_register 7
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	str	r2, [r7, #4]
	.loc 1 73 0
	mov	r3, #0
	str	r3, [r7, #20]
	.loc 1 74 0
	ldr	r3, [r7, #12]
	cmp	r3, #0
	beq	.L12
	cmp	r3, #0
	blt	.L11
	cmp	r3, #3
	bgt	.L11
	b	.L14
.L12:
	.loc 1 76 0
	ldr	r3, [r7, #8]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	.loc 1 77 0
	ldr	r3, [r7, #20]
	lsl	r3, r3, #4
	str	r3, [r7, #20]
	.loc 1 78 0
	ldr	r3, [r7, #12]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	.loc 1 79 0
	b	.L11
.L14:
	.loc 1 83 0
	ldr	r3, [r7, #4]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	.loc 1 84 0
	ldr	r3, [r7, #20]
	lsl	r3, r3, #4
	str	r3, [r7, #20]
	.loc 1 85 0
	ldr	r3, [r7, #12]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	.loc 1 86 0
	nop
.L11:
	.loc 1 88 0
	ldr	r3, [r7, #20]
	.loc 1 89 0
	mov	r0, r3
	add	r7, r7, #28
	mov	sp, r7
	pop	{r7}
	bx	lr
	.cfi_endproc
.LFE4:
	.size	dataA_builder, .-dataA_builder
	.align	2
	.global	set_background_color
	.thumb
	.thumb_func
	.type	set_background_color, %function
set_background_color:
.LFB5:
	.loc 1 91 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
.LCFI13:
	.cfi_def_cfa_offset 8
	.cfi_offset 14, -4
	.cfi_offset 7, -8
	sub	sp, sp, #24
.LCFI14:
	.cfi_def_cfa_offset 32
	add	r7, sp, #0
.LCFI15:
	.cfi_def_cfa_register 7
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	str	r2, [r7, #4]
	.loc 1 92 0
	mov	r0, #0
	mov	r1, #0
	mov	r2, #0
	bl	dataA_builder
	str	r0, [r7, #16]
	.loc 1 93 0
	ldr	r3, [r7, #4]
	str	r3, [r7, #20]
	.loc 1 94 0
	ldr	r3, [r7, #20]
	lsl	r3, r3, #3
	str	r3, [r7, #20]
	.loc 1 95 0
	ldr	r3, [r7, #8]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	.loc 1 96 0
	ldr	r3, [r7, #20]
	lsl	r3, r3, #3
	str	r3, [r7, #20]
	.loc 1 97 0
	ldr	r3, [r7, #12]
	ldr	r2, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	.loc 1 98 0
	ldr	r0, [r7, #16]
	ldr	r1, [r7, #20]
	bl	sendInstruction
	.loc 1 99 0
	add	r7, r7, #24
	mov	sp, r7
	pop	{r7, pc}
	.cfi_endproc
.LFE5:
	.size	set_background_color, .-set_background_color
	.align	2
	.global	set_background_block
	.thumb
	.thumb_func
	.type	set_background_block, %function
set_background_block:
.LFB6:
	.loc 1 101 0
	.cfi_startproc
	@ args = 4, pretend = 0, frame = 32
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
.LCFI16:
	.cfi_def_cfa_offset 8
	.cfi_offset 14, -4
	.cfi_offset 7, -8
	sub	sp, sp, #32
.LCFI17:
	.cfi_def_cfa_offset 40
	add	r7, sp, #0
.LCFI18:
	.cfi_def_cfa_register 7
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	str	r2, [r7, #4]
	str	r3, [r7, #0]
	.loc 1 102 0
	ldr	r2, [r7, #8]
	mov	r3, r2
	lsl	r3, r3, #2
	adds	r3, r3, r2
	lsl	r3, r3, #4
	mov	r2, r3
	ldr	r3, [r7, #12]
	adds	r3, r2, r3
	str	r3, [r7, #20]
	.loc 1 103 0
	mov	r0, #2
	mov	r1, #0
	ldr	r2, [r7, #20]
	bl	dataA_builder
	str	r0, [r7, #24]
	.loc 1 104 0
	ldr	r3, [r7, #40]
	str	r3, [r7, #28]
	.loc 1 105 0
	ldr	r3, [r7, #28]
	lsl	r3, r3, #3
	str	r3, [r7, #28]
	.loc 1 106 0
	ldr	r3, [r7, #0]
	ldr	r2, [r7, #28]
	orrs	r3, r3, r2
	str	r3, [r7, #28]
	.loc 1 107 0
	ldr	r3, [r7, #28]
	lsl	r3, r3, #3
	str	r3, [r7, #28]
	.loc 1 108 0
	ldr	r3, [r7, #4]
	ldr	r2, [r7, #28]
	orrs	r3, r3, r2
	str	r3, [r7, #28]
	.loc 1 109 0
	ldr	r0, [r7, #24]
	ldr	r1, [r7, #28]
	bl	sendInstruction
	.loc 1 110 0
	add	r7, r7, #32
	mov	sp, r7
	pop	{r7, pc}
	.cfi_endproc
.LFE6:
	.size	set_background_block, .-set_background_block
	.align	2
	.global	waitScreen
	.thumb
	.thumb_func
	.type	waitScreen, %function
waitScreen:
.LFB7:
	.loc 1 112 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
.LCFI19:
	.cfi_def_cfa_offset 4
	.cfi_offset 7, -4
	sub	sp, sp, #20
.LCFI20:
	.cfi_def_cfa_offset 24
	add	r7, sp, #0
.LCFI21:
	.cfi_def_cfa_register 7
	str	r0, [r7, #4]
	.loc 1 113 0
	mov	r3, #0
	str	r3, [r7, #12]
	.loc 1 114 0
	b	.L18
.L19:
	.loc 1 115 0
	movw	r3, #:lower16:h2p_lw_screen_addr
	movt	r3, #:upper16:h2p_lw_screen_addr
	ldr	r3, [r3, #0]
	ldr	r3, [r3, #0]
	cmp	r3, #1
	bne	.L18
	.loc 1 117 0
	ldr	r3, [r7, #12]
	add	r3, r3, #1
	str	r3, [r7, #12]
	.loc 1 118 0
	movw	r3, #:lower16:h2p_lw_result_pulseCounter_addr
	movt	r3, #:upper16:h2p_lw_result_pulseCounter_addr
	ldr	r3, [r3, #0]
	mov	r2, #1
	str	r2, [r3, #0]
	.loc 1 119 0
	movw	r3, #:lower16:h2p_lw_result_pulseCounter_addr
	movt	r3, #:upper16:h2p_lw_result_pulseCounter_addr
	ldr	r3, [r3, #0]
	mov	r2, #0
	str	r2, [r3, #0]
.L18:
	.loc 1 114 0 discriminator 1
	ldr	r2, [r7, #12]
	ldr	r3, [r7, #4]
	cmp	r2, r3
	ble	.L19
	.loc 1 122 0
	add	r7, r7, #20
	mov	sp, r7
	pop	{r7}
	bx	lr
	.cfi_endproc
.LFE7:
	.size	waitScreen, .-waitScreen
.Letext0:
	.file 2 "/usr/include/stdint.h"
	.section	.debug_info,"",%progbits
.Ldebug_info0:
	.4byte	0x2ee
	.2byte	0x2
	.4byte	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.4byte	.LASF34
	.byte	0x1
	.4byte	.LASF35
	.4byte	.LASF36
	.4byte	.Ltext0
	.4byte	.Letext0
	.4byte	.Ldebug_line0
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.4byte	.LASF0
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.4byte	.LASF1
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.4byte	.LASF2
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.4byte	.LASF3
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.4byte	.LASF4
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.4byte	.LASF5
	.uleb128 0x3
	.byte	0x4
	.byte	0x5
	.ascii	"int\000"
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.4byte	.LASF6
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.4byte	.LASF7
	.uleb128 0x2
	.byte	0x4
	.byte	0x5
	.4byte	.LASF8
	.uleb128 0x4
	.byte	0x4
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.4byte	.LASF9
	.uleb128 0x5
	.4byte	.LASF37
	.byte	0x2
	.byte	0x34
	.4byte	0x25
	.uleb128 0x6
	.byte	0x1
	.4byte	.LASF10
	.byte	0x1
	.byte	0x1a
	.4byte	0x4f
	.4byte	.LFB0
	.4byte	.LFE0
	.4byte	.LLST0
	.uleb128 0x7
	.byte	0x1
	.4byte	.LASF38
	.byte	0x1
	.byte	0x2c
	.4byte	.LFB1
	.4byte	.LFE1
	.4byte	.LLST1
	.uleb128 0x6
	.byte	0x1
	.4byte	.LASF11
	.byte	0x1
	.byte	0x37
	.4byte	0x4f
	.4byte	.LFB2
	.4byte	.LFE2
	.4byte	.LLST2
	.uleb128 0x8
	.byte	0x1
	.4byte	.LASF16
	.byte	0x1
	.byte	0x3b
	.byte	0x1
	.4byte	.LFB3
	.4byte	.LFE3
	.4byte	.LLST3
	.4byte	0xf9
	.uleb128 0x9
	.4byte	.LASF12
	.byte	0x1
	.byte	0x3b
	.4byte	0x3a
	.byte	0x2
	.byte	0x91
	.sleb128 -12
	.uleb128 0x9
	.4byte	.LASF13
	.byte	0x1
	.byte	0x3b
	.4byte	0x3a
	.byte	0x2
	.byte	0x91
	.sleb128 -16
	.byte	0
	.uleb128 0xa
	.4byte	.LASF39
	.byte	0x1
	.byte	0x48
	.byte	0x1
	.4byte	0x3a
	.4byte	.LFB4
	.4byte	.LFE4
	.4byte	.LLST4
	.4byte	0x14e
	.uleb128 0x9
	.4byte	.LASF14
	.byte	0x1
	.byte	0x48
	.4byte	0x4f
	.byte	0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xb
	.ascii	"reg\000"
	.byte	0x1
	.byte	0x48
	.4byte	0x4f
	.byte	0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x9
	.4byte	.LASF15
	.byte	0x1
	.byte	0x48
	.4byte	0x4f
	.byte	0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0xc
	.4byte	.LASF18
	.byte	0x1
	.byte	0x49
	.4byte	0x3a
	.byte	0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x8
	.byte	0x1
	.4byte	.LASF17
	.byte	0x1
	.byte	0x5b
	.byte	0x1
	.4byte	.LFB5
	.4byte	.LFE5
	.4byte	.LLST5
	.4byte	0x1a8
	.uleb128 0xb
	.ascii	"R\000"
	.byte	0x1
	.byte	0x5b
	.4byte	0x4f
	.byte	0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xb
	.ascii	"G\000"
	.byte	0x1
	.byte	0x5b
	.4byte	0x4f
	.byte	0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0xb
	.ascii	"B\000"
	.byte	0x1
	.byte	0x5b
	.4byte	0x4f
	.byte	0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0xc
	.4byte	.LASF12
	.byte	0x1
	.byte	0x5c
	.4byte	0x3a
	.byte	0x2
	.byte	0x91
	.sleb128 -16
	.uleb128 0xc
	.4byte	.LASF19
	.byte	0x1
	.byte	0x5d
	.4byte	0x3a
	.byte	0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x8
	.byte	0x1
	.4byte	.LASF20
	.byte	0x1
	.byte	0x65
	.byte	0x1
	.4byte	.LFB6
	.4byte	.LFE6
	.4byte	.LLST6
	.4byte	0x22c
	.uleb128 0x9
	.4byte	.LASF21
	.byte	0x1
	.byte	0x65
	.4byte	0x4f
	.byte	0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x9
	.4byte	.LASF22
	.byte	0x1
	.byte	0x65
	.4byte	0x4f
	.byte	0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0xb
	.ascii	"R\000"
	.byte	0x1
	.byte	0x65
	.4byte	0x4f
	.byte	0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0xb
	.ascii	"G\000"
	.byte	0x1
	.byte	0x65
	.4byte	0x4f
	.byte	0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0xb
	.ascii	"B\000"
	.byte	0x1
	.byte	0x65
	.4byte	0x4f
	.byte	0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xc
	.4byte	.LASF23
	.byte	0x1
	.byte	0x66
	.4byte	0x4f
	.byte	0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xc
	.4byte	.LASF12
	.byte	0x1
	.byte	0x67
	.4byte	0x3a
	.byte	0x2
	.byte	0x91
	.sleb128 -16
	.uleb128 0xc
	.4byte	.LASF19
	.byte	0x1
	.byte	0x68
	.4byte	0x3a
	.byte	0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x8
	.byte	0x1
	.4byte	.LASF24
	.byte	0x1
	.byte	0x70
	.byte	0x1
	.4byte	.LFB7
	.4byte	.LFE7
	.4byte	.LLST7
	.4byte	0x262
	.uleb128 0x9
	.4byte	.LASF25
	.byte	0x1
	.byte	0x70
	.4byte	0x4f
	.byte	0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xc
	.4byte	.LASF26
	.byte	0x1
	.byte	0x71
	.4byte	0x4f
	.byte	0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0xd
	.4byte	.LASF27
	.byte	0x1
	.byte	0x11
	.4byte	0x6b
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	virtual_base
	.uleb128 0xd
	.4byte	.LASF28
	.byte	0x1
	.byte	0x12
	.4byte	0x6b
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	h2p_lw_dataA_addr
	.uleb128 0xd
	.4byte	.LASF29
	.byte	0x1
	.byte	0x13
	.4byte	0x6b
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	h2p_lw_dataB_addr
	.uleb128 0xd
	.4byte	.LASF30
	.byte	0x1
	.byte	0x14
	.4byte	0x6b
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	h2p_lw_wrReg_addr
	.uleb128 0xd
	.4byte	.LASF31
	.byte	0x1
	.byte	0x15
	.4byte	0x6b
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	h2p_lw_wrFull_addr
	.uleb128 0xd
	.4byte	.LASF32
	.byte	0x1
	.byte	0x16
	.4byte	0x6b
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	h2p_lw_screen_addr
	.uleb128 0xd
	.4byte	.LASF33
	.byte	0x1
	.byte	0x17
	.4byte	0x6b
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	h2p_lw_result_pulseCounter_addr
	.uleb128 0xe
	.ascii	"fd\000"
	.byte	0x1
	.byte	0x18
	.4byte	0x4f
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	fd
	.byte	0
	.section	.debug_abbrev,"",%progbits
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
	.uleb128 0x1
	.uleb128 0x10
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x2
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
	.uleb128 0x3
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
	.uleb128 0x4
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x5
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
	.uleb128 0x6
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
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
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
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
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0xc
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
	.uleb128 0xa
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
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x2
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0xe
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
	.uleb128 0xc
	.uleb128 0x2
	.uleb128 0xa
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loc,"",%progbits
.Ldebug_loc0:
.LLST0:
	.4byte	.LFB0-.Ltext0
	.4byte	.LCFI0-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI0-.Ltext0
	.4byte	.LCFI1-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 8
	.4byte	.LCFI1-.Ltext0
	.4byte	.LCFI2-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 16
	.4byte	.LCFI2-.Ltext0
	.4byte	.LFE0-.Ltext0
	.2byte	0x2
	.byte	0x77
	.sleb128 8
	.4byte	0
	.4byte	0
.LLST1:
	.4byte	.LFB1-.Ltext0
	.4byte	.LCFI3-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI3-.Ltext0
	.4byte	.LCFI4-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 8
	.4byte	.LCFI4-.Ltext0
	.4byte	.LFE1-.Ltext0
	.2byte	0x2
	.byte	0x77
	.sleb128 8
	.4byte	0
	.4byte	0
.LLST2:
	.4byte	.LFB2-.Ltext0
	.4byte	.LCFI5-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI5-.Ltext0
	.4byte	.LCFI6-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 4
	.4byte	.LCFI6-.Ltext0
	.4byte	.LFE2-.Ltext0
	.2byte	0x2
	.byte	0x77
	.sleb128 4
	.4byte	0
	.4byte	0
.LLST3:
	.4byte	.LFB3-.Ltext0
	.4byte	.LCFI7-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI7-.Ltext0
	.4byte	.LCFI8-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 8
	.4byte	.LCFI8-.Ltext0
	.4byte	.LCFI9-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 16
	.4byte	.LCFI9-.Ltext0
	.4byte	.LFE3-.Ltext0
	.2byte	0x2
	.byte	0x77
	.sleb128 16
	.4byte	0
	.4byte	0
.LLST4:
	.4byte	.LFB4-.Ltext0
	.4byte	.LCFI10-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI10-.Ltext0
	.4byte	.LCFI11-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 4
	.4byte	.LCFI11-.Ltext0
	.4byte	.LCFI12-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 32
	.4byte	.LCFI12-.Ltext0
	.4byte	.LFE4-.Ltext0
	.2byte	0x2
	.byte	0x77
	.sleb128 32
	.4byte	0
	.4byte	0
.LLST5:
	.4byte	.LFB5-.Ltext0
	.4byte	.LCFI13-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI13-.Ltext0
	.4byte	.LCFI14-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 8
	.4byte	.LCFI14-.Ltext0
	.4byte	.LCFI15-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 32
	.4byte	.LCFI15-.Ltext0
	.4byte	.LFE5-.Ltext0
	.2byte	0x2
	.byte	0x77
	.sleb128 32
	.4byte	0
	.4byte	0
.LLST6:
	.4byte	.LFB6-.Ltext0
	.4byte	.LCFI16-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI16-.Ltext0
	.4byte	.LCFI17-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 8
	.4byte	.LCFI17-.Ltext0
	.4byte	.LCFI18-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 40
	.4byte	.LCFI18-.Ltext0
	.4byte	.LFE6-.Ltext0
	.2byte	0x2
	.byte	0x77
	.sleb128 40
	.4byte	0
	.4byte	0
.LLST7:
	.4byte	.LFB7-.Ltext0
	.4byte	.LCFI19-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI19-.Ltext0
	.4byte	.LCFI20-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 4
	.4byte	.LCFI20-.Ltext0
	.4byte	.LCFI21-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 24
	.4byte	.LCFI21-.Ltext0
	.4byte	.LFE7-.Ltext0
	.2byte	0x2
	.byte	0x77
	.sleb128 24
	.4byte	0
	.4byte	0
	.section	.debug_aranges,"",%progbits
	.4byte	0x1c
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x4
	.byte	0
	.2byte	0
	.2byte	0
	.4byte	.Ltext0
	.4byte	.Letext0-.Ltext0
	.4byte	0
	.4byte	0
	.section	.debug_line,"",%progbits
.Ldebug_line0:
	.section	.debug_str,"MS",%progbits,1
.LASF17:
	.ascii	"set_background_color\000"
.LASF15:
	.ascii	"memory_address\000"
.LASF32:
	.ascii	"h2p_lw_screen_addr\000"
.LASF38:
	.ascii	"closeMappingMemory\000"
.LASF36:
	.ascii	"/home/aluno/TEC499/TP01/G02/recente/Modules\000"
.LASF11:
	.ascii	"isFull\000"
.LASF29:
	.ascii	"h2p_lw_dataB_addr\000"
.LASF18:
	.ascii	"data\000"
.LASF1:
	.ascii	"unsigned char\000"
.LASF10:
	.ascii	"createMappingMemory\000"
.LASF3:
	.ascii	"long unsigned int\000"
.LASF21:
	.ascii	"column\000"
.LASF39:
	.ascii	"dataA_builder\000"
.LASF35:
	.ascii	"gpu.c\000"
.LASF16:
	.ascii	"sendInstruction\000"
.LASF34:
	.ascii	"GNU C 4.6.3\000"
.LASF30:
	.ascii	"h2p_lw_wrReg_addr\000"
.LASF19:
	.ascii	"color\000"
.LASF33:
	.ascii	"h2p_lw_result_pulseCounter_addr\000"
.LASF14:
	.ascii	"opcode\000"
.LASF0:
	.ascii	"unsigned int\000"
.LASF23:
	.ascii	"address\000"
.LASF7:
	.ascii	"long long unsigned int\000"
.LASF22:
	.ascii	"line\000"
.LASF25:
	.ascii	"limit\000"
.LASF24:
	.ascii	"waitScreen\000"
.LASF12:
	.ascii	"dataA\000"
.LASF2:
	.ascii	"short unsigned int\000"
.LASF6:
	.ascii	"long long int\000"
.LASF9:
	.ascii	"char\000"
.LASF31:
	.ascii	"h2p_lw_wrFull_addr\000"
.LASF13:
	.ascii	"dataB\000"
.LASF5:
	.ascii	"short int\000"
.LASF20:
	.ascii	"set_background_block\000"
.LASF26:
	.ascii	"screens\000"
.LASF27:
	.ascii	"virtual_base\000"
.LASF37:
	.ascii	"uint32_t\000"
.LASF8:
	.ascii	"long int\000"
.LASF4:
	.ascii	"signed char\000"
.LASF28:
	.ascii	"h2p_lw_dataA_addr\000"
	.ident	"GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
	.section	.note.GNU-stack,"",%progbits
