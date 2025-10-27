.data
.align 2
array: .word 5, 2, 1, 1, 2, 2, 4, 3, 9, 1 #Generiere Array
string1: .asciz "Erster Mittelwert > 5 ist "
string2: .asciz " an Position "

.globl main
.text

main: 
    la t0, array	# Anfangsadresse von Array in t0 laden
    li t1, 0    	# temp in t1 laden
    li t2, 0	# i in t2 laden
    li s0, 6	# Temp Grenze für For Schleife in s0 reinladen
    li s1, 9	# i Grenze für For Schleife in s1 reinladen
    li s2, 2	# 2 zum dividieren in der schleife

    while:
        bge t1, s0, endWhile	# Abbruchbedingung wenn temp größer als 5 ist
        bge t2, s1, endWhile	# Abbruchbedingung wenn i größer als 8 ist
        
        slli t3, t2, 2	# Speicher Adresse des Arrays am nächsten Index in t3
        add t3, t3, t0	# Berechne Abstand zur Basisadresse
        
        lw t4, 0(t3)	# Wert des aktuellen Index i in t3 laden
        lw t5, 4(t3)	# Wert des nächsten Index i+1 in t4 laden
        
        add t3, t5, t4	# a[i] + a[i+1] 
        div t1, t3, s2	# a[i] + a[i+1] / 2
        
        addi t2, t2, 1
        jal zero, while	# Go back to the start of while
    endWhile:
    la a0, string1	# "Erster Mittelwert > 5 ist"  
    li a7, 4		# Wert reinladen zum String Print
    ecall

    mv a0, t1	# temp reinladen
    li a7, 1	# print_int
    ecall

    la a0, string2	# "an Posiition"
    li a7, 4		# Wert reinladen zum String Print
    ecall

    mv a0, t2	# i reinladen
    li a7, 1	# print_int
    ecall
