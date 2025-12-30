# YOUR-NAME-HERE, DD/MM/YYYY

########################################################################
# .DATA
# Here are some handy strings for use in your code.

	.data
prompt_str:
	.asciiz "Enter a random seed: "
result_str:
	.asciiz "The random result is: "

########################################################################

# .TEXT <main>
	.text
main:

	# Args: void
	# Returns: int
	#
	# Frame:	[...]
	# Uses: 	[...]
	# Clobbers:	[...]
	# 1521 mipsy mathematics.s
	#     -> [body]
	#     -> [epilogue]

main__prologue:
	begin

	# TODO: add code to set up your stack frame here 
	push	$ra
	push 	$s0
	push	$s1

	

main__body:


	li	$v0, 4			# syscall 4: print_string
	la	$a0, prompt_str	#
	syscall				# printf("Enter row: ");

	li	$v0, 5			# syscall 5: read_int
	syscall				#
	move	$s0, $v0		# scanf("%d", &row); 
	# TODO: complete your function body here


	move	$a0, $s0
	
	jal	seed_rand
	
	jal	rand
	move	$s1, $v0		# int value = rand(100);




	move 	$a0, $s1
	jal	add_rand		# value = add_rand(value)
	move	$s1, $v0




	move 	$a0, $s1
	jal	sub_rand		# value = sub_rand(value);
	move	$s1, $v0


	
	move 	$a0, $s1
	jal	seq_rand		# value = seq_rand(value);
	move	$s1, $v0

	li	$v0, 4			# syscall 4: print_string
	la	$a0, result_str	#
	syscall		

	li	$v0, 0
main__epilogue:
	# TODO: add code to clean up stack frame here
		# printf("Enter row: ");

	pop	$s1
	pop 	$s0	
	pop	$ra
	end
	jr	$ra				# return 0;

########################################################################
# .TEXT <add_rand>
	.text
add_rand:
	# Args:
	#   - $a0: int value
	# Returns: int
	#
	# Frame:	[...]
	# Uses: 	[...]
	# Clobbers:	[...]
	#
	# Locals:
	#   - ...
	#
	# Structure:
	#   - add_rand
	#     -> [prologue]
	#     -> [body]
	#     -> [epilogue]

add_rand__prologue:
	begin
	push	$ra

	# TODO: add code to set up your stack frame here

add_rand__body:

	# TODO: complete your function body here
	move	$s2, $a0
	li	$a0, 0xFFFF
	jal	rand
	move	$t1, $v0
	addu	$v0, $s2, $t1


add_rand__epilogue:
	
	# TODO: add code to clean up stack frame here

	end

	jr	$ra


########################################################################
# .TEXT <sub_rand>
	.text
sub_rand:
	# Args:
	#   - $a0: int value
	# Returns: int
	#
	# Frame:	[...]
	# Uses: 	[...]
	# Clobbers:	[...]
	#
	# Locals:
	#   - ...
	#
	# Structure:
	#   - sub_rand
	#     -> [prologue]
	#     -> [body]
	#     -> [epilogue]

sub_rand__prologue:
	begin

	# TODO: add code to set up your stack frame here

sub_rand__body:
	move	$t0, $a0
	jal	rand
	move	$t1, $v0
	sub	$v0, $t0, $t1

	# TODO: complete your function body here

sub_rand__epilogue:
	
	# TODO: add code to clean up stack frame here

	end

	jr	$ra

########################################################################
# .TEXT <seq_rand>
	.text
seq_rand:
	# Args:
	#   - $a0: int value
	# Returns: int
	#
	# Frame:	[...]
	# Uses: 	[...]
	# Clobbers:	[...]
	#
	# Locals:
	#   - ...
	#
	# Structure:
	#   - seq_rand
	#     -> [prologue]
	#     -> [body]
	#     -> [epilogue]

seq_rand__prologue:
	begin

	# TODO: add code to set up your stack frame here


seq_rand__body:
	move	$t0, $a0	# t0 : value
	li	$a0, 100
	jal	rand
	move	$t1, $v0	# t1 : limit = rand(100)
seq_rand__loop_init:
	li	$t2, 0		# int i = 0, t2: i
seq_rand__loop_con:
# for (int i = 0; i < limit; i++)
# while (i < limit)
	bge	$t2, $t1, seq_rand__loop_end	# if (i >= limit) goto seq_rand__loop_end
seq_rand__loop_body:
	move	$a0, $t0
	jal	rand
	move	$t0, $v0	# value = add_rand(value)
seq_rand__loop_next:
	addi	$t2, $t2, 1	# i++
	j	seq_rand__loop_con
seq_rand__loop_end:
	move	$v0, $t0	# return value;

	# TODO: complete your function body here

seq_rand__epilogue:
	
	# TODO: add code to clean up stack frame here

	end
	
	jr	$ra



##
## The following are two utility functions, provided for you.
##
## You don't need to modify any of the following,
## but you may find it useful to read through.
## You'll be calling these functions from your code.
##

OFFLINE_SEED = 0x7F10FB5B

########################################################################
# .DATA
	.data
	
# int random_seed;
	.align 2
random_seed:
	.space 4


########################################################################
# .TEXT <seed_rand>
	.text
seed_rand:
# DO NOT CHANGE THIS FUNCTION

	# Args:
	#   - $a0: unsigned int seed
	# Returns: void
	#
	# Frame:	[]
	# Uses:		[$a0, $t0]
	# Clobbers:	[$t0]
	#
	# Locals:
	#   - $t0: offline_seed
	#
	# Structure:
	#   - seed_rand

	li	$t0, OFFLINE_SEED		# const unsigned int offline_seed = OFFLINE_SEED;
	xor	$t0, $a0			# random_seed = seed ^ offline_seed;
	sw	$t0, random_seed

	jr	$ra				# return;

########################################################################
# .TEXT <rand>
	.text
rand:
# DO NOT CHANGE THIS FUNCTION

	# Args:
	#   - $a0: unsigned int n
	# Returns:
	#   - $v0: int
	#
	# Frame:    []
	# Uses:     [$a0, $v0, $t0]
	# Clobbers: [$v0, $t0]
	#
	# Locals:
	#   - $t0: int rand
	#
	# Structure:
	#   - rand

	lw	$t0, random_seed 		# unsigned int rand = random_seed;
	multu	$t0, 0x5bd1e995  		# rand *= 0x5bd1e995;
	mflo	$t0
	addiu	$t0, 12345       		# rand += 12345;
	sw	$t0, random_seed 		# random_seed = rand;

	remu	$v0, $t0, $a0    
	jr	$ra              		# return rand % n;
