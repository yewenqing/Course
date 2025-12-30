# Reads a 4-byte value and reverses the byte order, then prints it

########################################################################
# .TEXT <main>
main:





BYTE_MASK = 0xFF
	# Locals:
	#	- $t0: int network_bytes
	#	- $t1: int computer_bytes
	#	- $t2: uint32_t byte_mask


	li	$v0, 5		# scanf("%d", &x);
	syscall
	move	$t0, $v0

	li	$t1, 0
	li	$t2, BYTE_MASK
	# t1 = t1 | ((t0 & t2) << 24)
	and	$t3, $t0, $t2
	sll	$t3, $t3, 24
	or	$t1, $t1, $t3

# t1 = t1 | (t0 & (t2 << 8)) << 8
	sll	$t3, $t2, 8
	and	$t4, $t0, $t3
	sll	$t4, $t4, 8
	or	$t1, $t1, $t4
	# t1 = t1 | (t0 & (t2 << 16)) >> 8
	sll	$t3, $t2, 16
	and	$t4, $t0, $t3
	sra	$t4, $t4, 8
	or	$t1, $t1, $t4	
	# t1 = t1 | (t0 & (t2 << 24)) >> 24
	sll	$t3, $t2, 24
	and	$t4, $t0, $t3
	sra	$t4, $t4, 24
	or	$t1, $t1, $t4

	move	$a0, $t1
	li	$v0, 1
	syscall

	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall

main__end:
	li	$v0, 0		# return 0;
	jr	$ra

