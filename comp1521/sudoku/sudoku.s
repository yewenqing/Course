#######################################################################################
######################### COMP1521 25T3 ASSIGNMENT 1: Sudoku ##########################
##                                                                                   ##
## !!! IMPORTANT !!!                                                                 ##
## Before starting work on the assignment, make sure you set your tab-width to 8!    ##
## It is also suggested to indent with tabs only.                                    ##
## Instructions to configure your text editor can be found here:                     ##
##   https://cgi.cse.unsw.edu.au/~cs1521/current/resources/mips-editors.html         ##
## !!! IMPORTANT !!!                                                                 ##
##                                                                                   ##
## This program was written by WENQING YE (z5696814)                                 ##
## on 18/10/2025                                                             	     ##
##                                                                                   ##
## HEY! HEY YOU! Fill this header comment in RIGHT NOW!!! Don't miss out on that     ##
## precious style mark!!      >:O                                                    ##


########################################
## CONSTANTS: REQUIRED FOR GAME LOGIC ##
########################################
TRUE = 1
FALSE = 0

MAX_NUM_DIGITS = 16
MAX_BOARD_LEN = 16
NUM_BOARD_SIZE_OPTS = 3

MIN_FILL_LEN = 9

DIFF_EASY = 1
DIFF_MEDIUM = 2
DIFF_HARD = 3
DIFF_EXTREME = 4

HIDDEN_FACTOR = 5
DIFF_GRADIENT = 10

NUM_DIFFICULTY_OPTS = 4

HINT_KEY = 'i'
HELP_KEY = 'h'
EXIT_KEY = 'q'
SOLUTION_KEY = 's'
ENTER_KEY = 'e'

BOARD_VERTICAL_SEPERATOR = '|'
BOARD_CROSS_SEPERATOR = '+'
BOARD_HORIZONTAL_SEPERATOR = '-'
BOARD_SPACE_SEPERATOR = ' '

MAX_MISTAKES = 10
MAX_HINTS = 10

INVALID = 12
ALREADY_FILLED = 13
MISTAKE =  14
SUCCESS = 15

GAME_STATE_PLAYING = 0
GAME_STATE_OVER = 1
GAME_STATE_WON = 2

UNSET = '#'

#################################################
## CONSTANTS: PLEASE USE THESE FOR YOUR SANITY ##
#################################################

SIZEOF_INT = 4
SIZEOF_PTR = 4
SIZEOF_CHAR = 1

##########################################################
# struct board_tracker {				 #
#     int is_filled_row[MAX_BOARD_LEN][MAX_NUM_DIGITS];  #
#     int is_filled_col[MAX_BOARD_LEN][MAX_NUM_DIGITS];  #
#     int is_filled_box[MAX_NUM_DIGITS][MAX_NUM_DIGITS]; #
#     char board[MAX_BOARD_LEN][MAX_BOARD_LEN];		 #
# };							 #
##########################################################

SIZEOF_BOARD = SIZEOF_CHAR * MAX_BOARD_LEN * MAX_BOARD_LEN
SIZE_OF_IS_FILLED = SIZEOF_INT * MAX_BOARD_LEN * MAX_BOARD_LEN

IS_FILLED_ROW_OFFSET = 0
IS_FILLED_COL_OFFSET = SIZE_OF_IS_FILLED
IS_FILLED_BOX_OFFSET = IS_FILLED_COL_OFFSET + SIZE_OF_IS_FILLED
BOARD_OFFSET = IS_FILLED_BOX_OFFSET + SIZE_OF_IS_FILLED

SIZEOF_BOARD_TRACKER = BOARD_OFFSET + SIZEOF_BOARD

###################
## END CONSTANTS ##
###################

########################################
## DO NOT MODIFY THE .DATA SECTION!!! ##
## DO NOT MODIFY THE .DATA SECTION!!! ##
## DO NOT MODIFY THE .DATA SECTION!!! ##
## DO NOT MODIFY THE .DATA SECTION!!! ##
## DO NOT MODIFY THE .DATA SECTION!!! ##
## DO NOT MODIFY THE .DATA SECTION!!! ##
## DO NOT MODIFY THE .DATA SECTION!!! ##
########################################


######################
## GLOBAL VARIABLES ##
######################

	.data

############################################
# char digit_chars[] = "123456789ABCDEFG"; #
############################################

digit_chars:
	.asciiz "123456789ABCDEFG"

###############################
# char cmd_waiting[] = "> "; #
##############################

cmd_waiting:
	.asciiz "> "

########################################
# int board_size_opts[3] = {4, 9, 16}; #
########################################

board_size_opts:
	.word 4, 9, 16

#########################################################
# int difficulty_opts[4] = {    		        #
# 	DIFF_EASY, DIFF_MEDIUM, DIFF_HARD, DIFF_EXTREME #
# };                                                    #
#########################################################

difficulty_opts:
	.word DIFF_EASY, DIFF_MEDIUM, DIFF_HARD, DIFF_EXTREME

###################
# int board_size; #
###################

board_size:
	.align 2
	.space 4

################
# int box_len; #
################

box_len:
	.align 2
	.space 4

###################
# int difficulty; #
###################

difficulty:
	.align 2
	.space 4

####################
# int random_seed; #
####################

random_seed:
	.align 2
	.space 4

###################
# int game_state; #
###################

game_state:
	.align 2
	.space 4

#################
# int mistakes; #
#################

mistakes:
	.align 2
	.space 4

###################
# int hints_used; #
###################

hints_used:
	.align 2
	.space 4

########################
# int cells_remaining; #
########################

cells_remaining:
	.align 2
	.space 4

################################
# struct board_tracker solver; #
################################

solver:
	.align 2
	.space SIZEOF_BOARD_TRACKER

################################
# struct board_tracker puzzle; #
################################

puzzle:
	.align 2
	.space SIZEOF_BOARD_TRACKER

###########################################
## int random_digits[MAX_BOARD_LEN]; ##
###########################################
random_digits:
	.align 2
	.space SIZEOF_INT * MAX_BOARD_LEN


###########################################
## int is_digit_used[MAX_BOARD_LEN]; ##
###########################################
is_digit_used:
	.align 2
	.space SIZEOF_INT * MAX_BOARD_LEN

########################################
## DO NOT MODIFY THE .DATA SECTION!!! ##
## DO NOT MODIFY THE .DATA SECTION!!! ##
## DO NOT MODIFY THE .DATA SECTION!!! ##
## DO NOT MODIFY THE .DATA SECTION!!! ##
## DO NOT MODIFY THE .DATA SECTION!!! ##
## DO NOT MODIFY THE .DATA SECTION!!! ##
## DO NOT MODIFY THE .DATA SECTION!!! ##
########################################

##########################
## END GLOBAL VARIABLES ##
##########################

####################
## STATIC STRINGS ##
####################

str_print_welcome_1:
        .asciiz "Welcome to Sudoku!\n"

str_print_welcome_2:
        .asciiz "To enter a number, use: "

str_print_welcome_3:
        .asciiz " <row> <col> <number>\n"

str_print_welcome_4:
        .asciiz "To get a hint, use: "

str_print_welcome_5:
        .asciiz "To see this message again, use: "

str_print_welcome_6:
        .asciiz "To exit, use: "

str_print_welcome_7:
        .asciiz "You can use up to "

str_print_welcome_8:
        .asciiz " hints.\n"

str_print_welcome_9:
        .asciiz "If you make more than "

str_print_welcome_10:
        .asciiz " mistakes, you lose :(\n\n"

str_game_loop_win:
	.asciiz "You win!\n"

str_game_loop_lose:
	.asciiz"Game over :(\n"

str_initialise_game_size_opts:
	.asciiz "Board size options: 4 => 4x4, 9 => 9x9, 16 => 16x16\n"

str_initialise_game_size_prompt:
	.asciiz "Enter a board size: "

str_initialise_game_size_err:
	.asciiz "Invalid board size, choose from  4 => 4x4, 9 => 9x9, 16 => 16x16.\n"

str_initialise_game_diff_opts:
	.asciiz "Difficulty options: 1 => easy, 2 => medium, 3 => hard, 4 => extreme\n"

str_initialise_game_diff_prompt:
	.asciiz "Enter a difficulty level: "

str_initialise_game_diff_err:
	.asciiz "Invalid difficulty, choose from 1 => easy, 2 => medium, 3 => hard, 4 => extreme.\n"

str_initialise_game_seed_prompt:
	.asciiz "Enter a random seed: "

str_process_cmd_remaining:
	.asciiz " cells remaining...\n"

str_process_command_mistakes:
	.asciiz  " mistakes before game over.\n"

str_process_command_hints:
	.asciiz " hints used.\n"

str_process_cmd_no_more_hints:
	.asciiz "No more hints :(\n"

str_process_cmd_unknown:
	.asciiz "Unknown command: "

str_hint_msg_1:
	.asciiz "HINT: "

str_hint_msg_2:
	.asciiz " at ("

str_hint_msg_3:
	.asciiz ", "

str_hint_msg_4:
	.asciiz ")\n"

str_hint_msg_5:
	.asciiz " hints used, "

str_hint_msg_6:
	.asciiz " left.\n"

str_do_enter_invalid:
	.asciiz "Invalid row, column or digit.\n"

str_do_enter_filled:
	.asciiz "Cell is already filled.\n"

str_do_enter_mistake:
	.asciiz "Mistake!\n"

str_do_enter_success:
	.asciiz "Success!!\n"


########################################
## DO NOT MODIFY THE .DATA SECTION!!! ##
## DO NOT MODIFY THE .DATA SECTION!!! ##
## DO NOT MODIFY THE .DATA SECTION!!! ##
## DO NOT MODIFY THE .DATA SECTION!!! ##
## DO NOT MODIFY THE .DATA SECTION!!! ##
## DO NOT MODIFY THE .DATA SECTION!!! ##
## DO NOT MODIFY THE .DATA SECTION!!! ##
########################################

########################
## END STATIC STRINGS ##
########################

	.text

############################################################
####                                                    ####
####   Your journey begins here, intrepid adventurer!   ####
####                                                    ####
############################################################

##############
## SUBSET 0 ##
##############

#####################
## int main(void); ##
#####################

################################################################################
# .TEXT <main>
	.text
main:
	# Subset:   0
	#
	# Frame:    [ra]   <-- FILL THESE OUT!
	# Uses:     [v0]
	# Clobbers: [v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

main__prologue:
	begin
	push	$ra

main__body:


	jal	print_welcome	# print_welcome();

    	jal	initialise_game

    	jal	generate_puzzle

    	jal	game_loop

	li	$v0, 0		# return 0
main__epilogue:
	pop	$ra
	end
	jr	$ra

###########################
## void print_welcome(); ##
###########################

################################################################################
# .TEXT <print_welcome>
	.text
