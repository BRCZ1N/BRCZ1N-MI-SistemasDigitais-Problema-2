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
	.file	"gpu_lib_test.c"
	.comm	START_PTR,4,4
	.comm	WRFULL_PTR,4,4
	.comm	DATA_A_PTR,4,4
	.comm	DATA_B_PTR,4,4
	.comm	LW_virtual,4,4
	.section	.rodata
	.align	2
.LC0:
	.ascii	"/dev/mem\000"
	.align	2
.LC1:
	.ascii	"Erro ao abrir /dev/mem\000"
	.align	2
.LC2:
	.ascii	"Erro no mmap\000"
	.text
	.align	2
	.global	gpu_init
	.thumb
	.thumb_func
	.type	gpu_init, %function
gpu_init:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #16
	add	r7, sp, #8
	movw	r0, #:lower16:.LC0
	movt	r0, #:upper16:.LC0
	movw	r1, #4098
	movt	r1, 16
	bl	open
	str	r0, [r7, #4]
	ldr	r3, [r7, #4]
	cmp	r3, #-1
	bne	.L2
	movw	r0, #:lower16:.LC1
	movt	r0, #:upper16:.LC1
	bl	perror
	mov	r3, #-1
	b	.L3
.L2:
	ldr	r3, [r7, #4]
	str	r3, [sp, #0]
	mov	r3, #0
	movt	r3, 65312
	str	r3, [sp, #4]
	mov	r0, #0
	mov	r1, #20480
	mov	r2, #3
	mov	r3, #1
	bl	mmap
	mov	r2, r0
	movw	r3, #:lower16:LW_virtual
	movt	r3, #:upper16:LW_virtual
	str	r2, [r3, #0]
	movw	r3, #:lower16:LW_virtual
	movt	r3, #:upper16:LW_virtual
	ldr	r3, [r3, #0]
	cmp	r3, #-1
	bne	.L4
	movw	r0, #:lower16:.LC2
	movt	r0, #:upper16:.LC2
	bl	perror
	ldr	r0, [r7, #4]
	bl	close
	mov	r3, #-1
	b	.L3
.L4:
	ldr	r0, [r7, #4]
	bl	close
	movw	r3, #:lower16:LW_virtual
	movt	r3, #:upper16:LW_virtual
	ldr	r3, [r3, #0]
	add	r2, r3, #128
	movw	r3, #:lower16:DATA_A_PTR
	movt	r3, #:upper16:DATA_A_PTR
	str	r2, [r3, #0]
	movw	r3, #:lower16:LW_virtual
	movt	r3, #:upper16:LW_virtual
	ldr	r3, [r3, #0]
	add	r2, r3, #112
	movw	r3, #:lower16:DATA_B_PTR
	movt	r3, #:upper16:DATA_B_PTR
	str	r2, [r3, #0]
	movw	r3, #:lower16:LW_virtual
	movt	r3, #:upper16:LW_virtual
	ldr	r3, [r3, #0]
	add	r2, r3, #192
	movw	r3, #:lower16:START_PTR
	movt	r3, #:upper16:START_PTR
	str	r2, [r3, #0]
	movw	r3, #:lower16:LW_virtual
	movt	r3, #:upper16:LW_virtual
	ldr	r3, [r3, #0]
	add	r2, r3, #176
	movw	r3, #:lower16:WRFULL_PTR
	movt	r3, #:upper16:WRFULL_PTR
	str	r2, [r3, #0]
	mov	r3, #0
.L3:
	mov	r0, r3
	add	r7, r7, #8
	mov	sp, r7
	pop	{r7, pc}
	.size	gpu_init, .-gpu_init
	.section	.rodata
	.align	2
.LC3:
	.ascii	"Erro ao desfazer mmap\000"
	.text
	.align	2
	.global	gpu_exit
	.thumb
	.thumb_func
	.type	gpu_exit, %function
gpu_exit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	movw	r3, #:lower16:LW_virtual
	movt	r3, #:upper16:LW_virtual
	ldr	r3, [r3, #0]
	mov	r0, r3
	mov	r1, #20480
	bl	munmap
	mov	r3, r0
	cmp	r3, #-1
	bne	.L5
	movw	r0, #:lower16:.LC3
	movt	r0, #:upper16:.LC3
	bl	perror
.L5:
	pop	{r7, pc}
	.size	gpu_exit, .-gpu_exit
	.align	2
	.global	send_instruction
	.thumb
	.thumb_func
	.type	send_instruction, %function
send_instruction:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	str	r0, [r7, #4]
	str	r1, [r7, #0]
	movw	r3, #:lower16:START_PTR
	movt	r3, #:upper16:START_PTR
	ldr	r3, [r3, #0]
	mov	r2, #0
	str	r2, [r3, #0]
	movw	r3, #:lower16:DATA_A_PTR
	movt	r3, #:upper16:DATA_A_PTR
	ldr	r3, [r3, #0]
	ldr	r2, [r7, #4]
	str	r2, [r3, #0]
	movw	r3, #:lower16:DATA_B_PTR
	movt	r3, #:upper16:DATA_B_PTR
	ldr	r3, [r3, #0]
	ldr	r2, [r7, #0]
	str	r2, [r3, #0]
	movw	r3, #:lower16:START_PTR
	movt	r3, #:upper16:START_PTR
	ldr	r3, [r3, #0]
	mov	r2, #1
	str	r2, [r3, #0]
	movw	r3, #:lower16:START_PTR
	movt	r3, #:upper16:START_PTR
	ldr	r3, [r3, #0]
	mov	r2, #0
	str	r2, [r3, #0]
	add	r7, r7, #12
	mov	sp, r7
	pop	{r7}
	bx	lr
	.size	send_instruction, .-send_instruction
	.align	2
	.global	instrucao_wbr
	.thumb
	.thumb_func
	.type	instrucao_wbr, %function
instrucao_wbr:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #24
	add	r7, sp, #0
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	str	r2, [r7, #4]
	mov	r3, #0
	str	r3, [r7, #16]
	ldr	r3, [r7, #4]
	lsl	r2, r3, #6
	ldr	r3, [r7, #8]
	lsl	r3, r3, #3
	orrs	r2, r2, r3
	ldr	r3, [r7, #12]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r2, [r7, #16]
	ldr	r3, [r7, #20]
	mov	r0, r2
	mov	r1, r3
	bl	send_instruction
	add	r7, r7, #24
	mov	sp, r7
	pop	{r7, pc}
	.size	instrucao_wbr, .-instrucao_wbr
	.align	2
	.global	instrucao_wbr_sprite
	.thumb
	.thumb_func
	.type	instrucao_wbr_sprite, %function
instrucao_wbr_sprite:
	@ args = 4, pretend = 0, frame = 32
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #32
	add	r7, sp, #0
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	str	r2, [r7, #4]
	str	r3, [r7, #0]
	mov	r3, #0
	str	r3, [r7, #20]
	ldr	r3, [r7, #12]
	lsl	r3, r3, #4
	mov	r2, r3
	ldr	r3, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #24]
	ldr	r3, [r7, #0]
	lsl	r2, r3, #9
	ldr	r3, [r7, #8]
	orrs	r2, r2, r3
	ldr	r3, [r7, #4]
	lsl	r3, r3, #19
	orrs	r3, r3, r2
	str	r3, [r7, #28]
	ldr	r3, [r7, #40]
	cmp	r3, #0
	beq	.L10
	ldr	r3, [r7, #28]
	orr	r3, r3, #536870912
	str	r3, [r7, #28]
.L10:
	ldr	r2, [r7, #24]
	ldr	r3, [r7, #28]
	mov	r0, r2
	mov	r1, r3
	bl	send_instruction
	add	r7, r7, #32
	mov	sp, r7
	pop	{r7, pc}
	.size	instrucao_wbr_sprite, .-instrucao_wbr_sprite
	.align	2
	.global	instrucao_wbm
	.thumb
	.thumb_func
	.type	instrucao_wbm, %function
instrucao_wbm:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #32
	add	r7, sp, #0
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	str	r2, [r7, #4]
	str	r3, [r7, #0]
	mov	r3, #2
	str	r3, [r7, #20]
	ldr	r3, [r7, #0]
	lsl	r2, r3, #6
	ldr	r3, [r7, #4]
	lsl	r3, r3, #3
	orrs	r2, r2, r3
	ldr	r3, [r7, #8]
	orrs	r3, r3, r2
	str	r3, [r7, #24]
	ldr	r3, [r7, #12]
	lsl	r3, r3, #4
	mov	r2, r3
	ldr	r3, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #28]
	ldr	r2, [r7, #28]
	ldr	r3, [r7, #24]
	mov	r0, r2
	mov	r1, r3
	bl	send_instruction
	add	r7, r7, #32
	mov	sp, r7
	pop	{r7, pc}
	.size	instrucao_wbm, .-instrucao_wbm
	.align	2
	.global	instrucao_wsm
	.thumb
	.thumb_func
	.type	instrucao_wsm, %function
instrucao_wsm:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #32
	add	r7, sp, #0
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	str	r2, [r7, #4]
	str	r3, [r7, #0]
	mov	r3, #1
	str	r3, [r7, #20]
	ldr	r3, [r7, #0]
	lsl	r2, r3, #6
	ldr	r3, [r7, #4]
	lsl	r3, r3, #3
	orrs	r2, r2, r3
	ldr	r3, [r7, #8]
	orrs	r3, r3, r2
	str	r3, [r7, #24]
	ldr	r3, [r7, #12]
	lsl	r3, r3, #4
	mov	r2, r3
	ldr	r3, [r7, #20]
	orrs	r3, r3, r2
	str	r3, [r7, #28]
	ldr	r2, [r7, #28]
	ldr	r3, [r7, #24]
	mov	r0, r2
	mov	r1, r3
	bl	send_instruction
	add	r7, r7, #32
	mov	sp, r7
	pop	{r7, pc}
	.size	instrucao_wsm, .-instrucao_wsm
	.align	2
	.global	instrucao_dp
	.thumb
	.thumb_func
	.type	instrucao_dp, %function
instrucao_dp:
	@ args = 16, pretend = 0, frame = 32
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #32
	add	r7, sp, #0
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	str	r2, [r7, #4]
	str	r3, [r7, #0]
	mov	r3, #3
	str	r3, [r7, #16]
	ldr	r3, [r7, #12]
	lsl	r3, r3, #4
	mov	r2, r3
	ldr	r3, [r7, #16]
	orrs	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r3, [r7, #48]
	lsl	r2, r3, #6
	ldr	r3, [r7, #44]
	lsl	r3, r3, #3
	orrs	r2, r2, r3
	ldr	r3, [r7, #40]
	orrs	r3, r3, r2
	str	r3, [r7, #24]
	ldr	r3, [r7, #24]
	lsl	r2, r3, #22
	ldr	r3, [r7, #0]
	lsl	r3, r3, #18
	orrs	r2, r2, r3
	ldr	r3, [r7, #4]
	lsl	r3, r3, #9
	orrs	r2, r2, r3
	ldr	r3, [r7, #8]
	orrs	r3, r3, r2
	str	r3, [r7, #28]
	ldr	r3, [r7, #52]
	cmp	r3, #0
	beq	.L14
	ldr	r3, [r7, #28]
	orr	r3, r3, #-2147483648
	str	r3, [r7, #28]
.L14:
	ldr	r2, [r7, #20]
	ldr	r3, [r7, #28]
	mov	r0, r2
	mov	r1, r3
	bl	send_instruction
	add	r7, r7, #32
	mov	sp, r7
	pop	{r7, pc}
	.size	instrucao_dp, .-instrucao_dp
	.ident	"GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
	.section	.note.GNU-stack,"",%progbits
