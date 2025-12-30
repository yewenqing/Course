# COMP1521 monster mips
TRUE = 1
FALSE = 0
HEAD = 0
BODY = 1
ARMS = 2
LEGS = 3
DONE = 4
MAX_STR_LEN = 32
SIZEOF_PTR = 4
SIZEOF_INT = 4
SIZEOF_CHAR = 1

#######################
# !!!!! WARNING !!!!! #
# DO NOT MODIFY .DATA #
# !!!!! WARNING !!!!! #
#######################
	.data
#####################
## int nparts = 3; ##
#####################
nparts:
	.word 3

###############################################################################
## char *heads[] = {"r--7\n|o.|\n\\ -|\n Lc*\n", "^  ^\n|--|\n|0o|\n$()$\n", ##
##                  "    \n ^^ \n O  \n-__-\n"};                             ##
###############################################################################

heads0:
	.asciiz "r--7\n|o.|\n\\ -|\n Lc*\n"
heads1:
	.asciiz "^  ^\n|--|\n|0o|\n$()$\n"
heads2:
	.asciiz "    \n ^^ \n O  \n-__-\n"
heads:
	.align 2
	.word heads0
	.word heads1
	.word heads2

###########################################################################
## char *miniheads[] = {" oO \n r* \n", "0  0\n|__|\n", "- o \n ~  \n"}; ##
###########################################################################

miniheads0:
	.asciiz " oO \n r* \n"
miniheads1:
	.asciiz "0  0\n|__|\n"
miniheads2:
	.asciiz "- o \n ~  \n"
miniheads:
	.align 2
	.word miniheads0
	.word miniheads1
	.word miniheads2

############################################################################################
## char *bodies[] = {                                                                     ##
## "R-TT-v\n|c--d|\n|-  -|\n|.   |\n|  . |\n \\  / \n__||__\n|    |\nl_  _7\n  ^-  \n",   ##
## "  9p  \n |--| \n /  \\ \n \\  / \n  ||  \n  ||  \n------\n|    |\n--||--\n +||+ \n",  ##
## "  --  \n ---- \n/-  -\\\n|    |\n|    |\n|    |\n\\-  -/\n ---- \n  --  \n _--_ \n"}; ##
############################################################################################

bodies0:
	.asciiz "R-TT-v\n|c--d|\n|-  -|\n|.   |\n|  . |\n \\  / \n__||__\n|    |\nl_  _7\n  ^-  \n"
bodies1:
	.asciiz "  9p  \n |--| \n /  \\ \n \\  / \n  ||  \n  ||  \n------\n|    |\n--||--\n +||+ \n"
bodies2:
	.asciiz "  --  \n ---- \n/-  -\\\n|    |\n|    |\n|    |\n\\-  -/\n ---- \n  --  \n _--_ \n"
bodies:
	.align 2
	.word bodies0
	.word bodies1
	.word bodies2

###########################################################
## char *minibodies[] = {                                ##
## "-rv^--\n |  / \n  \\ / \n / |  \n |  \\ \n ^-+} \n", ##
## "+-++-+\n|    |\n--  --\n\\    /\n |--| \n-|  |-\n",  ##
## "__--__\n  ||  \n--||--\n  ||  \n  ||  \n--||--\n"};  ##
###########################################################

minibodies0:
	.asciiz "-rv^--\n |  / \n  \\ / \n / |  \n |  \\ \n ^-+} \n"
minibodies1:
	.asciiz "+-++-+\n|    |\n--  --\n\\    /\n |--| \n-|  |-\n"
minibodies2:
	.asciiz "__--__\n  ||  \n--||--\n  ||  \n  ||  \n--||--\n"

minibodies:
	.align 2
	.word minibodies0
	.word minibodies1
	.word minibodies2

#####################################################
## char *arms[] = {                                ##
## " |\nP^\n|_\n||\n||\n+)\n (\nTT\n||\n^^\n",     ## 
## "| \n| \no-\n |\n |\n X\n  \n  \n  \n  \n  \n", ##
## "  \n+-\n  \n+-\n| \n  \n+-\n  \n+-\n  \n"};    ##
#####################################################

arms0:
	.asciiz " |\nP^\n|_\n||\n||\n+)\n (\nTT\n||\n^^\n"
arms1:
	.asciiz "| \n| \no-\n |\n |\n X\n  \n  \n  \n  \n  \n"