print_welcome:
	# Subset:   0
	#
	# Frame:    [ra]   <-- FILL THESE OUT!
	# Uses:     [a0, v0]
	# Clobbers: [a0, v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

print_welcome__prologue:
	begin
	push	$ra
print_welcome__body:
	li	$v0, 4				# syscall 4: print_string
	la	$a0, str_print_welcome_1	#
	syscall					# 




	li	$v0, 4				# syscall 4: print_string
	la	$a0, str_print_welcome_2	#
	syscall					# 

	li	$v0, 11				# syscall 11: print_char	
	li	$a0, 'e'			#
	syscall	

	li	$v0, 4				# syscall 4: print_string
	la	$a0, str_print_welcome_3	#
	syscall					# 


	li	$v0, 4				# syscall 4: print_string
	la	$a0, str_print_welcome_4	#
	syscall					# 


	li	$v0, 11				# syscall 11: print_char	
	li	$a0, 'i'			#
	syscall					# putchar('\n');

	li	$v0, 11				# syscall 11: print_char	
	li	$a0, '\n'			#
	syscall					# putchar('\n');

	li	$v0, 4				# syscall 4: print_string
	la	$a0, str_print_welcome_5	#
	syscall					# 

	li	$v0, 11				# syscall 11: print_char	
	li	$a0, 'h'			#
	syscall					# putchar('\n');

	li	$v0, 11				# syscall 11: print_char	
	li	$a0, '\n'			#
	syscall					# putchar('\n');

	li	$v0, 4				# syscall 4: print_string
	la	$a0, str_print_welcome_6	#
	syscall					# 

	li	$v0, 11				# syscall 11: print_char	
	li	$a0, 'q'			#
	syscall					# putchar('1');

	li	$v0, 11				# syscall 11: print_char	
	li	$a0, '\n'			#
	syscall					# putchar('\n');

	li	$v0, 4				# syscall 4: print_string
	la	$a0, str_print_welcome_7	#
	syscall					# 


	li	$v0, 1				# syscall 1: print_int
	li	$a0, 10				#
	syscall	
	


	li	$v0, 4				# syscall 4: print_string
	la	$a0, str_print_welcome_8	#
	syscall					# 




	li	$v0, 4				# syscall 4: print_string
	la	$a0, str_print_welcome_9	#
	syscall					# 

	li	$v0, 1				# syscall 1: print_int
	li	$a0, 10				#
	syscall	

	li	$v0, 4				# syscall 4: print_string
	la	$a0, str_print_welcome_10	#
	syscall					# 




print_welcome__epilogue:
	pop	$ra
	end
	jr	$ra

########################################
## int get_box_num(int row, int col); ##
########################################

################################################################################
# .TEXT <get_box_num>
	.text
get_box_num:
	# Subset:   0
	#
	# Frame:    [...]   <-- FILL THESE OUT!
	# Uses:     [v1]
	# Clobbers: [t0, t1, t2, v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   t0: row
	#	t1: col
	#	t2: temp result
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

get_box_num__prologue:
	begin
get_box_num__body:
	move 	$t0, $a0      # t0 = row
	move 	$t1, $a1      # t1 = col
	lw		$t3, box_len	#t3 : box_len
	# row = row / box_len
	div 	$t0, $t3       # t0 / box_len
	mflo 	$t0           # t0 = row / box_len

	# col = col / box_len
	div 	$t1, $t3
	mflo 	$t1           # t1 = col / box_len

	# t2 = col * box_len
	mul 	$t2, $t1, $t3

	# t2 = row + col * box_len
	add 	$t2, $t0, $t2

	move 	$v0, $t2

get_box_num__epilogue:
	end
	jr	$ra

##############
## SUBSET 1 ##
##############

#########################################################
## int in_bounds(int num);			       ##
#########################################################

################################################################################
# .TEXT <in_bounds>
	.text
in_bounds:
	# Subset:   1
	#
	# Frame:    [...]   <-- FILL THESE OUT!
	# Uses:     [a0, v0, t1, t2, t3, t4]
	# Clobbers: [a0, v0, t1, t2, t3, t4]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - t0 : num
	#   - t1 = (num >= 0 )
	#   - t4 = board_size
	#   - t2 = (num < board_size)
	#
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

in_bounds__prologue:
	begin
in_bounds__body:
	move	$t0, $a0		# t0 : num
	sge	$t1, $t0, $zero		# t1 = (num >= 0 )
	lw	$t4, board_size		# t4 = board_size
	slt	$t2, $t0, $t4		# t2 = (num < board_size)
	and	$t3, $t1, $t2 
	move	$v0, $t3


in_bounds__epilogue:
	end
	jr	$ra

######################################
## int find_box_len(int total_len); ##
######################################

################################################################################
# .TEXT <find_box_len>
	.text
find_box_len:
	# Subset:   1
	#
	# Frame:    [...]   <-- FILL THESE OUT!
	# Uses:     [a0, t0, t1, t2]
	# Clobbers: [t0, t1, t2]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - t0: i
	#	- t2: 2
	#
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

find_box_len__prologue:
	begin
find_box_len__body:
find_box_len__body__loop_init:
	move	$t0, $a0	# t0 = total_len
	li	$t1, 2
	div	$t0, $t1			
	mtlo	$t0		# t0 = total_len / 2 = i


find_box_len_loop_cond:
	blt	$t0, $zero, find_box_len_loop_return_false	# if (i < 0) return FALSE;

find_box_len_loop_body:    
	mul	$t2, $t0, $t0	#t2 = i * i
	beq	$t2, $a0, find_box_len_loop_return_i	# if (i * i == total_len) return i;
find_box_len_loop_next:    
    	add	$t0, $t0, -1	# i--;
    	j	find_box_len_loop_cond;



find_box_len_loop_return_false: 
	li	$v0, 0
	j	find_box_len__end

find_box_len_loop_return_i:   
	move	$v0, $t0
	j	find_box_len__end
find_box_len__end:

find_box_len__epilogue:
	end
	jr	$ra

#######################
## void game_loop(); ##
#######################

################################################################################
# .TEXT <game_loop>
	.text
game_loop:
	# Subset:   1
	#
	# Frame:    [...]   <-- FILL THESE OUT!
	# Uses:     [a0, t0, t1, t2]
	# Clobbers: [a0, t0, t1, t2]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - 
	#
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

game_loop__prologue:
	begin
	push	$ra

game_loop__body:

game_loop_loop:

	lw	$t0, game_state			# t0 = game_state

	# if (game_state != GAME_STATE_PLAYING)
	li	$t1, GAME_STATE_PLAYING
	bne	$t0, $t1, game_loop_end

	# body
	jal	process_command
	jal	update_game_state

	j	game_loop_loop


game_loop_end:
	lw	$t0, game_state			
	li	$t1, GAME_STATE_WON
	li	$t2, GAME_STATE_OVER

	# if (game_state == GAME_STATE_WON)
	beq	$t0, $t1, print_win

	# if (game_state == GAME_STATE_OVER)
	beq	$t0, $t2, print_lose

	j	game_loop__epilogue


print_win:
	li	$v0, 4
	la	$a0, str_game_loop_win
	syscall
	j	game_loop__epilogue


print_lose:
	li	$v0, 4
	la	$a0, str_game_loop_lose
	syscall


game_loop__epilogue:
	pop	$ra
	end
	jr	$ra

###############################
## void update_game_state(); ##
###############################

################################################################################
# .TEXT <update_game_state>
	.text
update_game_state:
	# Subset:   1
	#
	# Frame:    [...]   <-- FILL THESE OUT!
	# Uses:     [t0, t1, t2, t3 ,t4, t5, t6, t7]
	# Clobbers: [t0, t1, t2, t3 ,t4, t5, t6, t7]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

update_game_state__prologue:


update_game_state__body:
    	lw 	$t0, game_state
    	li 	$t1, GAME_STATE_PLAYING
    	li 	$t2, GAME_STATE_OVER
    	li	$t3, GAME_STATE_WON
    	li 	$t5, MAX_MISTAKES
    	lw 	$t6, cells_remaining
    	lw	$t7, mistakes

    	# if (game_state != GAME_STATE_PLAYING) return;
    	bne $t0, $t1, update_game_state__epilogue

    	# if (mistakes > MAX_MISTAKES)
    	bgt $t7, $t5, update_game_state__maxmistakes

    	# if (cells_remaining == 0)
    	beq $t6, $zero, update_game_state__won

    	# else: keep playing
    	j update_game_state__epilogue

update_game_state__maxmistakes:
    	sw $t2, game_state
    	j update_game_state__epilogue

update_game_state__won:
    	sw $t3, game_state
    	j update_game_state__epilogue

update_game_state__epilogue:
    	jr $ra
########################################################################
## int option_is_valid(int value, int *option_list, int num_options); ##
########################################################################

################################################################################
# .TEXT <option_is_valid>
	.text
option_is_valid:
	# Subset:   1
	#
	# Frame:    [...]   <-- FILL THESE OUT!
	# Uses:     [s0,a1,a2,t0]
	# Clobbers: [t0, t1, t2, t3]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - a0: int value
	#   - a1: int *option_list	
	#   - a2: int num_option
	#   - t0: int i
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

option_is_valid__prologue:
option_is_valid__body:	

option_is_valid_loop_init:
    	li	$t0, 0	# int i = 0;
option_is_valid_loop_cond:
	# if (i >= num_options) goto option_is_valid_loop_end;
    	bge	$t0, $a2, option_is_valid_loop_end_false

option_is_valid_loop_body:
    	# if (value != option_list[i]) goto option_is_valid_loop_end_true
	mul		$t2, $t0, 4
	add		$t1, $a1, $t2	# t1 = option_list[i]
	lw		$t3, ($t1)

	beq		$a0, $t3, option_is_valid_loop_end_true
option_is_valid_loop_next:
	addi	$t0, $t0, 1	# i++;
    	j	option_is_valid_loop_cond    # goto option_is_valid_loop_cond;
option_is_valid_loop_end_false:
    	li		$v0, 0
	j		option_is_valid__epilogue
option_is_valid_loop_end_true:
	li		$v0, 1
	j		option_is_valid__epilogue
option_is_valid__epilogue:
	jr	$ra

#############################
## void generate_puzzle(); ##
#############################

################################################################################
# .TEXT <generate_puzzle>
	.text
generate_puzzle:
	# Subset:   1
	#
	# Frame:    [...]   <-- FILL THESE OUT!
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

generate_puzzle__prologue:
	begin
	push	$ra
generate_puzzle__body:
	# initialise_board_tracker(&solver);
	la	$a0, solver
	jal	initialise_board_tracker
	# initialise_digit_choices(random_digits);
	la	$a0, random_digits
	jal	initialise_digit_choices
	# solve(&solver, 0, 0);
	la	$a0, solver
	li	$a1, 0
	li	$a2, 0
	jal	solve
	# make_user_puzzle();
	jal	make_user_puzzle 
    

    

 

    

