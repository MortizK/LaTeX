# Benutze Heron Verfahren um die Quadratwurzel zu berechnen
# x_n+1 = (x_n + a / x_n) / 2
# x_0 = a / 2

# sqrt(2) ~ 1,41421356
# with i = 1: 1.5
# with i = 2: 1.4166667
# with i = 3: 1.4142157
# with i = 7: 1.4142135

.data
a: .float 2.0
two: .float 2.0
i: .word 3

.globl main
.text

main:
    la t0, a
    flw ft1, 0(t0)   # load a into ft1

    la t0, two
    flw ft0, 0(t0)   # load 2.0 into ft0

    la t0, i
    lw t1, 0(t0)     # load number of iterations into t1

    li t0, 0          # initialize loop counter

    # Initial guess x0 = a / 2
    fdiv.s fa0, ft1, ft0    # x0 = a / 2

heron:
    # Calculations
    fdiv.s ft2, ft1, fa0    # a / x_n
    fadd.s fa0, fa0, ft2    # x_n + a / x_n
    fdiv.s fa0, fa0, ft0    # (x_n + a / x_n) / 2

    addi t0, t0, 1    # i++
    blt t0, t1, heron   # i < iterations

    ## print result
    li a7, 2
    ecall

    ## Exit
    li a7, 10
    ecall
