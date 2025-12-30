# read a mark and print the corresponding UNSW grade
#
# Before starting work on this task, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
#
# YOUR-NAME-HERE, DD/MM/YYYY

#![tabsize(8)]

result1:
	la	$a0, fl		# printf("FL\n");
	li	$v0, 4
	syscall
	li	$v0, 0
	jr	$ra		# return 0

result2:
	la	$a0, ps		# printf("PS\n");
	li	$v0, 4
	syscall
	li	$v0, 0
	jr	$ra		# return 0

result3:
	la	$a0, cr		# printf("CR\n");
	li	$v0, 4
	syscall
	li	$v0, 0
	jr	$ra		# return 0

result4:
	la	$a0, dn		# printf("DN\n");
	li	$v0, 4
	syscall
	li	$v0, 0
	jr	$ra		# return 0

result5:
	la	$a0, hd		# printf("HD\n");
	li	$v0, 4
	syscall
	li	$v0, 0
	jr	$ra		# return 0



main:
	la	$a0, prompt	# printf("Enter a mark: ");
	li	$v0, 4
	syscall

	li	$v0, 5		# scanf("%d", mark);
	syscall
	move $t0, $v0     # mark -> $t0

	BLT $t0, 50, result1 	# if (mark < 50)
	BLT $t0, 65, result2 	# if (mark < 65)
	BLT $t0, 75, result3 	# if (mark < 75)
	BLT $t0, 85, result4 	# if (mark < 85)
	BGE $t0, 85, result5 	# if (mark > 85)




	.data
prompt:
	.asciiz "Enter a mark: "
fl:
	.asciiz "FL\n"
ps:
	.asciiz "PS\n"
cr:
	.asciiz "CR\n"
dn:
	.asciiz "DN\n"
hd:
	.asciiz "HD\n"