generate_puzzle__epilogue:
	
	pop	$ra

	end
	jr	$ra		# return

#############################
## void initialise_game(); ##
#############################

################################################################################
# .TEXT <initialise_game>
	.text
initialise_game:
	# Subset:   1
	#
	# Frame:    [...]   <-- FILL THESE OUT!
	# Uses:     [s0,s1, s2, a0, a1, a2, v0]
	# Clobbers: [s0,s1, s2, a0, a1, a2, v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - s0: board_size
	#	- s1: user_diffculty
	#   - s2: user_random_seed
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

initialise_game__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2
initialise_game__body:
    # int user_difficulty;
    # int user_board_size;
    # int user_random_seed;

initialise_game_loop_init:
initialise_game_loop_cond:
initialise_game_loop_body:
	li	$v0, 4				#   syscall 4: print_string
	la	$a0, str_initialise_game_size_opts			#
	syscall					#   printf("Board size options: 4 => 4x4, 9 => 9x9, 16 => 16x16\n")

	li	$v0, 4				#   syscall 4: print_string
	la	$a0, str_initialise_game_size_prompt			#
	syscall					#   printf("Enter a board size: ");


	li	$v0, 5				#   syscall 5: read_int
	syscall					#
	move	$s0, $v0		#  scanf(" %d", &user_board_size);



	sw	$s0, 	board_size	# board_size = user_board_size;


#        if (!option_is_valid(user_board_size, board_size_opts, NUM_BOARD_SIZE_OPTS)) {
#            goto initialise_game_loop_next_Invalid_board_size;
#        }
	move	$a0, $s0		
	la		$a1, board_size_opts
	li		$a2, NUM_BOARD_SIZE_OPTS

	jal		option_is_valid
	move	$t0, $v0
	beq		$t0, $zero, initialise_game_loop_next_Invalid_board_size

        
        

	li	$v0, 4				#   syscall 4: print_string
	la	$a0, str_initialise_game_diff_opts			#
	syscall					#   printf("Difficulty options: 1 => easy, 2 => medium, 3 => hard, 4 => extreme\n");

	li	$v0, 4				#   syscall 4: print_string
	la	$a0, str_initialise_game_diff_prompt		#
	syscall					#   printf("Enter a difficulty level: ");
        
	li	$v0, 5				#   syscall 5: read_int
	syscall					#
	move	$s1, $v0		#   scanf(" %d", &user_difficulty);   

	sw		$s1, difficulty	# difficulty = user_difficulty;    
       
#        if (!option_is_valid(user_difficulty, difficulty_opts, NUM_DIFFICULTY_OPTS)) {
#            goto initialise_game_loop_next_Invalid_difficulty;
#        }
	move	$a0, $s1
	la		$a1, difficulty_opts
	li		$a2, NUM_DIFFICULTY_OPTS
	jal		option_is_valid
	beq		$v0, $zero, initialise_game_loop_next_Invalid_difficulty


	j		initialise_game_loop_end	# goto initialise_game_loop_end;



initialise_game_loop_next_Invalid_board_size:
	li	$v0, 4				#   syscall 4: print_string
	la	$a0, str_initialise_game_size_err			#
	syscall					#   printf("Invalid board size, choose from  4 => 4x4, 9 => 9x9, 16 => 16x16.\n");

	j	initialise_game_loop_cond	# goto initialise_game_loop_cond;   
            
             
initialise_game_loop_next_Invalid_difficulty:
	li	$v0, 4				#   syscall 4: print_string
	la	$a0, str_initialise_game_diff_err			#
	syscall					#   printf("Invalid difficulty, choose from 1 => easy, 2 => medium, 3 => hard, 4 => extreme.\n");

            
    	j    initialise_game_loop_cond   # goto initialise_game_loop_cond;    


initialise_game_loop_end:

	li	$v0, 4				#   syscall 4: print_string
	la	$a0, str_initialise_game_seed_prompt			#
	syscall					#  printf("Enter a random seed: ");

	li	$v0, 5				#   syscall 5: read_int
	syscall					#
	move	$s2, $v0		#   scanf(" %d", &user_random_seed);   

	sw	$s2, random_seed	# random_seed = user_random_seed;

    	# box_len = find_box_len(board_size);
	move	$a0, $s0
	jal	    find_box_len      
	sw	$v0, box_len
        

	# game_state = GAME_STATE_PLAYING;
	li	$t1, GAME_STATE_PLAYING
	sw	$t1, game_state		
        
	li	$t0, 0
	sw	$t0, mistakes

	li	$t0, 0
	sw	$t0, hints_used

initialise_game__epilogue:
	pop		$s2
	pop		$s1 
	pop		$s0
	pop		$ra
	jr	$ra	# return

##############
## SUBSET 2 ##
##############

####################################
## char cell_display_char(int c); ##
####################################

################################################################################
# .TEXT <cell_display_char>
	.text
cell_display_char:
	# Subset:   2
	#
	# Frame:    [...]   <-- FILL THESE OUT!
	# Uses:     [a0, t0, t1, v0]
	# Clobbers: [t0, t1, v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - t0: tmp result
	#   - t1: tmp result
	#   - a0: int c
	#
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

cell_display_char__prologue:
cell_display_char__body:
    	# if (c == UNSET) goto cell_display_char_return_space;

	li	$t0, UNSET
	beq	$a0, $t0, cell_display_char_return_space


    	# if (c > '0') goto cell_display_char_return_c_1;
	li	$t0, '0'
	bgt	$a0, $t0, cell_display_char_return_c_1


    	j cell_display_char_return_defaut;
cell_display_char_return_space:
    	li	$v0, ' '    # return ' ';
	j	cell_display_char__epilogue;
cell_display_char_return_c_1:
	addi	$v0, $a0, -1        # return c - 1;
	j	cell_display_char__epilogue;
cell_display_char_return_defaut:
	la	$t0, digit_chars	# t0: digit_chars[0];

	add	$t1, $a0, $t0		# t1: digit_chars[c]
	lb	$v0, ($t1)
	j	cell_display_char__epilogue;      # return digit_chars[c];
cell_display_char__epilogue:
	jr	$ra

######################################################################
## void initialise_board(char board[MAX_BOARD_LEN][MAX_BOARD_LEN]); ##
######################################################################

################################################################################
# .TEXT <initialise_board>
	.text
initialise_board:
	# Subset:   2
	#
	# Frame:    [...]   <-- FILL THESE OUT!
	# Uses:     [a0,t0, t1, t2]
	# Clobbers: [t0, t1, t2]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - a0: char board[MAX_BOARD_LEN][MAX_BOARD_LEN]
	#	- t0: row
	#	- t1: col	
	#	- t2: tem result	
	#	- t3: tem result	
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

initialise_board__prologue:
initialise_board__body:

initialise_board_outloop_init:
    	li	$t0, 0		# int row = 0;
    	li	$t1, 0		# int col = 0;

initialise_board_outloop_cond:
	# if (row >= MAX_BOARD_LEN) goto initialise_board_outloop_end;
	li	$t2, MAX_BOARD_LEN
	bge	$t0, $t2, initialise_board_outloop_end
	# goto initialise_board_outloop_body;
initialise_board_outloop_body:
    	# goto initialise_board_inloop_init;

initialise_board_inloop_init:
    	li	$t1, 0		# col = 0;
    	# goto initialise_board_inloop_cond;

initialise_board_inloop_cond:
    	# if (col >= MAX_BOARD_LEN) goto initialise_board_inloop_end;
	li 	$t2, MAX_BOARD_LEN
	bge	$t1, $t2, initialise_board_inloop_end
    	# goto initialise_board_inloop_body;

initialise_board_inloop_body:
    	# board[row][col] = UNSET;
    	mul 	$t2, $t0, MAX_BOARD_LEN   # t2 = row * MAX_BOARD_LEN
    	add 	$t2, $t2, $t1             # t2 = row * MAX_BOARD_LEN + col
    	add 	$t2, $a0, $t2             # t2 = base + offset
    	li  	$t3, UNSET
    	sb  	$t3, 0($t2)               # board[row][col] = UNSET (char)
initialise_board_inloop_next:
    	add	$t1, $t1, 1    # col++;
    	j	initialise_board_inloop_cond    # goto initialise_board_inloop_cond;

initialise_board_inloop_end:
    	# goto initialise_board_outloop_next;


initialise_board_outloop_next:
    	add	$t0, $t0, 1	# row++;
    	j	initialise_board_outloop_cond	# goto initialise_board_outloop_cond;

initialise_board_outloop_end:
        # return;

initialise_board__epilogue:
	jr	$ra

#################################################################
## void initialise_digit_choices(int digit_options[MAX_BOARD_LEN]); ##
#################################################################

################################################################################
# .TEXT <initialise_digit_choices>
	.text
initialise_digit_choices:
	# Subset:   2
	#
	# Frame:    [ra,s0,s1,s2,s3,s4 ]   <-- FILL THESE OUT!
	# Uses:     [s0,s1,s2,s3,s4,t0,t1,t2,t3,t4,v0, a0]
	# Clobbers: [s0,s1,s2,s3,s4,t0,t1,t2,t3,t4,v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - s0: i
	#   - s1: board_size
	#   - s2: is_digit_used
	#   - s3: int digit_options
	#   - s4: digit
	#   - t0: tmp result
	#   - t1: tmp result	
	#   - t2: tmp result		
	#   - t3: tmp result
	#   - t4: tmp result	
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

initialise_digit_choices__prologue:
	push	$ra
	push	$s0
	push	$s1	
	push	$s2	
	push	$s3
	push	$s4
initialise_digit_choices__body:
	move	$s3, $a0	# s3: int digit_options

   	# int i;
    	# int digit;
    # goto initialise_digit_choices_loop1_init;
initialise_digit_choices_loop1_init:
        li	$s0, 0	# i = 0;
        # goto initialise_digit_choices_loop1_cond;

initialise_digit_choices_loop1_cond:
        # if (i >= board_size) goto initialise_digit_choices_loop1_end;
	lw	$s1, board_size
	bge	$s0, $s1,  initialise_digit_choices_loop1_end
        # goto initialise_digit_choices_loop1_body;
initialise_digit_choices_loop1_body:
        # is_digit_used[i] = FALSE;
	la	$s2, is_digit_used
	mul	$t3, $s0, 4
	add	$t3, $s2, $t3
	li	$t4, 0
	sw	$t4, ($t3)

        # goto initialise_digit_choices_loop1_next;
initialise_digit_choices_loop1_next:
        addi	$s0, $s0, 1	# i++;
        j	initialise_digit_choices_loop1_cond	# goto initialise_digit_choices_loop1_cond;