arms2:
	.asciiz "  \n+-\n  \n+-\n| \n  \n+-\n  \n+-\n  \n"

arms:
	.align 2
	.word arms0
	.word arms1
	.word arms2

##################################
## char *miniarms[] = {         ##
## " |\n |\n |\n |\n| \n+ \n",  ##
## "  \n+ \n| \n--\n  \n  \n",  ##
## "|-\n+ \n  \n+ \n| \nO \n"}; ##
##################################

miniarms0:
	.asciiz  " |\n |\n |\n |\n| \n+ \n"

miniarms1:
	.asciiz "  \n+ \n| \n--\n  \n  \n"

miniarms2:
	.asciiz "|-\n+ \n  \n+ \n| \nO \n"

miniarms:
	.align 2
	.word miniarms0
	.word miniarms1
	.word miniarms2


#######################################################################################################################################
## char *legs[] = {                                                                                                                  ## 
## "    TT    \n   R^^7   \n   |  |   \n   |  |   \n   |  |   \n   |  |   \n   |  |   \n   |  |   \n   |  |   \n  _*_ *_  \n",       ##
## "+--------+\n|        |\n\\        /\n \\      / \n  \\    /  \n   \\  /   \n   |  |   \n   |  |   \n   _- -_   \n___/  \\___\n", ##
## "  ||  ||  \n___----___\n|+      +|\n .        \n        . \n      .   \n .     .  \n       .  \n -||--||- \n  ++  ++  \n"};      ##
#######################################################################################################################################

legs0:
	.asciiz "    TT    \n   R^^7   \n   |  |   \n   |  |   \n   |  |   \n   |  |   \n   |  |   \n   |  |   \n   |  |   \n  _*_ *_  \n"

legs1:
	.asciiz "+--------+\n|        |\n\\        /\n \\      / \n  \\    /  \n   \\  /   \n   |  |   \n   |  |   \n   _- -_   \n___/  \\___\n"

legs2:
	.asciiz "  ||  ||  \n___----___\n|+      +|\n .        \n        . \n      .   \n .     .  \n       .  \n -||--||- \n  ++  ++  \n"

legs:
	.align 2
	.word legs0
	.word legs1
	.word legs2

####################################################################################
## char *minilegs[] = {                                                           ##
## "    ||    \n    ||    \n    ||    \n    ||    \n    |+    \n    +_    \n",    ##
## "    /\\    \n   /  \\   \n  /    \\  \n  |    |  \n  |    |  \n  ++  ++  \n", ##
## "    ++    \n      .   \n          \n     .    \n   \\  /   \n   -++-   \n"};  ##
####################################################################################

minilegs0:
	.asciiz  "    ||    \n    ||    \n    ||    \n    ||    \n    |+    \n    +_    \n"

minilegs1:
	.asciiz  "    /\\    \n   /  \\   \n  /    \\  \n  |    |  \n  |    |  \n  ++  ++  \n"

minilegs2:
	.asciiz "    ++    \n      .   \n          \n     .    \n   \\  /   \n   -++-   \n"

minilegs:
	.align 2
	.word minilegs0
	.word minilegs1
	.word minilegs2

###########################
## char *headl = "    "; ##
###########################

headl:
	.asciiz "    "

###########################
## char *headr = "    "; ##
###########################

headr:
	.asciiz "    "

#######################
# !!!!! WARNING !!!!! #
# DO NOT MODIFY .DATA #
# !!!!! WARNING !!!!! #
#######################

####################
## STATIC STRINGS ##
####################
help_make_monster__s1:
	.asciiz "selecting:\n"

help_make_monster__s2:
	.asciiz "choose? (y/n): "

main_s1:
	.asciiz "welcome to monster mips!\n"

main_s2:
	.asciiz "enter the name for your monster duo! "

main_s3:
	.asciiz "select your big monster:\n"

main_s4:
	.asciiz "select your mini monster:\n"

main_s5:
	.asciiz "unleash the monsters!\n"

main_s6:
	.asciiz "meet "

######################
## struct monster { ##
##     char *head;  ##
##     char *arms;  ## 
##     char *body;  ##
##     char *legs;  ##
## };               ##
######################

