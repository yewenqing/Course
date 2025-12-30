# Read a number and print positive multiples of 7 or 11 < n
#
# Before starting work on this task, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
#
# YOUR-NAME-HERE, DD/MM/YYYY

#![tabsize(8)]


main:				# int main(void) 

	la	$a0, prompt	# printf("Enter a number: ");
	li	$v0, 4
	syscall

	li	$v0, 5		# scanf("%d", number);
	syscall

	move	$t0, $v0	# t0 = v0 = number
	li	$t1, 1		# t1 = 1


	j	loop

loop:
	bge	$t1, $t0, end	# if (t1 >= t0) end
	rem	$t2, $t1, 7	# t2 = t1 % 7
	beq 	$t2, $zero, print    # t1 % 7 == 0

	rem	$t3, $t1, 11	# t3 = t1 % 11

	beq 	$t3, $zero, print    # t1 % 11 == 0

	addi 	$t1, $t1, 1	# t1 += 1
	j	loop






print: 
	move  $a0, $t1
	li	$v0, 1		#printf(t1)
	syscall
	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall	
	addi 	$t1, $t1, 1
	j	loop	

end:
	li	$v0, 0
	jr	$ra		# return 0

	.data
prompt:
	.asciiz "Enter a number: "
