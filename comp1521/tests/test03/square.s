

main:
	li	$v0, 5		# scanf("%d", &x);
	syscall			#
	move	$t0, $v0


loop1_init:
	li	$t1, 0		# int i = 0;

loop1_con:
	bge	$t1, $t0, end	#if (i >= x) goto end 

loop1_body:

loop2_init:
	li	$t2, 0		# int j = 0;

loop2_con:
	bge	$t2, $t0, loop2_end	# if (j >= x) goto loop2_end
loop2_body:

	la	$a0, prompt
	li	$v0, 4
	syscall	


	addi	$t2, $t2, 1	# j = j + 1;
	j	loop2_con


loop2_end:
	addi	$t1, $t1, 1 	# i = i + 1;
	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall	
	j	loop1_con



end:
	li	$v0, 0		# return 0
	jr	$ra


prompt:
	.asciiz "*"