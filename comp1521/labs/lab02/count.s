# read a number n and print the integers 1..n one per line
#
# Before starting work on this task, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
#
# YOUR-NAME-HERE, DD/MM/YYYY

#![tabsize(8)]






main:                 		# int main(void)
	la	$a0, prompt	# printf("Enter a number: ");
	li	$v0, 4
	syscall

	li	$v0, 5		# scanf("%d", number);
	syscall
	move	$t1, $v0	# t1 = number
	

	li 	$t0, 1		# i = 1;

	li	$v0, 1


loop: 
	bgt	$t0, $t1, end
	move	$a0, $t0
	li	$v0, 1
	syscall			# printf("%d\n", i);
	li $a0, '\n'
	li $v0, 11
	syscall          	# \n	
	add	$t0, $t0, 1	# i = i + 1;
	j 	loop

end:
	li	$v0, 0
	jr	$ra		# return 0

	.data
prompt:
	.asciiz "Enter a number: "
