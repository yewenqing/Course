# Sieve of Eratosthenes
# https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
# YOUR-NAME-HERE, DD/MM/YYYY

# Constants
ARRAY_LEN = 1000


main:

# register
# t0 : base address
# t1: i
# t2: tmp
# t3: j
# t4: tmp
# t5: tmp
	la	$t0, prime	
	sb $zero, 0($t0)       # prime[0] = 0
	sb $zero, 1($t0)       # prime[1] = 0	
loop1_init:

	li 	$t1, 2		# int i = 2 
loop1_con:
	bge	$t1, ARRAY_LEN, loop1_end	# if (i >= ARRAY_LEN) goto loop1_end
loop1_body:
	mul	$t2, $t1, 1	# t2 = byte offset
	add	$t2, $t2, $t0	# t2 = prime[i]
	lb	$t5, ($t2)
	beq	$t5, 0, loop1_next	# if (prime[i] == 0) goto loop1_next
	# printf("%d\n", i);
	li	$v0, 1		# syscall 1: print_int
	move	$a0, $t1	#
	syscall			#

	li	$v0, 11		# syscall 11: print_char
	li	$a0, '\n'	# 
	syscall			# printf("%c", '\n');

loop2_init:
	mul	$t3, $t1, 2		# int j = 2 * i
loop2_con:
# for (int j = 2 * i; j < ARRAY_LEN; j += i)
# while (j < ARRAY_LEN)
	bge	$t3, ARRAY_LEN, loop2_end	# if (j >= ARRAY_LEN) goto loop2_end

loop2_body:
	mul	$t4, $t3, 1	# t4 = prime[j] - prime[0]
	add	$t4, $t4, $t0	# t4 = prime[j]
	sb	 $zero, 0($t4)	# prime[j] = 0

loop2_next:
	add	$t3, $t3, $t1	# j+= i
	j	loop2_con

loop2_end:

loop1_next:
	addi	$t1, $t1, 1	# i++
	j	loop1_con
loop1_end:


	# TODO: add your code here

	li	$v0, 0
	jr	$ra			# return 0;



	.data
prime:
	.byte	1:ARRAY_LEN		# uint8_t prime[ARRAY_LEN] = {1, 1, ...};
