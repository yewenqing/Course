#  print the minimum of two integers



main:
	# t0: x
	# t1: y
	li	$v0, 5		# scanf("%d", &x);
	syscall			#
	move	$t0, $v0	

	li	$v0, 5		# scanf("%d", &y);
	syscall			#
	move	$t1, $v0


	bge	$t0, $t1,else	# if (x >= y) goto else 
	move	$a0, $t0
	li	$v0, 1
	syscall	
	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall	
	j	end# goto end
else:
	move	$a0, $t1
	li	$v0, 1
	syscall	

	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall
	j	end# goto end

end:
	li	$v0, 0		# return 0
	jr	$ra
