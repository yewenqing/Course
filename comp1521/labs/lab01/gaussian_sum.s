# A simple MIPS program that calculates the Gaussian sum between two numbers

# int main(void)
# {
#   int number1, number2;
#
#   printf("Enter first number: ");
#   scanf("%d", &number1);
#
#   printf("Enter second number: ");
#   scanf("%d", &number2);
#
#   int gaussian_sum = ((number2 - number1 + 1) * (number1 + number2)) / 2;
#
#   printf("The sum of all numbers between %d and %d (inclusive) is: %d\n", number1, number2, gaussian_sum);
#
#   return 0;
# }



main:

        # Read first number
        li   $v0, 4              # syscall 4 = print_string
        la   $a0, prompt1
        syscall

        li   $v0, 5              # syscall 5 = read_int
        syscall
        move $t0, $v0            # t0 = number1

        # Read second number
        li   $v0, 4
        la   $a0, prompt2
        syscall

        li   $v0, 5
        syscall
        move $t1, $v0            # t1 = number2

        # gaussian_sum = ((number2 - number1 + 1) * (number1 + number2)) / 2


        sub  $t2, $t1, $t0       # t2 = number2 - number1
        addi $t2, $t2, 1         # t2 = number2 - number1 + 1

        add  $t3, $t0, $t1       # t3 = number1 + number2

        mul  $t4, $t2, $t3       # t4 = (number2 - number1 + 1) * (number1 + number2)

        # divide by 2
        li   $t5, 2
        div  $t4, $t5
        mflo $t4                 # t4 = t4 / 2 (gaussian_sum)


        # Print result

        # "The sum of all numbers between "
        li   $v0, 4
        la   $a0, answer1
        syscall

        # number1
        li   $v0, 1
        move $a0, $t0
        syscall

        # " and "
        li   $v0, 4
        la   $a0, answer2
        syscall

        # number2
        li   $v0, 1
        move $a0, $t1
        syscall

        # " (inclusive) is: "
        li   $v0, 4
        la   $a0, answer3
        syscall

        # gaussian_sum
        li   $v0, 1
        move $a0, $t4
        syscall

        # newline
        li   $v0, 4
        la   $a0, newline
        syscall

        ####################################################
        # Exit program
        ####################################################
        li   $v0, 10             # syscall 10 = exit
        syscall


.data
  prompt1: .asciiz "Enter first number: "
  prompt2: .asciiz "Enter second number: "

  answer1: .asciiz "The sum of all numbers between "
  answer2: .asciiz " and "
  answer3: .asciiz " (inclusive) is: "
  newline: .asciiz "\n"