HEAD_OFFSET = 0
ARMS_OFFSET = HEAD_OFFSET + SIZEOF_PTR
BODY_OFFSET = ARMS_OFFSET + SIZEOF_PTR
LEGS_OFFSET = BODY_OFFSET + SIZEOF_PTR
SIZEOF_MONSTER = LEGS_OFFSET + SIZEOF_PTR

#######################
# !!!!! WARNING !!!!! #
# DO NOT MODIFY .DATA #
# !!!!! WARNING !!!!! #
#######################

	.text

#######################
## TO BE IMPLEMENTED ##
#######################

# stack frame
# ... TODO
main:
main__prologue:
main__body:
	li	$v0, 0				# return 0;
main__epilogue:
	jr	$ra				#

##############
## PROVIDED ##
##############

# function arguments
# ($fp+4) [char *head]
# stack frame
# ($fp) [old $fp]
print_head:
print_head__prologue:
	sub	$sp, $sp, 4			# ... allocate space on the stack to store old $fp
	sw	$fp, ($sp)			# ... save old $fp to the stack
	move	$fp, $sp			# ... move new $fp to point to bottom of stack frame
print_head__body:
print_head__print_body:
	lw	$a0, 4($fp)			# ... head
	lb	$a0, ($a0)			# ... *head
	beqz	$a0, print_head__epilogue	# if (!*head) return;
	
	la	$a0, headl			# printf("%s", headl);
	li	$v0, 4				#
	syscall					#

print_head__inner_print_cond:
	lw	$a0, 4($fp)			# ... head
	lb	$a0, ($a0)			# ... *head
	beq	$a0, '\n', print_head__inner_print_end
						# while (*head != '\n'\)
print_head__inner_print_body:
	li	$v0, 11				# putchar(*head\);
	syscall					#
	
	lw	$a0, 4($fp)			# head++;
	add	$a0, $a0, 1			#
	sw	$a0, 4($fp)			#
	b	print_head__inner_print_cond
print_head__inner_print_end:
	
	lw	$a0, 4($fp)			# head++;
	add	$a0, $a0, 1			#
	sw	$a0, 4($fp)			#


	la	$a0, headr			# printf("%s", headr);
	li	$v0, 4				#
	syscall					#

	li	$a0, '\n'			# putchar('\n');
	li	$v0, 11				#
	syscall					#

	b	print_head__print_body
print_head__print_end:
print_head__epilogue:
	lw	$fp, ($sp)			# ... restore old $fp from stack
	add	$sp, $sp, 4			# ... deallocate space used for old $fp
	jr	$ra				# return;

##############
## PROVIDED ##
##############

# function arguments
# ($fp+8) [char *arms]
# ($fp+4) [char *body]
# stack frame
# ($fp) [old $fp]
# ($fp-4) [char *a1]
# ($fp-8) [char *a2]
print_body:
print_body__prologue:
	sub	$sp, $sp, 4			# ... allocate for old $fp
	sw	$fp, ($sp)			# ... save old $fp
	move	$fp, $sp			# ... start this stack frame
	sub	$sp, $sp, 8			# ... allocate space for 2x[char*]
print_body__body:
print_body__print_body:				# lol...
	lw	$a0, 8($fp)			# ... arms
	lb	$a0, ($a0)			# ... *arms
	beqz	$a0, print_body__epilogue	# if (!*arms) return;

	lw	$a0, 4($fp)			# ... body
	lb	$a0, ($a0)			# ... *body
	beqz	$a0, print_body__epilogue	# if (!*body) return;

	lw	$a0, 8($fp)			# ... arms
	sw	$a0, -4($fp)			# a1 = arms;
print_body__inner1_cond:
	lw	$a0, -4($fp)			# ... a1
	lb	$a0, ($a0)			# ... *a1
	beq	$a0, '\n', print_body__inner1_end 
						# while (*a1 != '\n')
print_body__inner1_body:
	li	$v0, 11				# putchar(*a1);
	syscall					#

	lw	$a0, -4($fp)			# a1++;
	add	$a0, $a0, 1			#
	sw	$a0, -4($fp)			#

	b	print_body__inner1_cond
print_body__inner1_end:
	li	$a0, ' '			# putchar(' ');
	li	$v0, 11				#
	syscall					#
print_body__inner2_cond:
	lw	$a0, 4($fp)			# ... body
	lb	$a0, ($a0)			# ... *body
	beq	$a0, '\n', print_body__inner2_end 
						# while (*body != '\n')
