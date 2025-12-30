# Read a number n and print the first n tetrahedral numbers
# https://en.wikipedia.org/wiki/Tetrahedral_number
#
# Before starting work on this task, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
#
# YOUR-NAME-HERE, DD/MM/YYYY

#![tabsize(8)]


main:				# int main(void) {

	la	$a0, prompt	# printf("Enter how many: ");
	li	$v0, 4
	
	syscall

	li	$v0, 5		# scanf("%d", number);
	syscall
	move	$t1, $v0	# t1 = how_many


	li	$t0, 1		# t0 = n = 1;

loop1:
    	bgt	$t0, $t1, end	#if (n > how_many) break 
        li	$t2, 0	#t2 = total = 0;
        li	$t3, 1	#t3 = j = 1;
	j	loop2


print:
#printf("%d\n", total);
	move    $a0, $t2	
	li	$v0, 1		
	syscall
	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall		


        addi	$t0, $t0, 1	#n = n + 1;
    	j	loop1

# t0 = n = 1;
# t1 = how_many
# t2 = total = 0;
# t3 = j = 1;
# t4 = i = 1;
loop2:
        bgt	$t3, $t0, print #if (j > n) skip loop2 
        li	$t4, 1    	# t4 = i = 1;
	j	loop3

loop2_add:
        addi	$t3, $t3, 1     #j = j + 1;
	j	loop2    
loop3:
	bgt	$t4, $t3, loop2_add #if (i > j) skip loop3
        add 	$t2, $t2, $t4   #total = total + i;
        addi	$t4, $t4, 1        #i = i + 1;
        j	loop3
end:
	li	$v0, 0
	jr	$ra		# return 0

	.data
prompt:
	.asciiz "Enter how many: "
