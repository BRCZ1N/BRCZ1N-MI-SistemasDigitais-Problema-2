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
	@ Salva os registradores
	PUSH	{r7, lr}
.LCFI0:
	.cfi_def_cfa_offset 8
	.cfi_offset 14, -4
	.cfi_offset 7, -8
	SUB	sp, sp, #8
.LCFI1:
	.cfi_def_cfa_offset 16
	ADD	r7, sp, #8
.LCFI2:
	.cfi_def_cfa 7, 8
	.loc 1 27 0
	MOVW	r0, #:lower16:.LC0
	MOVT	r0, #:upper16:.LC0
	MOVW	r1, #4098
	MOVT	r1, 16
	BL	OPEN_FILE
	MOV	r2, r0
	MOVW	r3, #:lower16:fd
	MOVT	r3, #:upper16:fd
	STR	r2, [r3, #0]
	MOVW	r3, #:lower16:fd
	MOVT	r3, #:upper16:fd
	ldr	r3, [r3, #0]
	CMP	r3, #-1
	BNE	CHECK_MEMORY_MAPPING
	.loc 1 28 0
	MOVW	r0, #:lower16:.LC1
	MOVT	r0, #:upper16:.LC1
	BL	PUTS
	.loc 1 29 0
	MOV	r3, #-1
	B	RETURN_MAPPING_MEMORY

CHECK_MEMORY_MAPPING:
	.loc 1 31 0
	MOVW	r3, #:lower16:fd
	MOVT	r3, #:upper16:fd
	ldr	r3, [r3, #0]
	STR	r3, [sp, #0]
	MOV	r3, #-67108864
	STR	r3, [sp, #4]
	MOV	r0, #0
	MOV	r1, #67108864
	MOV	r2, #3
	MOV	r3, #1
	BL	MAP_MEMORY
	MOV	r2, r0
	MOVW	r3, #:lower16:virtual_base
	MOVT	r3, #:upper16:virtual_base
	STR	r2, [r3, #0]
	.loc 1 32 0
	MOVW	r3, #:lower16:virtual_base
	MOVT	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	CMP	r3, #-1
	BNE	SET_MEMORY_ADDRESSES

	.loc 1 33 0
	MOVW	r0, #:lower16:.LC2
	MOVT	r0, #:upper16:.LC2
	BL	PUTS
	.loc 1 34 0
	MOVW	r3, #:lower16:fd
	MOVT	r3, #:upper16:fd
	ldr	r3, [r3, #0]
	MOV	r0, r3
	BL	CLOSE_FILE
	.loc 1 35 0
	MOV	r3, #-1
	B	RETURN_MAPPING_MEMORY

SET_MEMORY_ADDRESSES:
	.loc 1 37 0
	MOVW	r3, #:lower16:virtual_base
	MOVT	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	ADD	r2, r3, #52428800
	ADD	r2, r2, #128
	MOVW	r3, #:lower16:h2p_lw_dataA_addr
	MOVT	r3, #:upper16:h2p_lw_dataA_addr
	STR	r2, [r3, #0]
	.loc 1 38 0
	MOVW	r3, #:lower16:virtual_base
	MOVT	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	ADD	r2, r3, #52428800
	ADD	r2, r2, #112
	MOVW	r3, #:lower16:h2p_lw_dataB_addr
	MOVT	r3, #:upper16:h2p_lw_dataB_addr
	STR	r2, [r3, #0]
	.loc 1 39 0
	MOVW	r3, #:lower16:virtual_base
	MOVT	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	ADD	r2, r3, #52428800
	ADD	r2, r2, #192
	MOVW	r3, #:lower16:h2p_lw_wrReg_addr
	MOVT	r3, #:upper16:h2p_lw_wrReg_addr
	STR	r2, [r3, #0]
	.loc 1 40 0
	MOVW	r3, #:lower16:virtual_base
	MOVT	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	ADD	r2, r3, #52428800
	ADD	r2, r2, #176
	MOVW	r3, #:lower16:h2p_lw_wrFull_addr
	MOVT	r3, #:upper16:h2p_lw_wrFull_addr
	STR	r2, [r3, #0]
	.loc 1 41 0
	MOV	r3, #1

RETURN_MAPPING_MEMORY:
	.loc 1 42 0
	MOV	r0, r3
	MOV	sp, r7
	POP	{r7, pc}
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
	@ Salva os registradores
	PUSH	{r7, lr}
.LCFI3:
	.cfi_def_cfa_offset 8
	.cfi_offset 14, -4
	.cfi_offset 7, -8
	ADD	r7, sp, #0
.LCFI4:
	.cfi_def_cfa_register 7
	.loc 1 46 0
	MOVW	r3, #:lower16:virtual_base
	MOVT	r3, #:upper16:virtual_base
	ldr	r3, [r3, #0]
	MOV	r0, r3
	MOV	r1, #67108864
	BL	MUNMAP_MEMORY
	MOV	r3, r0
	CMP	r3, #0
	BEQ	CHECK_FILE_CLOSE
	.loc 1 47 0
	MOVW	r0, #:lower16:.LC3
	MOVT	r0, #:upper16:.LC3
	BL	PUTS
	.loc 1 48 0
	MOVW	r3, #:lower16:fd
	MOVT	r3, #:upper16:fd
	ldr	r3, [r3, #0]
	MOV	r0, r3
	BL	CLOSE_FILE

CHECK_FILE_CLOSE:
	.loc 1 50 0
	POP	{r7, pc}
	.cfi_endproc
.LFE1:
	.size	closeMappingMemory, .-closeMappingMemory