print_body__inner2_body:
	li	$v0, 11				# putchar(*body);
	syscall					#

	lw	$a0, 4($fp)			# body++
	add	$a0, $a0, 1			#
	sw	$a0, 4($fp)			#

	b	print_body__inner2_cond
print_body__inner2_end:
	li	$a0, ' '			# putchar(' ');
	li	$v0, 11				#
	syscall					#

	lw	$a0, 8($fp)			# ... arms
	sw	$a0, -8($fp)			# a2 = arms;
print_body__inner3_cond:
	lw	$a0, -8($fp)			# ... a2
	lb	$a0, ($a0)			# ... *a2
	beq	$a0, '\n', print_body__inner3_end 
						# while (*a2 != '\n')
print_body__inner3_body:
	lw	$a0, -8($fp)			# a2++;
	add	$a0, $a0, 1			#
	sw	$a0, -8($fp)			#

	b	print_body__inner3_cond
print_body__inner3_end:

	lw	$a0, -8($fp)			# a2--;
	sub	$a0, $a0, 1			#
	sw	$a0, -8($fp)			#

print_body__inner4_cond:
	lw	$a0, -8($fp)			# ... a2
	lw	$v0, 8($fp)			# ... arms
	beq	$a0, $v0, print_body__inner4_end 
						# while (a2 != arms)
print_body__inner4_body:
	lb	$a0, ($a0)			# putchar(*a2);
	li	$v0, 11				#
	syscall					#

	lw	$a0, -8($fp)			# a2--;
	sub	$a0, $a0, 1			#
	sw	$a0, -8($fp)			#

	b	print_body__inner4_cond	
print_body__inner4_end:

	lw	$a0, -8($fp)			# putchar(*a2);
	lb	$a0, ($a0)			#
	li	$v0, 11				#
	syscall					#

print_body__inner5_cond:
	lw	$a0, 8($fp)			# ... arms
	lb	$a0, ($a0)			# ... *arms
	beq	$a0, '\n', print_body__inner5_end 
						# while (*arms != '\n')
print_body__inner5_body:
	lw	$a0, 8($fp)			# arms++:
	add	$a0, $a0, 1			#
	sw	$a0, 8($fp)			#

	b	print_body__inner5_cond
print_body__inner5_end:
	lw	$a0, 8($fp)			# arms++;
	add	$a0, $a0, 1			#
	sw	$a0, 8($fp)			#

	lw	$a0, 4($fp)			# body++;
	add	$a0, $a0, 1			#
	sw	$a0, 4($fp)			#

	li	$a0, '\n'			# putchar('\n');
	li	$v0, 11				#
	syscall					#

	b	print_body__print_body
print_body__print_end:
print_body__epilogue:
	add	$sp, $sp, 8			# ... deallocate 2x[char*]
	lw	$fp, ($sp)			# ... restore old $fp
	add	$sp, $sp, 4			# ... deallocate old $fp
	jr	$ra				# return;

##############
## PROVIDED ##
##############

# function arguments
# ($fp+4) [char *legs]
# stack frame
# ($fp) [old $fp]
print_legs:
print_legs__prologue:
	sub	$sp, $sp, 4			# ... allocate for old $fp
	sw	$fp, ($sp)			# ... save old $fp
	move	$fp, $sp			# ... start new stack frame
print_legs__body:
print_legs__print_body:
	lw	$a0, 4($fp)			# ... legs
	lb	$a0, ($a0)			# ... *legs
	beqz	$a0, print_legs__epilogue	# if (!*legs) return;

	li	$a0, ' '			# putchar(' ');
	li	$v0, 11				#
	syscall					#
print_legs__inner_cond:
	lw	$a0, 4($fp)			# ... legs
	lb	$a0, ($a0)			# ... *legs
	beq	$a0, '\n', print_legs__inner_end 
						# while (*legs != '\n')
print_legs__inner_body:
	li	$v0, 11				# putchar(*legs);
	syscall					#

	lw	$a0, 4($fp)			# legs++;
	add	$a0, $a0, 1			#
	sw	$a0, 4($fp)			#

	b	print_legs__inner_cond
print_legs__inner_end:
	
	lw	$a0, 4($fp)			# legs++;
	add	$a0, $a0, 1			#
	sw	$a0, 4($fp)			#

	li	$v0, 11				# putchar(' ');
	li	$a0, ' '			#
	syscall					#

	li	$a0, '\n'			# putchar('\n');
	syscall					#

	b	print_legs__print_body