initialise_digit_choices_loop1_end:
        # goto initialise_digit_choices_loop2_init;

initialise_digit_choices_loop2_init:
       	li	$s0, 0	  # i = 0;
initialise_digit_choices_loop2_cond:
        # if (i >= board_size) goto initialise_digit_choices_loop2_end;
	bge	$s0, $s1, initialise_digit_choices_loop2_end
        # goto initialise_digit_choices_loop2_body;
initialise_digit_choices_loop2_body:
        # goto initialise_digit_choices_loop3_init;

initialise_digit_choices_loop3_init:
        # goto initialise_digit_choices_loop3_body;

initialise_digit_choices_loop3_body:
        # digit = random_in_range(0, board_size - 1);

	li	$a0, 0
	move	$a1, $s1	
	addi	$a1, $a1, -1
	jal	 random_in_range
	move	$s4, $v0	#s4: digit
        # goto initialise_digit_choices_loop3_cond;

initialise_digit_choices_loop3_cond:
        # if (is_digit_used[digit]) goto initialise_digit_choices_loop3_next;
	mul	$t0, $s4, 4
	add	$t0, $s2, $t0	# t0: is_digit_used[digit]
	li	$t1, 1
	lw	$t2, ($t0)
	beq	$t2, $t1, initialise_digit_choices_loop3_next
        j	initialise_digit_choices_loop3_end	# goto initialise_digit_choices_loop3_end;

initialise_digit_choices_loop3_next:
        j	initialise_digit_choices_loop3_body	# goto initialise_digit_choices_loop3_body;

initialise_digit_choices_loop3_end:
        # digit_options[i] = digit;
	#   - s0: i
	#   - s1: board_size
	#   - s2: is_digit_used
	#   - s3: int digit_options
	#   - s4: digit
	mul	$t0, $s0, 4
	add	$t0, $s3, $t0	# t0: digit_options[i]
	sw	$s4, ($t0)

        # is_digit_used[digit] = TRUE;
	li	$t0, TRUE
	mul	$t1, $s4, 4
	add	$t1, $t1, $s2	#t1: is_digit_used[digit]
	sw	$t0, ($t1)
        # goto initialise_digit_choices_loop2_next;
initialise_digit_choices_loop2_next:
        add	$s0, $s0, 1	# i++;
        j	initialise_digit_choices_loop2_cond # goto initialise_digit_choices_loop2_cond;
initialise_digit_choices_loop2_end:
        #return;

initialise_digit_choices__epilogue:
	pop	$s4
	pop	$s3
	pop	$s2
	pop	$s1
	pop	$s0	
	pop	$ra		
	jr	$ra

######################################################################
## int is_cell_filled(struct board_tracker *tracker, int x, int y); ##
######################################################################

################################################################################
# .TEXT <is_cell_filled>
	.text
is_cell_filled:
	# Subset:   2
	#
	# Frame:    [ra, s0, s1, s2]   <-- FILL THESE OUT!
	# Uses:     [s0, s1, s2, t0, t1, t2, t3, v0]
	# Clobbers: [s0, s1, s2, t0, t1, t2, t3, v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - s0： tracker
	#   - s1： x
	#   - s2： y
	#   - t0： tracker->board		
	#   - t1： MAX_BOARD_LEN 
	#   - t2： &board[x][y]		
	#   - t3： tmp result	
	#   - t4： tmp result			
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

is_cell_filled__prologue:
	push	$s0
	push	$s1
	push	$s2
is_cell_filled__body:
	move    $s0, $a0          # tracker
	move    $s1, $a1          # x
	move    $s2, $a2          # y

	addi    $t0, $s0, BOARD_OFFSET  # t0 = &tracker->board

	li      $t1, MAX_BOARD_LEN       # 
	mul     $t2, $s1, $t1           # x * row_len
	add     $t2, $t2, $s2           # x*row + y
	add     $t2, $t2, $t0           # &board[x][y]

	lb      $t4, 0($t2)             # t4 = board[x][y]
	li      $t3, UNSET
	bne     $t4, $t3, is_cell_filled_return_true
	j	is_cell_filled_return_false

is_cell_filled_return_true:
        li	$v0, TRUE	# return TRUE;
	j	is_cell_filled__epilogue
is_cell_filled_return_false:
        li	$v0, FALSE	# return FALSE;
	j	is_cell_filled__epilogue

is_cell_filled__epilogue:	
	pop	$s2
	pop	$s1
	pop	$s0
	jr	$ra

###################################################
## int handle_move(int row, int col, int digit); ##
###################################################

################################################################################
# .TEXT <handle_move>
	.text
handle_move:
# .TEXT <is_cell_filled>
	.text
	# Subset:   2
	#
	# Frame:    [ra, s0, s1, s2]   <-- FILL THESE OUT!
	# Uses:     [s0, s1, s2, t0. a0, a1, a2, a3, v0]
	# Clobbers: [s0, s1, s2, t0. a0, a1, a2, a3, v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - s0： row
	#   - s1： col
	#   - s2： digit
	#   - t0： tmp result		
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

handle_move__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2		
handle_move__body:
	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2
    	# if (!in_bounds(row)) goto handle_move_return_INVALID;
	move	$a0, $s0
	jal	in_bounds
	beq	$v0, $zero, handle_move_return_INVALID
    	# if (!in_bounds(col)) goto handle_move_return_INVALID;
	move	$a0, $s1
	jal	in_bounds
	beq	$v0, $zero, handle_move_return_INVALID	
    	# if (!in_bounds(digit)) goto handle_move_return_INVALID;
	move	$a0, $s2
	jal	in_bounds
	beq	$v0, $zero, handle_move_return_INVALID	
	#   - s0： row
	#   - s1： col
	#   - s2： digit

    	# if (is_cell_filled(&puzzle, row, col)) goto handle_move_return_ALREADY_FILLED; 
	la	$a0, puzzle
	move	$a1, $s0
	move	$a2, $s1 
	jal	is_cell_filled
	bne	$v0, $zero, handle_move_return_ALREADY_FILLED	
   	# if (is_valid_digit(&puzzle, row, col, digit)) goto handle_move_return_SUCCESS;
	la	$a0, puzzle
	move	$a1, $s0
	move	$a2, $s1 
	move	$a3, $s2
	jal	is_valid_digit
	bne	$v0, $zero, handle_move_return_SUCCESS
	# else goto handle_move_return_MISTAKE;
	j	handle_move_return_MISTAKE
handle_move_return_INVALID:
        li	$v0, INVALID	# return INVALID;
	j	handle_move__epilogue

handle_move_return_ALREADY_FILLED:
       	li	$v0, ALREADY_FILLED	# return ALREADY_FILLED;
	j	handle_move__epilogue   


handle_move_return_SUCCESS:
	# update_cell(&puzzle, row, col, digit);
	la	$a0, puzzle
	move	$a1, $s0
	move	$a2, $s1
	move	$a3, $s2
	jal	update_cell

        # cells_remaining--;
	lw	$t0, cells_remaining
	addi	$t0, $t0, -1
	sw	$t0, cells_remaining

       	li	$v0, SUCCESS	# return SUCCESS;
	j	handle_move__epilogue 

        
handle_move_return_MISTAKE:
        # mistakes++;
	lw	$t0, mistakes	
	addi	$t0, $t0, 1
	sw	$t0, mistakes
       	li	$v0, MISTAKE	# return MISTAKE;
	j	handle_move__epilogue     

            


handle_move__epilogue:
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra		
	jr	$ra
##############
## SUBSET 3 ##
##############

######################################################################################
## void update_cell(struct board_tracker *check, int row, int col, char new_digit); ##
######################################################################################

################################################################################
# .TEXT <update_cell>
	.text
update_cell:
	# Subset:   3
	#
	# Frame:    [ra, s0,s1,s2,s3,s4,s5,s6]   <-- FILL THESE OUT!
	# Uses:     [s0,s1,s2,s3,s4,s5,s6,t0,t1,t2]
	# Clobbers: [s0,s1,s2,s3,s4,s5,s6,t0,t1,t2]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - s0: struct board_tracker *check
	#   - s1: int row
	#   - s2: int col
	#   - s3: char new_digit
	#   - s4: int box
	#   - s5: int dig
	#   - s6: int use_digit
	#   
	#
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

update_cell__prologue:
	push	$ra 
	push	$s0
	push	$s1
	push	$s2
	push	$s3 
	push	$s4 
	push	$s5
	push	$s6 

update_cell__body:
	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2
	move	$s3, $a3

	# int box = get_box_num(row, col);
	move	$a0, $s1
	move	$a1, $s2
	jal	get_box_num
	move	$s4, $v0

    	# int dig = new_digit;
	move	$s5, $s3

    	# int use_digit = TRUE;
	li	$s6, TRUE

    	# if (new_digit == UNSET) goto update_cell_new_digit_UNSET;
	li	$t0, UNSET
	beq	$s3, $t0, update_cell_new_digit_UNSET
    	j	update_cell_dig_CHECK # goto update_cell_dig_CHECK;

update_cell_new_digit_UNSET:
        # dig = check->board[row][col];
	addi    $t0, $s0, BOARD_OFFSET  # t0 = &tracker->board
	mul	$t2, $s1, MAX_BOARD_LEN
	add	$t2, $t2, $s2
	add	$t2, $t0, $t2		# t2: &board[row][col]
	lb	$t1, ($t2)
	move	$s5, $t1
	

        # use_digit = FALSE;
	li	$s6, FALSE

update_cell_dig_CHECK:
        # if (dig == UNSET) return;
	li	$t0, UNSET
	beq	$s5, $t0, update_cell__epilogue
        j	update_cell_update	# goto update_cell_update;

update_cell_update:
        # check->board[row][col] = new_digit;
	addi    $t0, $s0, BOARD_OFFSET  # t0 = &tracker->board
	mul	$t2, $s1, MAX_BOARD_LEN
	add	$t2, $t2, $s2
	add	$t2, $t0, $t2		# t2: &board[row][col]
	sb	$s3, ($t2)
	# int is_filled_row[][]
	#   - s0: struct board_tracker *check
	#   - s1: int row
	#   - s2: int col
	#   - s3: char new_digit
	#   - s4: int box
	#   - s5: int dig
	#   - s6: int use_digit
	#   - s7: &board[row][col]	
        # check->is_filled_row[row][dig] = use_digit;
	addi    $t0, $s0, IS_FILLED_ROW_OFFSET  # t0 = &tracker->is_filled_row
	mul	$t1, $s1, MAX_BOARD_LEN		# t1 = row * MAX_BOARD_LEN
	add	$t1, $t1, $s5			# t1 = row * MAX_BOARD_LEN + dig
	mul	$t1, $t1, 4
	add	$t1, $t1, $t0			# t1: &is_filled_row[row][dig]
	sw	$s6, ($t1)

        # check->is_filled_col[col][dig] = use_digit;
	addi    $t0, $s0, IS_FILLED_COL_OFFSET  # t0 = &tracker->is_filled_col
	mul	$t1, $s2, MAX_BOARD_LEN
	add	$t1, $t1, $s5			# t1 = MAX_BOARD_LEN * col + dig 
	mul	$t1, $t1, 4
	add	$t1, $t1, $t0			# t1: &is_filled_col[col][dig]
	sw	$s6, ($t1)	
        # check->is_filled_box[box][dig] = use_digit;
	addi    $t0, $s0, IS_FILLED_BOX_OFFSET  # t0 = &tracker->is_filled_box
	mul	$t1, $s4, MAX_BOARD_LEN		# t1 = box * MAX_BOARD_LEN
	add	$t1, $t1, $s5			# t1 = MAX_BOARD_LEN * col + dig 
	mul	$t1, $t1, 4
	add	$t1, $t1, $t0			# t1: &is_filled_col[col][dig]
	sw	$s6, ($t1)		

    	j	update_cell__epilogue		# return;
