# To run C:\Users\moritz\Documents\Software\rars1_6.jar
# java -jar <right_path>/rars1_6.jar hello_world.s
# java -jar C:\Users\moritz\Documents\Software\rars1_6.jar test.s
# or press ctrl+f5, this will run a tasks, which will run the above command.

# data declarations
.data                           # directive indicating the start of the data declarations
str1: .asciz "Hellow World!"    # define string variable as ascii string terminating with a zero byte (asciiz)

#code
.global main    # define main marker as global label
.text           # directive indicating the start of the program definition

main:               # label indicating the start of the main program
    la a0, str1     # load address (not content) of the string into argument register a0
    li a7, 4        # load immediate constant 4 into a7 (system call number for print_string)
    ecall           # environment call - prints string at address in a0 to console
 
# aupic x10, 64528      Setzt x10 (a0) quasi die oberen 20-Bit
# addi x10, x10, 0      Setzt x10 (a0) quasi die untersten 12-Bit
# addi x17, x0, 4
# ecall                 nutzt a7 umd a0 auszugeben.