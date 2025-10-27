# float f2c (float fahr)
# {
#     return (5.0 / 9.0) * (fahr - 32.0));
# }

.data
string0:    .asciz "Temperatur in Fahrenheit: "
const5:     .float 5.0
const9:     .float 9.0
const32:    .float 32.0
const0k:    .float -273.15

.globl main
.text

main:
    ## Print Question for Input
    la a0, string0      # Lade Adresse nach a0
    li a7, 4            # Print String
    ecall

    ## Read Input
    li a7, 6            # Read float
    ecall               # Ergebnis in fa0

    jal ra, f2c         # jump and link, speichert pointer in ra oder "jal f2c"

    ## Print result from fa0
    li a7, 2            # Print float
    ecall

    ## Exit
    li a7, 10
    ecall

# Input: fa0 einen Fahrenheit Eingabe
# Output: fa0 einen Celsius Ergebnis
f2c:
    flw ft0, const5, t0     # ft0 = 5.0
    flw ft1, const9, t0     # ft1 = 9.0

    fdiv.s ft0, ft0, ft1    # 5.0 / 9.0

    flw ft1, const32, t0    # ft1 = 32.0

    fsub.s fa0, fa0, ft1    # out = input - 32.0
    fmul.s fa0, fa0, ft0    # out = (input - 32.0) * 5.0 / 9.0
    
    ## Check if Celsius < -273.15
    flw ft0, const0k, t0    # ft0 = -273.15
    flt.s t0, fa0, ft0      # t0 = (fa0 < -273.15)
    
    ## Return nichts kleiners als -273.15
    # Speichere nicht woher der Sprung kam
    bne t0, zero, absolutzero

    jalr zero, 0(ra)        # jump back to function caller oder "jr ra"

# Output: fa0 = -273.15
absolutzero:
    flw fa0, const0k, t0    # output = -273.15
    jalr zero, 0(ra)        # jump back to function caller oder "jr ra"