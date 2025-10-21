.data
.align 2		# 2^2 = 4
v: .space 80	# Reserviert 80 Byte im RAM um 20 int zu speicher.
n: .word 20	# n for the loop
c: .asciz ","	# for the komma

.globl main
.text

main:
	li s0, 0	 # sum
	li s1, 0	 # i
	la t0, n	 # load address of n into t0
	lw s2, 0(t0) # load value of n into s2
	
	la s3, v		# load start addres of v
	
for:
	bge s1, s2, endFor
	
	# Calculations
	mul t1, s1, s1	# i^2
	add s0, s0, t1	# Sum of i^2
	
	# Save t1 into the array
	sw t1, 0(s3)	# save into the zero index of v
	addi s3, s3, 4	# inkrement the array index by 4 Bytes
	
	# Inkrement i
	addi s1, s1, 1
	
	j for
endFor:
	# Calculate the remainder
	rem t1, s0, s1	# get remainder
	li t2, 10	# factor for base 10
	mul t1, t1, t2	# 
	div t1, t1, s1	# new rounded remainder for 1 digit
	
	# Calculate the rounded average
	div s0, s0, s1
	
	# print result
	li a7, 1		# set ecall to print_int
	mv a0, s0	# copy s0 into the print space
	ecall
	
	# print ,
	li a7, 4		# set ecall to print_string
	la a0, c		# load the komma into print space
	ecall
	
	# print remainder
	li a7, 1		# set ecall to print_int
	mv a0, t1
	ecall
	
	# exit
	li a7, 10	# Service-Code 10 = Exit
	ecall		# Beended das Programm
