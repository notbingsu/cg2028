/*
 * binary_insertion.s
 *
 * Created on: 10/08/2023
 * Author: Ni Qingqing
 */
.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

.global binary_insertion_sort

@ Start of executable code
.section .text

@ EE2028 Assignment 1, Sem 1, AY 2023/24
@ (c) ECE NUS, 2023
@ Binary insertion sort arr in ascending order

@ Student 1’s name: Tong Zheng Hong
@ Student 2’s name: Lu Bingyuan

@ Look-up table of registers here:

@ R0 array pointer
@ R1 length of array (value)
@ R2 Index i
@ R3 Target value to insert into sorted array
@ R4 - R6, R8 Used for binary search and insertion
@ R9 No. of swaps

binary_insertion_sort:
	PUSH {R14}

	MOV R2, #1					@ Initialise index i = 1
	MOV R9, #0					@ Initialise no. of swaps = 0
	BL outer_loop

	MOV R0, R9					@ Return no. of swaps
	POP {R14}
	BX LR

outer_loop:
    CMP R2, R1					@ Check if i >= n (array length)
    BGE end_sort

    LDR R3, [R0, R2, LSL #2]	@ Load target value (arr[i])

    @ Binary search to find the insertion point
    MOV R4, #0					@ Initialise lower bound = 0
    SUB R5, R2, #1				@ Initialize upper bound = i-1

binary_search:
	@ R4 Lower index
	@ R5 Upper index
	@ R6 Middle index
	@ R8 arr[mid]
	CMP R4, R5					@ lower > upper, insertion point found
	BGT insertion_point			@ Insert target at lower (R4) index

	SUB R6, R5, R4				@ Calculate the range size (upper - lower)
	ASR R6, #1					@ Calculate the mid-point of the range (range/2)
    ADD R6, R4					@ Calculate the midpoint index (Add lower)
    LDR R8, [R0, R6, LSL #2]	@ Load arr[mid] into R8

    CMP R8, R3					@ Compare arr[mid] with target (R3)
    BGT greater_than_key		@ If arr[mid] > key, branch to greater_than_key
    BLE less_than_key			@ If arr[mid] <= key, branch to less_than_key

less_than_key:
    ADD R4, R6, #1				@ Set lower bound to mid + 1
    B binary_search				@ Repeat the binary search

greater_than_key:
    SUB R5, R6, #1				@ Set upper bound to mid - 1
    B binary_search				@ Repeat the binary search

insertion_point:
    SUB R5, R2, #1				@ Assign index j = i-1

insertion_loop:
	@ R4 Lower index
	@ R5 Index j
	@ R6 arr[j]
	@ R8 Index j+1
    CMP R5, R4               	@ Stop insertion loop if j < lower
    BLT end_insertion_loop

	@ Insert target value at lower bound index (R4)
	LDR R6, [R0, R5, LSL #2] 	@ Load arr[j] into r6
	ADD R8, R5, #1				@ Store j+1 in R8
    STR R6, [R0, R8, LSL #2] 	@ Store arr[j] in arr[j + 1]
    SUB R5, #1           		@ Decrement j
    ADD R9, #1					@ Increment no. of swaps

    B insertion_loop			@ Repeat the insertion loop

end_insertion_loop:
    STR R3, [R0, R4, LSL #2]	@ Store the target value (R3) at arr[lower]

    ADD R2, #1					@ Increment i
    B outer_loop				@ Continue the outer loop

end_sort:
	BX LR
