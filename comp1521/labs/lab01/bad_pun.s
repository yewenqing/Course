.text
.globl main
main:
  #printf("Well, this was a MIPStake!\n");
	li $v0, 4 # syscall 4: print_string
	la $a0, msg #
	syscall 
	li $v0, 0
	jr   $ra          # return

.data	
msg: 
.asciiz "Well, this was a MIPStake!\n"

