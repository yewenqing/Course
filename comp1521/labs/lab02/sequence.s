# Read three numbers `start`, `stop`, `step`
# Print the integers bwtween `start` and `stop` moving in increments of size `step`
#
# Before starting work on this task, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
#
# YOUR-NAME-HERE, DD/MM/YYYY

#![tabsize(8)]


main:				# int main(void) 
	#scan start
	la	$a0, prompt1	# printf("Enter the starting number: ");
	li	$v0, 4
	syscall

	li	$v0, 5		# scanf("%d", number);
	syscall

	move	$t0, $v0	# t0 = v0 = number

	#scan stop
	la	$a0, prompt2	# printf("Enter the stopping number: ");
	li	$v0, 4
	syscall

	li	$v0, 5		# scanf("%d", number);
	syscall

	move	$t1, $v0	# t1 = v0 = stop

	#scan step
	la	$a0, prompt3	# printf("Enter the step size: ");
	li	$v0, 4
	syscall

	li	$v0, 5		# scanf("%d", number);
	syscall

	move	$t2, $v0	# t2 = v0 = step

	j	condition1




condition1:
    	bge	$t1, $t0, condition2 	# if (stop >= start) skip
        bge 	$t2, $zero, condition2  # if (step >= 0) skip 
	move	$t3, $t0	# i = start
	j	loop1		# loop1

loop1:
	blt	$t3, $t1, condition2	#if (i < stop) break
	move    $a0, $t3
	li	$v0, 1		#printf(t1)
	syscall
	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall			#printf("%d\n", i);
	add	$t3, $t3, $t2   # i+=step

	j 	loop1



condition2:
    	ble	$t1, $t0, end	#if (stop <= start) skip
        ble	$t2, $zero, end #if (step <= 0) skip 
	move	$t3, $t0    	# i = start
	j	loop2


loop2:
	
	bgt	$t3, $t1, end    #if (i > stop) break 
	
	move    $a0, $t3
	li	$v0, 1		#printf(t1)
	syscall
	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall			#printf("%d\n", i);
	add	$t3, $t3, $t2   # i+=step
	j	loop2







end:
	li	$v0, 0
	jr	$ra		# return 0

	.data
prompt1:
	.asciiz "Enter the starting number: "
prompt2:
	.asciiz "Enter the stopping number: "
prompt3:
	.asciiz "Enter the step size: "