print_legs__print_end:
print_legs__epilogue:
	lw	$fp, ($sp)			# ... restore old $fp
	add	$sp, $sp, 4			# ... deallocate old $fp
	jr	$ra				# return;

##############
## PROVIDED ##
##############

# function arguments
# ($fp+24) [int is_mini]
# ($fp+20) [int *choosing]
# ($fp+16) [char **edit_monster]
# ($fp+12) [int *monster_index]
# ($fp+8) [char **miniparts]
# ($fp+4) [char **bigparts]
# stack frame
# ($fp) [old $fp]
help_make_monster:
help_make_monster__prologue:
	sub	$sp, $sp, 4			# ... allocate old $fp
	sw	$fp, ($sp)			# ... save old $fp
	move	$fp, $sp			# ... start new stack frame
help_make_monster__body:
	la	$a0, help_make_monster__s1	# printf("selecting:\n);
	li	$v0, 4				#
	syscall					#

	lw	$a0, 24($fp)			# if (is_mini)
	beqz	$a0, help_make_monster__not_mini# 

	lw	$a0, 12($fp)			# ... monster_index
	lw	$a0, ($a0)			# ... *monster_index
	mul	$a0, $a0, 4			# ... &[*monster_index]
	lw	$v0, 8($fp)			# ... miniparts
	add	$a0, $a0, $v0			# ... &miniparts[*monster_index]
	lw	$a0, ($a0)			# ... miniparts[*monster_index]
	lw	$v0, 16($fp)			# ... edit_monster
	sw	$a0, ($v0)			# *edit_monster = miniparts[*monster_index]

	li	$v0, 4
	syscall

	b	help_make_monster__end_edit

help_make_monster__not_mini:
	lw	$a0, 12($fp)			# ... monster_index
	lw	$a0, ($a0)			# ... *monster_index
	mul	$a0, $a0, 4			# ... &[*monster_index]
	lw	$v0, 4($fp)			# ... bigparts
	add	$a0, $a0, $v0			# ... &bigparts[*monster_index]
	lw	$a0, ($a0)			# ... bigparts[*monster_index]
	lw	$v0, 16($fp)			# ... edit_monster
	sw	$a0, ($v0)			# *edit_monster = bigparts[*monster_index]
	li	$v0, 4
	syscall

help_make_monster__end_edit:
	la	$a0, help_make_monster__s2	# printf("choose? (y/n): ");
	li	$v0, 4				#
	syscall					#

	li	$v0, 12				# choose = getchar();
	syscall					#

help_make_monster__input_body:
	bne	$v0, '\n', help_make_monster__input_end 
						# while (choose == '\n')
	li	$v0, 12				# choose = getchar();
	syscall					#

	b	help_make_monster__input_body
help_make_monster__input_end:

	beq	$v0, 'y', help_make_monster__yes# if (choose == 'y')
	beq	$v0, 'Y', help_make_monster__yes# if (choose === 'Y')
	b	help_make_monster__no		# else
help_make_monster__yes:
	lw	$a0, 20($fp)			# ... choosing
	lw	$v0, ($a0)			# ... *choosing
	add	$v0, $v0, 1			# *choosing++;
	sw	$v0, ($a0)			#

	b	help_make_monster__done
help_make_monster__no:
	lw	$a0, 12($fp)			# ... monster_index
	lw	$v0, ($a0)			# ... *monster_index
	add	$v0, $v0, 1			# ... monster_index + 1
	lw	$a0, nparts			# ... nparts
	rem	$v0, $v0, $a0			# ... (monster_index + 1) % nparts
	lw	$a0, 12($fp)			# ... monster_index
	sw	$v0, ($a0)			# *monster_index = (monster_index + 1) % nparts
	

help_make_monster__done:

help_make_monster__epilogue:
	lw	$fp, ($sp)			# ... restore old $fp
	add	$sp, $sp, 4			# ... deallocate old $fp
	jr	$ra				# return

##############
## PROVIDED ##
##############

