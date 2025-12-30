

main:
	li	$v0, 5		# scanf("%d", &x);
	syscall			#
	move	$t0, $v0

	li	$v0, 5		# scanf("%d", &y);
	syscall			#
	move	$t1, $v0

loop_init:
	addi	$t2, $t0, 1	# int i = x + 1;

loop_con:
	bge	$t2, $t1, end	# if (i >= y) goto end

loop_body:
	beq	$t2, 13, loop_add	#if (i == 13) goto loop_add
	move	$a0, $t2
	li	$v0, 1
	syscall	

	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall		

loop_add:
	addi	$t2, $t2, 1	#i = i + 1;
	j	loop_con

end:
	li	$v0, 0         # return 0
	jr	$ra
