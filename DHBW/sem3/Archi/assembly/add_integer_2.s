#
# data declarations
#
.data       # marks the start of the data to be loaded into RAM at program start
str1: .asciz "Enter the First Operand: "
str2: .asciz "Enter the Second Operand: "
str3: .asciz "2 * A + B is "
str4: .asciz " Done [0 = Yes, 1 = No]: "
newline: .asciz "\n"  # This will cause the screen cursor to move to a newline
c: .word 0  # store a zero in memory

#
# code
#
.globl main    # main is declared as a global marker, can be accessed from other files
.text          # marks the start of the instructions, i.e. the program

main:
   ### Get Input
   la a0, str1    # load string address into a0
   li a7, 4       # load print_string code into a7
   ecall          # print str1

   li a7, 5       # load read_int code into a7
   ecall
   mv t0, a0      # place the read value into register t0

   la a0, str2    # load address of string 2 into register a0
   li a7, 4       # load print_string code into a7
   ecall          # print str2

   li a7, 5       # load read_int code into a7
   ecall
   mv t1, a0      # place the read value into register t1

   ### Perform calculation
   add t1, t1, t1 # perform A = A + A
   add t2, t1, t0 # perform addition C = A + B (A is now 2*A)
   
   ## Save c into memory
   la t4, c	# load correct adress to t4
   sw t2, 0(t4)	# write C to c in .data segment

   ### Print result
   la a0, str3    # load address of string 3 into register a0
   li a7, 4       # load print_string code into a7
   ecall          # print str3

   li a7, 1       # print_int 2 * A + B to the console window
   mv a0, t2
   ecall

   la a0, newline # print the new line character to put the screen cursor to a newline
   li a7, 4
   ecall

   ### Restart program with different input?
   la a0, str4    # load address of string 4 into register a0
   li a7, 4       # load print_string code to console
   ecall          # print str4

   li a7, 5       # read an integer from the console
   ecall

   bne a0, zero, main # if not complete (i.e., not 0 was provided) then start at the beginning

   ### Exit
   li a7, 10      # syscall code 10 for terminating the program
   ecall