# function arguments
# ($fp+28) [int is_mini]
# ($fp+24) [int choosing]
# ($fp+20) [int leg]
# ($fp+16) [int arm]
# ($fp+12) [int body]
# ($fp+8) [int head]
# ($fp+4) [struct monster *monster]
# stack frame
# ($fp) [old $fp]
# ($fp-4) [caller save $ra]
# ($fp-8) [char **bigparts]
# ($fp-12) [char **miniparts]
# ($fp-16) [char **edit_monster]
# ($fp-20) [int *monster_index]
make_monster:
make_monster__prologue:
	sub	$sp, $sp, 4			# ... allocate $fp
	sw	$fp, ($sp)			# ... save $fp
	move	$fp, $sp			# ... new stack frame
	sub	$sp, $sp, 20			# ... allocate locals + caller saved
	sw	$ra, -4($fp)			# ... caller save $ra
make_monster__body:
	lw	$a0, 24($fp)			# switch (choosing)
	beq	$a0, HEAD, make_monster__case_head
						# case HEAD:
	beq	$a0, BODY, make_monster__case_body
						# case BODY:
	beq	$a0, ARMS, make_monster__case_arms
						# case ARMS:
	beq	$a0, LEGS, make_monster__case_legs
						# case LEGS:
	beq	$a0, DONE, make_monster__case_done 
						# case DONE:
	b	make_monster__case_end
make_monster__case_head:
	la	$a0, heads			# ... heads
	sw	$a0, -8($fp)			# bigparts = heads;

	la	$a0, miniheads			# ... miniheads
	sw	$a0, -12($fp)			# miniparts = miniheads;

	la	$a0, 8($fp)			# ... &head
	sw	$a0, -20($fp)			# monster_index = &head;

	lw	$a0, 4($fp)			# ... monster
	add	$a0, $a0, HEAD_OFFSET		# ... &monster->head
	sw	$a0, -16($fp)			# edit_monster = &monster->head;

	b	make_monster__case_end		# break;
make_monster__case_body:
	la	$a0, bodies			# ... bodies
	sw	$a0, -8($fp)			# bigparts = bodies;

	la	$a0, minibodies			# ... minibodies
	sw	$a0, -12($fp)			# miniparts = minibodies;

	la	$a0, 12($fp)			# ... &body
	sw	$a0, -20($fp)			# monster_index = &body;

	lw	$a0, 4($fp)			# ... monster
	add	$a0, $a0, BODY_OFFSET		# ... &monster->body
	sw	$a0, -16($fp)			# edit_monster = &monster->body;

	b	make_monster__case_end		# break;
make_monster__case_arms:
	la	$a0, arms			# ... arms
	sw	$a0, -8($fp)			# bigparts = arms;

	la	$a0, miniarms			# ... miniarms
	sw	$a0, -12($fp)			# miniparts = miniarms;

	la	$a0, 16($fp)			# ... &arm
	sw	$a0, -20($fp)			# monster_index = &arm;

	lw	$a0, 4($fp)			# ... monster
	add	$a0, $a0, ARMS_OFFSET		# ... &monster->arms
	sw	$a0, -16($fp)			# edit_monster = &monster->arms;

	b	make_monster__case_end		# break;
make_monster__case_legs:
	la	$a0, legs			# ... legs
	sw	$a0, -8($fp)			# bigparts = legs;

	la	$a0, minilegs			# ... minilegs
	sw	$a0, -12($fp)			# miniparts = minilegs;

	la	$a0, 20($fp)			# ... &leg
	sw	$a0, -20($fp)			# monster_index = &leg;

	lw	$a0, 4($fp)			# ... monster
	add	$a0, $a0, LEGS_OFFSET		# ... &monster->legs
	sw	$a0, -16($fp)			# edit_monster = &monster->legs;

	b	make_monster__case_end		# break;
make_monster__case_done:
	b	make_monster__epilogue		# return;
	
