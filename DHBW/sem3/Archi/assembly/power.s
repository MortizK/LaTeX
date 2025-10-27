.data

.globl main
.text

main:
	## Call Function
	jal ra, power

	## exit
	li a7, 10
	ecall

# Input: a0 als x und a1 als k > 0
# Output: a0 als x^k
power:
	##

	## return to Function Caller
	jalr zero, 0(ra)