update_cell__epilogue:

	pop	$s6 
	pop	$s5 
	pop	$s4 
	pop	$s3 
	pop	$s2 
	pop	$s1 
	pop	$s0 
	pop	$ra
	jr	$ra

#############################################################
## int solve(struct board_tracker *tracker, int x, int y); ##
#############################################################

################################################################################
# .TEXT <solve>
	.text
solve:
	# Subset:   3
	#
	# Frame:    [ra,s0,s1,s2,s3,s4,s5,s6]   <-- FILL THESE OUT!
	# Uses:     [s0,s0,s1,s2,s3,s4,s5,s6,a0,a1,a2]
	# Clobbers: [s0,s0,s1,s2,s3,s4,s5,s6,a0,a1,a2]]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - s0: struct board_tracker *tracker
	#   - s1: int x
	#   - s2: int y
	#   - s3: board_size
	#   - s4: i
	#   - s5: &random_digit
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

solve__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2
	push	$s3
	push	$s4
	push	$s5
	push	$s6

solve__body:
	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2
    	# int i;
    	# int dig; 
    	# if (x >= board_size) goto solve_return_true;
	lw	$s3, board_size
	bge	$s1, $s3, solve_return_true
    	# if (y == board_size) goto solve_return_1;
	beq	$s2, $s3, solve_return_1

    	# if (is_cell_filled(tracker, x, y)) goto solve_return_2;
	move	$a0, $s0
	move	$a1, $s1 
	move	$a2, $s2 
	jal	is_cell_filled
	bne	$v0, $zero, solve_return_2
    	j	solve_loop_init	# goto solve_loop_init;


solve_return_true:
	li	$v0, TRUE
        j	solve__epilogue	# return TRUE;

solve_return_1:    
	# return solve(tracker, x + 1, 0);
	move	$a0, $s0
	move	$a1, $s1
	addi	$a1, $a1, 1
	li	$a2, 0
	jal	solve
	j	solve__epilogue
        

solve_return_2:
        # return solve(tracker, x, y + 1);
	move	$a0, $s0
	move	$a1, $s1
	move	$a2, $s2
	addi	$a2, $a2, 1
	jal	solve
	j	solve__epilogue	
	#   - s0: struct board_tracker *tracker
	#   - s1: int x
	#   - s2: int y
	#   - s3: board_size
	#   - s4: i
	#   - s5: &random_digit
	#   - s6: dig
solve_loop_init:
        li	$s4, 0	# i = 0;
solve_loop_cond:
        # if (i >= board_size) goto solve_loop_end;
	bge	$s4, $s3, solve_loop_end
	# goto solve_loop_body;

solve_loop_body:
        #dig = random_digits[i];
	la	$s5, random_digits
	mul	$t0, $s4, 4
	add	$t0, $s5, $t0	# t0: &random_digits[i]
	lw	$s6, ($t0)

        # if (!is_valid_digit(tracker, x, y, dig)) goto solve_loop_next;
	move	$a0, $s0
	move	$a1, $s1
	move	$a2, $s2
	move	$a3, $s6
	jal	is_valid_digit
	beq	$v0, $zero, solve_loop_next
        
	# update_cell(tracker, x, y, dig);
	move	$a0, $s0
	move	$a1, $s1
	move	$a2, $s2
	move	$a3, $s6
	jal	update_cell

        # if (solve(tracker, x, y + 1)) goto solve_return_true;
	move	$a0, $s0
	move	$a1, $s1
	move	$a2, $s2
	addi	$a2, $a2, 1
	jal	solve
	bne	$v0, $zero, solve_return_true

        # update_cell(tracker, x, y, UNSET);
	move	$a0, $s0
	move	$a1, $s1
	move	$a2, $s2
	li	$a3, UNSET
	jal	update_cell

	#   - s0: struct board_tracker *tracker
	#   - s1: int x
	#   - s2: int y
	#   - s3: board_size
	#   - s4: i
	#   - s5: &random_digit
	#   - s6: dig
solve_loop_next:
        addi	$s4, $s4, 1	# i++;
        j	solve_loop_cond	# goto solve_loop_cond;

solve_loop_end:        
	li	$v0, FALSE
	j	solve__epilogue	# return FALSE;

solve__epilogue:
	pop	$s6
	pop	$s5
	pop	$s4
	pop	$s3
	pop	$s2 
	pop	$s1 
	pop	$s0
	pop	$ra 
	jr	$ra

##############################
## void make_user_puzzle(); ##
##############################

################################################################################
# .TEXT <make_user_puzzle>
	.text
make_user_puzzle:
	# Subset:   3
	#
	# Frame:    [ra, s1,s2,s3,s4,s5]   <-- FILL THESE OUT!
	# Uses:     [s1,s2,s3,s4,s5,t0,t1,t2,t3,t4,a0,a1,a2,a3,v0]
	# Clobbers: [s1,s2,s3,s4,s5,t0,t1,t2,t3,t4,a0,a1,a2,a3,v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - s0: total_cells
	#   - s1: cells_to_show
	#   - s2: num_showing
	#   - s3: n
	#   - s4: row
	#   - s5: col
	#
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

make_user_puzzle__prologue:
	push	$ra 
	push	$s0
	push	$s1 
	push	$s2 
	push	$s3 
	push	$s4 
	push	$s5
make_user_puzzle__body:
	# initialise_board_tracker(&puzzle);
	la	$a0, puzzle
	jal	initialise_board_tracker


    	# int total_cells = board_size * board_size;
	lw	$t0, board_size
	mul	$s0, $t0, $t0


    	# int cells_to_show = total_cells / HIDDEN_FACTOR;
	li	$t0, HIDDEN_FACTOR
	div	$s1, $s0, $t0

    	# cells_to_show += (NUM_DIFFICULTY_OPTS - difficulty) * total_cells / DIFF_GRADIENT + box_len;
	li	$t0, NUM_DIFFICULTY_OPTS
	lw	$t1, difficulty
	sub	$t2, $t0, $t1
	mul	$t3, $s0, $t2
	li	$t4, DIFF_GRADIENT
	div	$t5, $t3, $t4
	lw	$t6, box_len
	add	$t5, $t6, $t5
	add	$s1, $s1, $t5 


    	# int num_showing = 0;
	li	$s2, 0

    	# int n, row, col;
make_user_puzzle_loop_cond:
        # if (num_showing >= cells_to_show) goto make_user_puzzle_loop_end;
	bge	$s2, $s1, make_user_puzzle_loop_end
        # goto make_user_puzzle_loop_body;
make_user_puzzle_loop_body:
        # n = random_in_range(0, total_cells - 1);
	li	$a0, 0
	move	$a1, $s0
	addi	$a1, $a1, -1
	jal	random_in_range
	move	$s3, $v0

        # row = n / board_size;
	lw	$t0, board_size
	div	$s4, $s3, $t0

        # col = n % board_size;    
	rem	$s5, $s3, $t0

        # if (is_cell_filled(&puzzle, row, col)) goto make_user_puzzle_loop_next;
	la	$a0, puzzle
	move	$a1, $s4
	move	$a2, $s5
	jal	is_cell_filled
	bne	$v0, $zero, make_user_puzzle_loop_next

	#   - s0: total_cells
	#   - s1: cells_to_show
	#   - s2: num_showing
	#   - s3: n
	#   - s4: row
	#   - s5: col
        # update_cell(&puzzle, row, col, solver.board[row][col]);
	la	$a0, puzzle
	move	$a1, $s4
	move	$a2, $s5
	la	$t0, solver
	addi	$t0, $t0, BOARD_OFFSET
	mul	$t1, $s4, MAX_BOARD_LEN
	add	$t1, $t1, $s5
	add	$t1, $t0, $t1
	lb	$a3, ($t1)
	jal	update_cell
		
        # num_showing++;
	addi	$s2, $s2, 1

        # goto make_user_puzzle_loop_next;        
make_user_puzzle_loop_next:
        j	make_user_puzzle_loop_cond	# goto make_user_puzzle_loop_cond;

make_user_puzzle_loop_end:
        # cells_remaining = total_cells - num_showing;
	sub	$t0, $s0, $s2
	sw	$t0, cells_remaining



make_user_puzzle__epilogue:
	pop	$s5
	pop	$s4 
	pop	$s3 
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra 
	jr	$ra

######################
## int give_hint(); ##
######################

################################################################################
# .TEXT <give_hint>
	.text
give_hint:
	# Subset:   3
	#
	# Frame:    [ra, s0, s1, s2, s3, s4, s5, s6]   <-- FILL THESE OUT!
	# Uses:     [s0, s1, s2, s3, s4, s5, s6, t0, t1, a0, a1, a2, a3]
	# Clobbers: [s0, s1, s2, s3, s4, s5, s6, t0, t1, a0, a1, a2, a3]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - s0: total_cells
	#   - s1: start
	#   - s2: end
	#   - s3: row
	#   - s4: col
	#   - s5: i
	#   - s6: ans
	#
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

give_hint__prologue:
	push	$ra 
	push	$s0 
	push	$s1  
	push	$s2 
	push	$s3 
	push	$s4  
	push	$s5 
	push	$s6
