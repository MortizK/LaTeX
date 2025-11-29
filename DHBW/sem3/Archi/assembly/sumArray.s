.data
arr: .word 1,2,3,4
n: .word 4

.text
.globl main

main:
la a1, arr
la t0, n
lw a2, 0(t0)

jal ra, sum

li a7, 1
ecall

li a7, 10
li a0, 0
ecall

sum:
li t0, 0
li a0, 0
loop:
lw t0, 0(a1)
addi a1, a1, 4
add a0, a0, t0
addi t0, t0, 1
ble t0,a2, loop
jr ra