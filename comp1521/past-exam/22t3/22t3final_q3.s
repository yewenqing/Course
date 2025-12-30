# COMP1521 22T3 ... final exam, question 3

# this code reads 1 integer and prints it
# change it to read integers until their sum is >= 42
# and then print their sum
#include <stdio.h>



main:
# t0: sum, t1: 42, t2: x
	li	$t0, 0		# int sum = 0;

loop: 
	li	$t1, 42
	bge	$t0, $t1, end	# if (sum >= 42) break;
	# int x;
	

	li	$v0, 5		#   scanf("%d", &x);
	syscall			#
	move	$t2, $v0	# scanf("%d", &x);	

	add	$t0, $t0, $t2	# sum += x;
	j	loop# goto loop

end:	
	move	$a0, $t0	#   printf("%d\n", sum);
	li	$v0, 1
	syscall

	li	$a0, '\n'	#   printf("%c", '\n');
	li	$v0, 11
	syscall

	li	$v0, 0		# return 0
	jr	$ra
