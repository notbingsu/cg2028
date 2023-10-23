/*
 * insertion_sort.s
 *
 *  Created on: 10/08/2023
 *      Author: Ni Qingqing
 */
   .syntax unified
	.cpu cortex-m4
	.fpu softvfp
	.thumb

		.global insertion_sort

@ Start of executable code
.section .text

@ EE2028 Assignment 1, Sem 1, AY 2023/24
@ (c) ECE NUS, 2023
@ Insertion sort arr in ascending order

@ Write Student 1’s Name here: Tong Zheng Hong
@ Write Student 2’s Name here: Lu Bingyuan

@ You could create a look-up table of registers here:

@ R0 array pointer
@ R1 length of array (value)
@ R2 swap counter (value)
@ R3 curr (pointer)
@ R4 i (pointer)
@ R5 value to be compared
@ R6 value to be compared
@ R8 swap holder

@ASSUMES ARRAY HAS MORE THAN 1 ITEM

@ write your program from here:
insertion_sort:
	PUSH {R14}
	@initialise registers
	MOV R3, R0 @set curr pointer to first element of array
	MOV R2, #0 @set swaps to 0

	BL OUTER

	POP {R14}
	BX LR

OUTER:

	SUB R1, #1 @decrement length (ie increment step)
	ADD R3, #4 @increment curr
	MOV R4, R3 @set i pointer to curr


INNER:
	LDR R6, [R4] @load right element
	SUB R4, #4
	LDR R5, [R4] @load left element
	CMP R5, R6 @compare left to right
	IT LE
	BLE INNERDONE @branch to done if left <= right
	ADD R2, #1 @increment swap
	MOV R8, R5
	MOV R5, R6
	MOV R6, R8
	STR R5, [R4] @store left element
	ADD R4, #4
	STR R6, [R4] @store right element
	SUB R4, #4
	CMP R4, R0 @check if front reached
	IT GT
	BGT INNER @branch back to INNER if not reached

INNERDONE:

	CMP R1, #0 @check if end reached
	IT GT
	BGT OUTER @branch back to OUTER if not reached

	BX LR