make_monster__case_end:
	# --- ($fp-20) [int *monster_index] -- #
	# ----- allocate another 24 bytes ---- #
	sub	$sp, $sp, 24
	# --------- ($fp-24) [is_mini] ------- #
	lw	$a0, 28($fp)
	sw	$a0, -24($fp)
	# -------- ($fp-28) [&choosing] ------ #
	la	$a0, 24($fp)
	sw	$a0, -28($fp)
	# ------ ($fp-32) [edit_monster] ----- #
	lw	$a0, -16($fp)
	sw	$a0, -32($fp)
	# ----- ($fp-36) [monster_index] ----- #
	lw	$a0, -20($fp)
	sw	$a0, -36($fp)
	# ------- ($fp-40) [miniparts] ------- #
	lw	$a0, -12($fp)
	sw	$a0, -40($fp)
	# -------- ($fp-44) [bigparts] ------- #
	lw	$a0, -8($fp)
	sw	$a0, -44($fp)
	# ------ call help_make_monster ------ #
	# jal	cs1521__monster__dump_stack
	jal	help_make_monster
	# ---------- clean up stack ---------- #
	add	$sp, $sp, 24


	# --- ($fp-20) [int *monster_index] -- #
	# ----- allocate another 28 bytes ---- #
	sub	$sp, $sp, 28
	# --------- ($fp-24) [is_mini] ------- #
	lw	$a0, 28($fp)
	sw	$a0, -24($fp)
	# -------- ($fp-28) [choosing] ------- #
	lw	$a0, 24($fp)
	sw	$a0, -28($fp)
	# ---------- ($fp-32) [leg] ---------- #
	lw	$a0, 20($fp)
	sw	$a0, -32($fp)
	# ---------- ($fp-36) [arm] ---------- #
	lw	$a0, 16($fp)
	sw	$a0, -36($fp)
	# ---------- ($fp-40) [body] --------- #
	lw	$a0, 12($fp)
	sw	$a0, -40($fp)
	# ---------- ($fp-44) [head] --------- #
	lw	$a0, 8($fp)
	sw	$a0, -44($fp)
	# --------- ($fp-48) [monster] ------- #
	lw	$a0, 4($fp)
	sw	$a0, -48($fp)
	# --------- call make_monster -------- #
	# jal	cs1521__monster__dump_stack
	jal	make_monster
	# ---------- clean up stack ---------- #
	add	$sp, $sp, 28

make_monster__epilogue:
	lw	$ra, -4($fp)			# ... restore $ra
	add	$sp, $sp, 20			# ... deallocate locals + caller saved
	lw	$fp, ($sp)			# ... restore $fp
	add	$sp, $sp, 4			# ... deallocate $fp
	jr	$ra				# return;

##############
## PROVIDED ##
##############

# function arguments
# ($fp+16) [monster.legs]
# ($fp+12) [monster.body]
# ($fp+8) [monster.arms]
# ($fp+4) [monster.head]
# stack frame
# ($fp) [old $fp]
# ($fp-4) [$ra]
print_monster:
print_monster__prologue:
	sub	$sp, $sp, 4			# ... allocate $fp
	sw	$fp, ($sp)			# ... save $fp
	move	$fp, $sp			# ... new stack frame
	sub	$sp, $sp, 4			# ... allocate for caller saved $ra
	sw	$ra, -4($fp)			# ... save $ra
print_monster__body:
	# ----- ($fp-4) [saved $ra] ---- #
	# -- allocate another 4 bytes -- #
	sub	$sp, $sp, 4
	# --- ($fp-8) [monster.head] --- #
	lw	$a0, 4($fp)	
	sw	$a0, -8($fp)
	# ------- call print_head ------ #
	jal	print_head
	# ------- clean up stack ------- #
	add	$sp, $sp, 4

	# ----- ($fp-4) [saved $ra] ---- #
	# -- allocate another 8 bytes -- #
	sub	$sp, $sp, 8
	# --- ($fp-8) [monster.arms] --- #
	lw	$a0, 8($fp)
	sw	$a0, -8($fp)
	# --- ($fp-12) [monster.body] -- #
	lw	$a0, 12($fp)
	sw	$a0, -12($fp)
	# ------- call print_body ------ #
	jal	print_body
	# ------- clean up stack ------- #
	add	$sp, $sp, 8


	# ----- ($fp-4) [saved $ra] ---- #
	# -- allocate another 4 bytes -- #
	sub	$sp, $sp, 4
	# --- ($fp-8) [monster.legs] --- #
	lw	$a0, 16($fp)	
	sw	$a0, -8($fp)
	# ------- call print_legs ------ #
	jal	print_legs
	# ------- clean up stack ------- #
	add	$sp, $sp, 4
print_monster__epilogue:
	lw	$ra, -4($fp)			# ... restore $ra
	add	$sp, $sp, 4			# ... deallocate $ra
	lw	$fp, ($sp)			# ... restore $fp
	add	$sp, $sp, 4			# ... deallocate $fp
	jr	$ra				# return;

