.data
str1: .asciz "Gebe einen Wert für x ein: "
str2: .asciz "Die Approximation ist: "

.globl main
.text

main:
	la a0, str1	# Adresse zu String in a0 reinladen
	li a7, 4 	# Wert für String Print
	ecall 		# Print

	li a7, 5 	# Integer Wert einlesen, landet in a0
	ecall
	mv s0, a0	# Eingabe für X in s0 reinladen (X)
	mul s1, s0, s0	# X hoch 2
	mul s2, s1, s0	# X hoch 3

	li s3,1 		# 1 Fakultät = 1 reinladen
	li s4, 2 	# 2 Fakultät = 2 reinladen
	li s5,6		# 3 Fakultät = 6 reinladen

	div t1, s0, s3 	# Ersten Quotient in t1 reinladen (x/1!)
	sub t1, s3, t1 	# 1 minus Quotient in t1 reinladen (1- (x/1!))

	div t2, s1, s4 	# Zweiten Quotient in t2 reinladen (x hoch 2/ 2!)
	add t1, t1, t2 	# Zweiten Quotient dazuaddieren

	div t2, s2, s5 	# Dritten Quotient in t2 reinladen (x hoch 3/ 3!)
	sub t1, t1, t2 	# Gesamtes Ergebnis in t1 speichern

	la a0, str2	# Adresse zu String in a0 reinladen
	li a7, 4 	# Wert für string_print
	ecall 		# Print

	mv a0, t1 	# Gesamtergebnis in a0 reinladen
	li a7, 1 	# 1 für print_int
	ecall