give_hint__body:

    # if (hints_used == MAX_HINTS) goto give_hint_return_false;
	lw	$t0, hints_used	
	li	$t1, MAX_HINTS	
	beq	$t0, $t1, give_hint_return_false

    # copy_mem(&puzzle, &solver, SIZEOF_BOARD_TRACKER);
	la	$a0, puzzle
	la	$a1, solver
	li	$a2, SIZEOF_BOARD_TRACKER
	jal	copy_mem
    # solve(&solver, 0, 0);
	la	$a0, solver
	li	$a1, 0
	li	$a2, 0
	jal	solve


    # int total_cells = board_size * board_size;
	lw	$t0, board_size
	mul	$s0, $t0, $t0

    # int start = random_in_range(0, total_cells - 1);
	li	$a0, 0
	move	$a1, $s0
	addi	$a1, $a1, -1
	jal	random_in_range
	move	$s1, $v0

    # int end = start + total_cells;
	add	$s2, $s0, $s1

    # int row = 0;
    # int col = 0;
	li	$s3, 0
	li	$s4, 0
    # int i;
    # int ans;
	#   - s0: total_cells
	#   - s1: start
	#   - s2: end
	#   - s3: row
	#   - s4: col
	#   - s5: i
	#   - s6: ans    
give_hint_loop_init:
        # i = start;
	move	$s5, $s1
        # goto give_hint_loop_cond;
give_hint_loop_cond:
        # if (i >= end) goto give_hint_loop_end;
	bge	$s5, $s2, give_hint_loop_end

        # goto give_hint_loop_body;
give_hint_loop_body:
        # row = (i % total_cells) / board_size;
	rem	$t0, $s5, $s0
	lw	$t1, board_size
	div	$s3, $t0, $t1

        # col = i % board_size;
	rem	$s4, $s5, $t1

        # if (!is_cell_filled(&puzzle, row, col)) goto give_hint_loop_end;
	la	$a0, puzzle
	move	$a1, $s3
	move	$a2, $s4
	jal	is_cell_filled
	beq	$v0, $zero, give_hint_loop_end
        # goto give_hint_loop_next;
give_hint_loop_next:
        addi	$s5, $s5, 1	# i++;
        j	give_hint_loop_cond	# goto give_hint_loop_cond;

give_hint_loop_end:
        # ans = solver.board[row][col];
	la	$t0, solver
	addi	$t0, $t0, BOARD_OFFSET
	mul	$t1, $s3, MAX_BOARD_LEN
	add	$t1, $t1, $s4
	add	$t1, $t0, $t1
	lb	$s6, ($t1)	

        # update_cell(&puzzle, row, col, ans);
	la	$a0, puzzle
	move	$a1, $s3
	move	$a2, $s4
	move	$a3, $s6
	jal	update_cell

        # hints_used++;
	lw	$t0, hints_used
	addi	$t0, $t0, 1
	sw	$t0, hints_used

        # cells_remaining--;
	lw	$t0, cells_remaining
	addi	$t0, $t0, -1
	sw	$t0, cells_remaining

        # print_hint_msg(ans, row, col);
	move	$a0, $s6
	move	$a1, $s3
	move	$a2, $s4
	jal	print_hint_msg
        li	$v0, TRUE	# return TRUE;
	j	give_hint__epilogue


give_hint_return_false:
       	li	$v0, FALSE	# return FALSE;    
	j	give_hint__epilogue
    

give_hint__epilogue:
	pop	$s6
	pop	$s5 
	pop	$s4 
	pop	$s3 
	pop	$s2 
	pop	$s1 
	pop	$s0 
	pop	$ra
	jr	$ra


#########################################################
## void copy_mem(void *src, void *dst, int num_bytes); ##
#########################################################

################################################################################
# .TEXT <copy_mem>
	.text
copy_mem:
	# Subset:   3
	#
	# Frame:    [ra, s0, s1, s2, s3, s4, s5]   <-- FILL THESE OUT!
	# Uses:     [a0, a1, a2, s0, s1, s2, s3, s4, s5]
	# Clobbers: [a0, a1, a2, s0, s1, s2, s3, s4, s5]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - s0: int *src_int_ptr 
	#   - s1: int *dst_int_ptr
	#   - s2: int num_bytes
	#   - s3: int i
	#   - s4: char *src_char_ptr;
	#   - s5: char *dst_char_ptr;
	#
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

copy_mem__prologue:
	push	$ra 
	push	$s0
	push	$s1 
	push	$s2 
	push	$s3 
	push	$s4 
	push	$s5
copy_mem__body:
 	# int *src_int_ptr = (int*) src;
	move	$s0, $a0
	# int *dst_int_ptr = (int*) dst;
	move	$s1, $a1

	move	$s2, $a2
   

   
    	# char *src_char_ptr;
    	# char *dst_char_ptr;
    	# int i;

copy_mem_loop1_init:
        li	$s3, 0	# i = 0;

copy_mem_loop1_cond:
        # if (i >= num_bytes / SIZEOF_INT) goto copy_mem_loop1_end;
	li	$t0, SIZEOF_INT
	div	$t1, $s2, $t0
	bge	$s3, $t1, copy_mem_loop1_end

        # goto copy_mem_loop1_body;
copy_mem_loop1_body:
        # *dst_int_ptr = *src_int_ptr;
	lw	$t0, ($s0)
	sw	$t0, ($s1)

        # dst_int_ptr++;
	addi	$s1, $s1, 4

        # src_int_ptr++;
	addi	$s0, $s0, 4
        # goto copy_mem_loop1_next;
copy_mem_loop1_next:
        addi	$s3, $s3, 1	# i++;
        j	copy_mem_loop1_cond	#goto copy_mem_loop1_cond;

    
copy_mem_loop1_end:
        # src_char_ptr = (char*) src_int_ptr;
	move	$s4, $s0
        
	# dst_char_ptr = (char*) dst_int_ptr;
	move	$s5, $s1
       
        # goto copy_mem_loop2_init;

copy_mem_loop2_init:
        li	$s3, 0	# i = 0;
        # goto copy_mem_loop2_cond;

copy_mem_loop2_cond:
        # if (i >= num_bytes % SIZEOF_INT) goto copy_mem_loop2_end;
	rem	$t0, $s2, SIZEOF_INT
	bge	$s3, $t0, copy_mem_loop2_end

        # goto copy_mem_loop2_body;

copy_mem_loop2_body:
        # *dst_char_ptr = *src_char_ptr;
	lb	$t0, ($s4)
	sb	$t0, ($s5)

        # dst_char_ptr++;
	addi	$s5, $s5, 1

        # src_char_ptr++;
	addi	$s4, $s4, 1

        # goto copy_mem_loop2_next

copy_mem_loop2_next:
        addi	$s3, $s3, 1	# i++;
        j	copy_mem_loop2_cond	# goto copy_mem_loop2_cond;

copy_mem_loop2_end:
	j	copy_mem__epilogue
copy_mem__epilogue:
	pop	$s5
	pop	$s4 
	pop	$s3 
	pop	$s2 
	pop	$s1 
	pop	$s0 
	pop	$ra
	jr	$ra

##############
## PROVIDED ##
##############

#######################################################################
## unsigned int random_in_range(unsigned int min, unsigned int max); ##
#######################################################################

################################################################################
# .TEXT <random_in_range>
	.text
random_in_range:
	# Frame:    [None]
	# Uses:     [$v0, $a0, $a1, $t0-$t4]
	# Clobbers: [$v0, $a0, $a1, $t0-$t4]
	#
	# Locals:           
	#   - $a0 unsigned int min
	#   - $a1 unsigned int max
	#   - $t0 int a
	#   - $t1 int c
	#   - $t2 int m
	#
	# Structure:        
	#   random_in_range
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

random_in_range__prologue:
random_in_range__body:
	li	$t0, 103515245		# int a = 103515245;
	li	$t1, 12345		# int c = 12345;
	li	$t2, 2147483647		# int m = 2147483647;

	lw	$t3, random_seed	# random_seed = (a * random_seed + c) % m;
	mul	$t4, $t0, $t3		# .. a * random_seed
	add	$t4, $t4, $t1		# .. a * random_seed + c
	remu	$t4, $t4, $t2		# .. (a * random_seed + c) % m
	sw	$t4, random_seed	#

	add	$t0, $a1, 1		# random_seed % (max - min + 1)
	sub	$t0, $t0, $a0		# 
	rem	$t4, $t4, $t0		# 
	add	$v0, $t4, $a0		# return min + (random_seed % (max - min + 1));
random_in_range__epilogue:
	jr	$ra


#############################
## void process_command(); ##
#############################

################################################################################
# .TEXT <process_command>
	.text
process_command:
	# Frame:    [$ra]
	# Uses:     [$v0, $a0, $t0]
	# Clobbers: [$v0, $a0, $t0]
	#
	# Locals:           
	#   - $t0, command
	#
	# Structure:        
	#   process_command
	#   -> [prologue]
	#       -> body
	#       -> good_parsing_cond
	#       -> good_parsing_end
	#       -> enter
	#       -> help
	#       -> hint
	#       -> default
	#       -> switch_end
	#       -> reprint
	#       -> done
	#   -> [epilogue]

process_command__prologue:
	begin
	push	$ra
process_command__body:
	la	$a0, puzzle				# print_puzzle(puzzle.board);
	add	$a0, $a0, BOARD_OFFSET			#
	jal	print_puzzle				#

	lw	$a0, cells_remaining			# printf("%d cells remaining...\n", cells_remaining);
	li	$v0, 1					#
	syscall						#
							#
	la	$a0, str_process_cmd_remaining		# 
	li	$v0, 4					#
	syscall						#

	lw	$a0, mistakes				# printf("%d/%d mistakes before game over.", mistakes, MAX_MISTAKES);
	li	$v0, 1					#
	syscall						#
							#
	li	$a0, '/'				# 
	li	$v0, 11					#
	syscall						#
							#
	li	$a0, MAX_MISTAKES			# 
	li	$v0, 1					#
	syscall						#
							#
	la	$a0, str_process_command_mistakes	#
	li	$v0, 4					#
	syscall						#

	lw	$a0, hints_used				# printf("%d/%d hints used.");
	li	$v0, 1					#
	syscall						#
							#
	li	$a0, '/'				# 
	li	$v0, 11					#
	syscall						#
							#
	li	$a0, MAX_HINTS				#
	li	$v0, 1					#
	syscall						#
							#
	la	$a0, str_process_command_hints		#
	li	$v0, 4					#
	syscall						#

	la	$a0, cmd_waiting			# printf("%s", cmd_waiting);
	li	$v0, 4					#
	syscall						#

	li	$v0, 12					# char command = getchar()
	syscall						#
	move	$t0, $v0				#

process_command__good_parsing_cond:			# while (char == '\n') {
	bne	$t0, '\n', process_command__good_parsing_end
	li	$v0, 12					# 	command = getchar()
	syscall						#
	move	$t0, $v0				#
	b	process_command__good_parsing_cond	# }
process_command__good_parsing_end:

							# switch (command) {
	bne	$t0, EXIT_KEY, process_command__enter	# case EXIT_KEY:
	li	$v0, 10					# exit(0);
	syscall

process_command__enter:
	bne	$t0, ENTER_KEY, process_command__help	# case ENTER_KEY:
	jal	do_enter				# 	do_enter();
	b	process_command__switch_end		# 	break;

