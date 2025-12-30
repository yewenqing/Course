# Reads 10 numbers into an array,
# swaps any pairs of of number which are out of order
# and then prints the 10 numbers
# YOUR-NAME-HERE, DD/MM/YYYY

# Constants
ARRAY_LEN = 10

main:
	# Registers:
	#  - $t0: int i
	#  - $t1: temporary result
	#  - $t2: temporary result
	#  TODO: add your registers here

scan_loop__init:
	li	$t0, 0				# i = 0;
scan_loop__cond:
	bge	$t0, ARRAY_LEN, scan_loop__end	# while (i < ARRAY_LEN) {

scan_loop__body:
	li	$v0, 5				#   syscall 5: read_int
	syscall					#   
						#
	mul	$t1, $t0, 4			#   calculate &numbers[i] == numbers + 4 * i
	la	$t2, numbers			#
	add	$t2, $t2, $t1			#
	sw	$v0, ($t2)			#   scanf("%d", &numbers[i]);

	addi	$t0, $t0, 1			#   i++;
	j	scan_loop__cond			# }
scan_loop__end:
        
        

            
            

	# TODO: add your code here!


swap_loop__init:
	li	$t0, 1				# i = 1
swap_loop__cond:
	bge	$t0, ARRAY_LEN, swap_loop__end	# while (i < ARRAY_LEN) {

swap_loop__body:
	mul	$t1, $t0, 4			#   calculate &numbers[i] == numbers + 4 * i
	la	$t2, numbers			#
	add	$t2, $t2, $t1			# *t2 = number[i]
	lw	$t3, ($t2)			# int x = numbers[i];
	lw	$t4, -4($t2)			# int y = numbers[i - 1];
	bge	$t3, $t4, swap_end		# if (x >= y) skip 
swap_body: 
	sw	$t4, ($t2)			# numbers[i] = y;
	sw	$t3, -4($t2)			# numbers[i - 1] = x;
swap_end:
	addi	$t0, $t0, 1			#   i++
	j	swap_loop__cond
swap_loop__end:



print_loop__init:
	li	$t0, 0				# i = 1
print_loop__cond:
	bge	$t0, ARRAY_LEN, print_loop__end	# while (i < ARRAY_LEN) {

print_loop__body:
	mul	$t1, $t0, 4			#   calculate &numbers[i] == numbers + 4 * i
	la	$t2, numbers			#
	add	$t2, $t2, $t1			# *t2 = number[i]
	lw	$a0, ($t2)			#
	li	$v0, 1				#   syscall 1: print_int
	syscall					#   printf("%d", numbers[i]);

	li	$v0, 11				#   syscall 11: print_char
	li	$a0, '\n'
	syscall					#   printf("%c", '\n');

	addi	$t0, $t0, 1			#   i++
	b	print_loop__cond		# }



print_loop__end:
	
	li	$v0, 0
	jr	$ra				# return 0;

	.data
numbers:
	.word	0:ARRAY_LEN			# int numbers[ARRAY_LEN] = {0};
