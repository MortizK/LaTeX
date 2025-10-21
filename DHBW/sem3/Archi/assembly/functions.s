.data
n: .word 5 	# Variable to calculate n!
result: .word 0	# Result

.globl main
.text

main:
	la t1, n		# load address of n
	lw a0, 0(t1)	# load n into the input of fact
	jal ra, fact	# call the function fact with a0 as an input
	
	# save result
	la t1, result	# load address of result
	sw a0, 0(t1)	# save a0 into memory
	
	# print result
	li a7, 1
	ecall
	
	# exit the programm
	li a7, 10
	ecall

fact:
	li t0, 1 # i start with 1, to catch 0!=1
	li t1, 1 # result
	for:
		bge t0, a0, endFor	# Exit the loop
		
		# Calculations
		mul t1, t1, t0
		
		addi t0, t0, 1	# inkrement i
		
		jal zero, for	# return to for
	endFor:
	# save t1 into a0 as the output of the function
	mv a0, t1
	
	# Return to funcion caller
	jalr zero, 0(ra)