process_command__help:
	bne	$t0, HELP_KEY, process_command__hint	# case HELP_KEY:
	jal	print_welcome				# 	print_welcome();
	b	process_command__switch_end		# 	break;

process_command__hint:
	bne	$t0, HINT_KEY, process_command__default	# case HINT_KEY:
	jal	give_hint				# 	if (!give_hint()) {
	bnez	$v0, process_command__switch_end	#
							#
	li	$v0, 4					# 		printf("No more hints :(\n");
	la	$a0, str_process_cmd_no_more_hints	#
	syscall						#	}
	b	process_command__switch_end		# 	break;

process_command__default:				# default:
	li	$v0, 4					# 	printf("Unknown command: ");
	la	$a0, str_process_cmd_unknown		#
	syscall						#
							#
	li	$v0, 11					# 	printf("%c", command);
	move	$a0, $t0				#	
	syscall						#
							#
	li	$v0, 11					# 	printf("\n");
	li	$a0, '\n'				#
	syscall						#

process_command__switch_end:

	lw	$t0, cells_remaining			# if (!cells_remaining || mistakes > MAX_MISTAKES) {		
	beqz	$t0, process_command__reprint		# 
							#
	lw	$t0, mistakes				#
	bgt	$t0, MAX_MISTAKES, process_command__reprint
							#
	b	process_command__done			#

process_command__reprint:
	la	$a0, puzzle				#	print_puzzle(puzzle.board);
	add	$a0, $a0, BOARD_OFFSET			#
	jal	print_puzzle				# }

process_command__done:
	li	$v0, 11					# printf("\n");
	li	$a0, '\n'
	syscall

process_command__epilogue:
	pop	$ra
	end
	jr	$ra


####################################
## void cell_char_to_num(char c); ##
####################################

################################################################################
# .TEXT <cell_char_to_num>
	.text
cell_char_to_num:
	# Frame:    [None]
	# Uses:     [$v0, $a0]
	# Clobbers: [$v0, $a0]
	#
	# Locals:           
	#   - $a0, int c
	#
	# Structure:        
	#   process_command
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]
cell_char_to_num__prologue:
cell_char_to_num__body:
	sub	$v0, $a0, 'A'				# if (c >= 'A') return c - 'A';
	add	$v0, $v0, 10
	bge	$a0, 'A', cell_char_to_num__epilogue	#

	sub	$v0, $a0, '0'
cell_char_to_num__epilogue:
	jr	$ra

######################
## void do_enter(); ##
######################

################################################################################
# .TEXT <do_enter>
	.text
do_enter:
	# Frame:    [$ra, $s0 - $s2]
	# Uses:     [$v0, $a0 - $a2]
	# Clobbers: [$v0, $a0]
	#
	# Locals:           
	#   - $s0, r, row
	#   - $s0, c, col
	#   - $s0, d, digit
	#   - $v0, move_status
	#
	# Structure:        
	#   process_command
	#   -> [prologue]
	#       -> body
	#       -> filled
	#       -> mistake
	#       -> success
	#   -> [epilogue]

do_enter__prologue:
	begin
	push	$ra
	push	$s0
	push	$s1
	push	$s2
do_enter__body:
	li	$v0, 12				# scanf(" %c", &r);
	syscall					#
	move	$a0, $v0			#
	jal	cell_char_to_num		#
	move	$s0, $v0			#

	li	$v0, 12				# scanf(" %c", &c);
	syscall					#
	move	$a0, $v0			#
	jal	cell_char_to_num		#
	move	$s1, $v0			#

	li	$v0, 12				# scanf(" %d", &dig);
	syscall					#
	move	$a0, $v0			# 
	jal	cell_char_to_num
	move	$s2, $v0

	move	$a0, $s0			# int move_status = handle_move(row, col, digit - 1);
	move	$a1, $s1			#
	sub	$a2, $s2, 1			#
	jal	handle_move			#

	bne	$v0, INVALID, do_enter__filled	# if (move_status == INVALID) {

	li	$v0, 4				# 	printf("Invalid row, column or digit.\n");
	la	$a0, str_do_enter_invalid	# 
	syscall					#
	b	do_enter__epilogue		# 
do_enter__filled:
	bne	$v0, ALREADY_FILLED, do_enter__mistake	# if (move_status == ALREADY_FILLED) {

	li	$v0, 4				# 	printf("Cell is already filled.\n");
	la	$a0, str_do_enter_filled	# 
	syscall					#
	b	do_enter__epilogue		# 
do_enter__mistake:
	bne	$v0, MISTAKE, do_enter__success	# } else if (move_status == MISTAKE) {

	li	$v0, 4				#	printf("Mistake!\n");
	la	$a0, str_do_enter_mistake	#
	syscall					#
	b	do_enter__epilogue		#
do_enter__success:
	bne	$v0, SUCCESS, do_enter__epilogue# } else if (move_status == SUCCESS) {

	li	$v0, 4				#
	la	$a0, str_do_enter_success	# 	printf("Success!!\n");
	syscall					#
	b	do_enter__epilogue		# }

do_enter__epilogue:
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra
	end
	jr	$ra

#####################################################
## void print_hint_msg(int ans, int row, int col); ##
#####################################################

################################################################################
# .TEXT <print_hint_msg>
	.text
print_hint_msg:
	# Frame:    [$ra]
	# Uses:     [$v0, $a0 - $a2, $t0 - $t2]
	# Clobbers: [$v0, $a0 - $a2, $t0 - $t2]
	#
	# Locals:      
	#   - $a0 => $t0, int ans
	#   - $t1, char r     
	#   - $a1, int row
	#   - $t1, char r
	#   - $a2, int col
	#   - $t2, char c
	#
	# Structure:        
	#   print_hint_msg
	#   -> [prologue]
	#       -> body
	#       -> fix_col
	#       -> do_print
	#   -> [epilogue]

print_hint_msg__prologue:
	begin
	push	$ra
	push	$s0
	push	$s1
	push	$s2
print_hint_msg__body:
	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2

	lb	$s1, digit_chars($s1)	# char r = digit_chars[row] - 1;
	sub	$s1, $s1, 1		#
	bne	$s1, '@', print_hint_msg__fix_col
	li	$s1, '9'		#

print_hint_msg__fix_col:
	lb	$s2, digit_chars($s2)	# char c = digit_chars[col] - 1;
	sub	$s2, $s2, 1		#
	bne	$s2, '@', print_hint_msg__do_print
	li	$s2, '9'		#

print_hint_msg__do_print:
	
	li	$v0, 4			# printf("HINT: ")
	la	$a0, str_hint_msg_1	#
	syscall				#

	move	$a0, $s0		# printf("%c", cell_display_char(ans));
	jal	cell_display_char			#
	move	$a0, $v0		#
	li	$v0, 11			#
	syscall				#

	li	$v0, 4			# printf(" at (")
	la	$a0, str_hint_msg_2	#
	syscall				#

	li	$v0, 11			# printf("%c", row)
	move	$a0, $s1		#
	syscall				#

	li	$v0, 4			# printf(", ")
	la	$a0, str_hint_msg_3	#
	syscall				#

	li	$v0, 11			# printf("%c", col)
	move	$a0, $s2		#
	syscall				#

	li	$v0, 4			# printf(")\n")
	la	$a0, str_hint_msg_4	#
	syscall				#

	li	$v0, 1			# printf("%d", hints_used)
	lw	$a0, hints_used		#
	syscall				#

	li	$v0, 4			# printf(" hints used, ")
	la	$a0, str_hint_msg_5	#
	syscall				#

	li	$v0, 1			# printf("%d", MAX_HINTS - hints_used)
	lw	$a0, hints_used		#
	sub	$a0, MAX_HINTS, $a0	#
	syscall

	li	$v0, 4			# printf("left.\n")
	la	$a0, str_hint_msg_6	#
	syscall				#

print_hint_msg__epilogue:
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra
	end
	jr	$ra

###################################################################
## void initialise_board_tracker(struct board_tracker *tracker); ##
###################################################################

################################################################################
# .TEXT <initialise_board_tracker>
	.text
initialise_board_tracker:
	# Frame:    [$ra, $s0]
	# Uses:     [$a0, $t0, $t1, $t2, $t3, $s0]
	# Clobbers: [$a0, $t0, $t1, $t2, $t3]
	#
	# Locals:           
	# 	$s0	struct board_tracker *tracker
	#	$t0	i
	#	$t1	j
	#
	# Structure:        
	#   initialise_board_tracker
	#   -> [prologue]
	#       -> body
	#	-> row
	#	-> col
	#	-> col_end
	#	-> row_end
	#   -> [epilogue]

initialise_board_tracker__prologue:
	begin
	push	$ra
	push	$s0

	move	$s0, $a0
initialise_board_tracker__body:
	add	$a0, $a0, BOARD_OFFSET				# initialise_board(tracker->board);
	jal	initialise_board				#

	li	$t0, 0						# int i = 0;
initialise_board_tracker__row:
	bge	$t0, MAX_BOARD_LEN, initialise_board_tracker__row_end	# while (i < MAX_BOARD_LEN) {

	li	$t1, 0						#	int j = 0;
initialise_board_tracker__col:
	bge	$t1, MAX_BOARD_LEN, initialise_board_tracker__col_end	# 	while (j < MAX_BOARD_LEN) {

	mul	$t2, $t0, MAX_BOARD_LEN				# .. $t2 = i * MAX_BOARD_LEN
	add	$t2, $t2, $t1					# .. $t2 = i * MAX_BOARD_LEN + j
	mul	$t2, $t2, SIZEOF_INT				# .. $t2 = SIZEOF_INT * (i * MAX_BOARD_LEN + j)
	add	$t2, $t2, $s0					# .. $t2 = tracker + SIZEOF_INT * (i * MAX_BOARD_LEN + j)

	li	$t3, FALSE					#
	sw	$t3, IS_FILLED_ROW_OFFSET($t2)			# 		tracker->num_used_row[i][j] = FALSE;
	sw	$t3, IS_FILLED_COL_OFFSET($t2)			# 		tracker->num_used_col[i][j] = FALSE;
	sw	$t3, IS_FILLED_BOX_OFFSET($t2)			# 		tracker->num_used_box[i][j] = FALSE;

	add	$t1, $t1, 1					#		j ++;
	b	initialise_board_tracker__col				#	}
initialise_board_tracker__col_end:

	add	$t0, $t0, 1					#	row ++;
	b	initialise_board_tracker__row				# }
initialise_board_tracker__row_end:


initialise_board_tracker__epilogue:
	pop	$s0
	pop	$ra
	end
	jr	$ra

###################################################################################
## int is_valid_digit(struct board_tracker *check, int row, int col, int digit); ##
###################################################################################

################################################################################
# .TEXT <is_valid_digit>
	.text
