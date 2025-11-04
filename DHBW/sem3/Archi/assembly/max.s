# int max(int[] a, int length)
# {
#   int tmp = a[0];
#   for (int i=1; i<length; i++)
#   {
#       if (a[i] > tmp)
#       {
#           tmp = a[i];
#       }
#   }
#   return tmp;
# }

.data
array: .word 5, 2, 1, 1, 2, 2, 4, 3, 9, 1
length: .word 10

.globl main
.text

main:
    la s1, array    # Anfangsadresse von Array in a1 laden
    la s2 length    # Adresse der Länge des Arrays in a2 laden
    
    lw s0, 0(s1)    # initialize the max value with the first value of array
    lw s2, 0(s2)    # load the actual length into the register

    li t1, 1        # initialize t1 = i = 1, since it starts with the second value of the arrays

for:
    bge t1, s2, end # leave the loop if i >= length

    addi t1, t1, 1      # increment i
    addi s1, s1, 4      # increment address of array to the next index
    
    # Read
    lw t0, 0(s1)    # read the next value of array

    # Update max value
    bge s0, t0, for    # if t0 < a0, skip the update of max value
    mv s0, t0       # Update the max value

    jal zero, for   # go back to the loop

end:
    # return max value in a0
    mv a0, s0
    li a7, 1
    ecall

    ## Exit
    li a7, 10
    ecall
