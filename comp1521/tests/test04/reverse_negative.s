# Reads numbers into an array until a negative number is entered
# then print the numbers in reverse order.

# Constants
ARRAY_LEN = 1000				# This is equivalent to a #define in C.




main:
	# Registers:
	#   - $t0: int i
	#   - $t1: temporary result

read_loop__init:
	li	$t0, 0				# i = 0
read_loop__cond:
	bge	$t0, ARRAY_LEN, read_loop__end	# while (i < ARRAY_LEN) {

read_loop__body:
	li	$v0, 5				#   syscall 5: read_int
	syscall					#   scanf("%d", &x);

	blt	$v0, 0, read_loop__end		#   if (x < 0) break;

	mul	$t1, $t0, 4			#   &numbers[i] = numbers + 4 * i
	sw	$v0, numbers($t1)		#   numbers[i] = x

	addi	$t0, $t0, 1			#   i++;
	j	read_loop__cond			# }
read_loop__end:


print_loop__init:
print_loop__con:
	ble	$t0, $zero, print_loop__end	# if (i <= 0) goto print_loop__end

print_loop__body:
	addi	$t0, $t0, -1			# i--;


	mul	$t1, $t0, 4			# t1 = numbers[i] - numbers[0]
	add	$t1, numbers			# t1 = numbers[i]
	


	li	$v0, 1			# syscall 1: print_int
	lw	$a0, ($t1)
	syscall				# printf("%d", x);

	li	$v0, 11			# syscall 11: print_char
	li	$a0, '\n'		#
	syscall				# printf("%c", '\n');

print_loop__next:
	j	print_loop__con
print_loop__end:

	# TODO: add your code here!

	li	$v0, 0
	jr	$ra				# return 0;

########################################################################
# .DATA
	.data
numbers:
	.space 4 * ARRAY_LEN			# int numbers[ARRAY_LEN];