is_valid_digit:
	# Frame:    [$ra, $s0, $s1, $s2, $s3]
	# Uses:     [$a0, $a1, $a2, $a3, $t0, $t1, $t2, $s0, $s1, $s2, $s3]
	# Clobbers: [$a0, $a1, $t0, $t1, $t2]
	#
	# Locals:           
	# 	$t0	int box
	# 	$s0	struct board_tracker *check
	# 	$s1	int row
	# 	$s2	int col
	# 	$s3	int digit
	#
	# Structure:        
	#   is_valid_digit
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

is_valid_digit__prologue:
	begin
	push	$ra
	push	$s0
	push	$s1
	push	$s2
	push	$s3

	move	$s0, $a0			# .. $s0 = check
	move	$s1, $a1			# .. $s1 = row
	move	$s2, $a2			# .. $s2 = col
	move	$s3, $a3			# .. $s3 = digit
is_valid_digit__body:
	move	$a0, $s1			# int box = get_box_num(row, col);
	move	$a1, $s2			#
	jal	get_box_num			#
	move	$t0, $v0			# .. $t0 = box


	li	$v0, FALSE			# if (check->num_used_col[col][digit]
	mul	$t1, $s2, MAX_BOARD_LEN		#
	add	$t1, $t1, $s3			# .. $t1 = (col * MAX_BOARD_LEN + digit)
	mul	$t1, $t1, SIZEOF_INT		# .. $t1 *= SIZEOF_INT
	add	$t1, $t1, $s0			# .. $t1 += check
	lw	$t2, IS_FILLED_COL_OFFSET($t1)	#
	bnez	$t2, is_valid_digit__epilogue	#
						#
	mul	$t1, $s1, MAX_BOARD_LEN		# || check->num_used_row[row][digit]
	add	$t1, $t1, $s3			#
	mul	$t1, $t1, SIZEOF_INT		#
	add	$t1, $t1, $s0			#
	lw	$t2, IS_FILLED_ROW_OFFSET($t1)	# 
	bnez	$t2, is_valid_digit__epilogue	# 
						#
	mul	$t1, $t0, MAX_BOARD_LEN		# || check->num_used_box[box][digit])
	add	$t1, $t1, $s3			#
	mul	$t1, $t1, SIZEOF_INT		#
	add	$t1, $t1, $s0			#
	lw	$t2, IS_FILLED_BOX_OFFSET($t1)	#
	bnez	$t2, is_valid_digit__epilogue	# return FALSE;

	li	$v0, TRUE			# else return TRUE;

is_valid_digit__epilogue:
	pop	$s3
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra
	end
	jr	$ra

##################################################################
## void print_puzzle(char board[MAX_BOARD_LEN][MAX_BOARD_LEN]); ##
##################################################################

################################################################################
# .TEXT <print_puzzle>
	.text
print_puzzle:
	# Frame:    [$ra, $s0, $s1]
	# Uses:     [$v0, $a0, $t0, $t1, $s0, $s1]
	# Clobbers: [$v0, $a0, $t0, $t1]
	#
	# Locals:      
	#   - $s0, char board[][]
	#   - $s1, int row   
	#   - $t0, char c
	#   - $t1, char r
	#   - $a2, int col
	#   - $t2, char c
	#
	# Structure:        
	#   print_hint_msg
	#   -> [prologue]
	#       -> cond
	#       -> print
	#       -> index
	#       -> end
	#   -> [epilogue]

print_puzzle__prologue:
	begin
	push	$ra
	push	$s0
	push	$s1
print_puzzle__body:
	move	$s0, $a0			# .. $s0 = board

	li	$v0, 11				# putchar(BOARD_SPACE_SEPERATOR);
	li	$a0, BOARD_SPACE_SEPERATOR	#
	syscall					#

	la	$a0, digit_chars		# print_row(digit_chars);
	jal	print_row			#

	li	$s1, 0				# row = 0;
print_puzzle__row_cond:
	lw	$t0, board_size			# for (int row = 0; row < board_size; row++) {
	bge	$s1, $t0, print_puzzle__row_end #

	lw	$t1, box_len			#	if (row % box_len == 0) {
	rem	$t0, $s1, $t1			#
	bnez	$t0, print_puzzle__row_print	#

	move	$a0, $s1			# 		print_box_separator(row);
	jal	print_box_separator		#
						#	}

print_puzzle__row_print:
	lb	$t0, digit_chars($s1)		# 	char c = digit_chars[row] - 1;
	sub	$t0, $t0, 1

	bne	$t0, '@', print_puzzle__row_index	# if (c == '@') c = '9';
	li	$t0, '9'				#

print_puzzle__row_index:
	li	$v0, 11				#	putchar(c);
	move	$a0, $t0			#
	syscall					#

	mul	$t0, $s1, MAX_BOARD_LEN		#	print_row(board[row]);
	add	$a0, $t0, $s0			#
	jal	print_row			#

	add	$s1, $s1, 1			#	row++;
	b	print_puzzle__row_cond		# }
print_puzzle__row_end:
	move	$a0, $zero			# print_box_separator(0);
	jal	print_box_separator		#

print_puzzle__epilogue:
	pop	$s1
	pop	$s0
	pop	$ra
	end
	jr	$ra


#################################
## void print_row(char row[]); ##
#################################

################################################################################
# .TEXT <print_row>
	.text
print_row:
	# Frame:    [$ra, $s0, $s1]
	# Uses:     [$v0, $a0, $t2, $s0, $s1]
	# Clobbers: [$v0, $a0, $t2]
	#
	# Locals:           
	#   - $s0, char row[]
	#   - $s1, int col
	#   - $t2, int c
	#
	# Structure:        
	#   print_row
	#   -> [prologue]
	#       -> body
	#       -> col_loop
	#       -> print_char
	#       -> do_print_char
	#   -> [epilogue]

print_row__prologue:
	begin
	push	$ra
	push	$s0
	push	$s1
print_row__body:
	move	$s0, $a0
	
	li	$s1, 0		# int col = 0;
print_row__col_loop:		# for (int col = 0; col < board_size; col++) {
	lw	$t2, board_size
	bge	$s1, $t2, print_row__col_loop_end

	lw	$t2, box_len	# if (col % box_len == 0) {
	rem	$t2, $s1, $t2
	bnez	$t2, print_row__print_char

	li	$a0, BOARD_VERTICAL_SEPERATOR	# putchar(BOARD_VERTICAL_SEPERATOR);
	li	$v0, 11
	syscall

	li	$a0, BOARD_SPACE_SEPERATOR	# putchar(BOARD_SPACE_SEPERATOR);
	li	$v0, 11
	syscall

print_row__print_char:

	add	$t2, $s1, $s0			# int c = cell_display_char(row[col]);
	lb	$a0, ($t2)			#
	jal	cell_display_char		#

	bne	$v0, '@', print_row__do_print_char	# if (c == '@') c = '9';
	li	$v0, '9'				#

print_row__do_print_char:
	move	$a0, $v0				# putchar(c);
	li	$v0, 11
	syscall

	li	$a0, BOARD_SPACE_SEPERATOR	# putchar(BOARD_SPACE_SEPERATOR);
	li	$v0, 11
	syscall

	add	$s1, $s1, 1			# col ++;
	b	print_row__col_loop
print_row__col_loop_end:

	li	$a0, BOARD_VERTICAL_SEPERATOR	# putchar(BOARD_VERTICAL_SEPERATOR);
	li	$v0, 11
	syscall

	li	$a0, '\n'			# putchar('\n');
	li	$v0, 11
	syscall

print_row__epilogue:
	pop	$s1
	pop	$s0
	pop	$ra
	end
	jr	$ra


########################################
## void print_box_separator(int row); ##
########################################

################################################################################
# .TEXT <print_box_separator>
	.text
print_box_separator:
	# Frame:    [None]
	# Uses:     [$v0, $a0, $t0 - $t2]
	# Clobbers: [$v0, $a0, $t0 - $t2]
	#
	# Locals:           
	#   - $t1, int row
	#   - $t0, i
	#
	# Structure:        
	#   print_box_separator
	#   -> [prologue]
	#       -> body
	#       -> not_box
	#       -> digits
	#       -> loop
	#       -> horiz
	#       -> loop_end
	#   -> [epilogue]

print_box_separator__prologue:
print_box_separator__body:
	move	$t1, $a0

	li	$a0, BOARD_HORIZONTAL_SEPERATOR	# putchar(BOARD_HORIZONTAL_SEPERATOR);
	li	$v0, 11
	syscall

	lw	$t2, box_len			# if (row % box_len == 0) {
	rem	$t2, $t1, $t2
	bnez	$t2, print_box_separator__not_box

	li	$a0, BOARD_CROSS_SEPERATOR	# putchar(BOARD_CROSS_SEPERATOR);
	li	$v0, 11
	syscall

	li	$a0, BOARD_HORIZONTAL_SEPERATOR	# putchar(BOARD_HORIZONTAL_SEPERATOR);
	li	$v0, 11
	syscall

	b	print_box_separator__digits

print_box_separator__not_box:
	li	$a0, BOARD_VERTICAL_SEPERATOR	# putchar(BOARD_VERTICAL_SEPERATOR);
	li	$v0, 11
	syscall

print_box_separator__digits:

	li	$t0, 0				# int i = 0;
print_box_separator__loop:				# for (int i = 0; i < board_size; i++) {
	lw	$t1, board_size
	bge	$t0, $t1, print_box_separator__loop_end

	lw	$t1, box_len			# if (i % box_len == 0 && i != 0) {
	rem	$t2, $t0, $t1			#
	bnez	$t2, print_box_separator__horiz		#
	beqz	$t0, print_box_separator__horiz		# {

	li	$a0, BOARD_CROSS_SEPERATOR	# putchar(BOARD_VERTICAL_SEPERATOR);
	li	$v0, 11
	syscall

	li	$a0, BOARD_HORIZONTAL_SEPERATOR	# putchar(BOARD_HORIZONTAL_SEPERATOR);
	li	$v0, 11
	syscall

print_box_separator__horiz:
	li	$a0, BOARD_HORIZONTAL_SEPERATOR	# putchar(BOARD_HORIZONTAL_SEPERATOR);
	li	$v0, 11
	syscall

	li	$a0, BOARD_HORIZONTAL_SEPERATOR	# putchar(BOARD_HORIZONTAL_SEPERATOR);
	li	$v0, 11
	syscall

	add	$t0, $t0, 1
	b	print_box_separator__loop

print_box_separator__loop_end:

	li	$a0, BOARD_VERTICAL_SEPERATOR	# putchar(BOARD_VERTICAL_SEPERATOR);
	li	$v0, 11
	syscall

	li	$a0, '\n'			# putchar('\n');
	li	$v0, 11
	syscall
print_box_separator__epilogue:
	jr	$ra
