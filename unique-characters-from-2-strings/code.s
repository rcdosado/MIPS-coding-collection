        .data
msg1:	.asciiz "Enter first string:"
msg2:	.asciiz "Enter second string:"
msg3:	.asciiz "Unique chars are :"
str1:	.space 50
str2:	.space 50
uniq:	.space 25
num:	.word 0
i:		.word 0

#s1:		.asciiz	"monday morning"
#s2:		.asciiz	"coffee spills"

        .text
        .globl main
main:   

		li		$v0, 4        # syscall 4 (print_str)
		la		$a0, msg1     # argument: string
		syscall             # print  string

		li		$v0, 8        # syscall 8 (get_str)
		la		$a0, str1     # argument: string
		li		$a1,49        # max # of chars
		syscall             # get string


		li		$v0, 4        # syscall 4 (print_str)
		la		$a0, msg2     # argument: string
		syscall             # print  string

		li		$v0, 8        # syscall 8 (get_str)
		la		$a0, str2     # argument: string
		li		$a1,49        # max # of chars
		syscall             # get string		

		sub		$sp,$sp,4    
		la		$t0,str1
		sw		$t0,4($sp)
		jal		removeNL
		add		$sp,$sp,4

		sub		$sp,$sp,4
		la		$t0,str2
		sw		$t0,4($sp)
		jal		removeNL
		add		$sp,$sp,4

		
		la		$s0,str1			
		la		$s1,str2
		la		$t6,uniq
loop1:
		lb		$t0,0($s0)
	#--------if c is existing-----------------
		sub		$sp,$sp,4

		sw		$t0,4($sp)
		sw		$s1,8($sp)
		jal		doExist
		lw		$t5,4($sp)

		add		$sp,$sp,4

		beqz	$t5,next
	#----------if c is !existing in uniq---------------------
		sub		$sp,$sp,4

		sw		$t0,4($sp)
		la		$s3,uniq
		sw		$s3,8($sp)
		jal		doExist
		lw		$t5,4($sp)

		add		$sp,$sp,4
		bnez		$t5,next			
	#------------------------------
		
		lw		$t5,i
		addi	$t5,$t5,1
		sw		$t5,i		              #increment and store i counter

		sb		$t0,0($t6)	          #store uniq character to $t6
		addi	$t6,$t6,1	            # $t6++
next:
		addi	$s0,$s0,1	            # increment to string address
		lb		$t0,0($s0)
		bnez	$t0,loop1
prints:
			
		sub		$sp,$sp,4
		la		$t0,uniq
		sw		$t0,4($sp)
		jal		getLength
		sw		$s0,num
		add		$sp,$sp,4

		li		$v0, 4		            # syscall 4 (print_str)
		la		$a0, msg3	            # argument: string
		syscall				              # print  string

		la		$t0,num
		li		$v0,1
		lw		$a0,0($t0)
		syscall				              # print integer


bye:		
		li $v0,10			              # terminate
		syscall

###############################################
#		#returns 1 if searcher byte exists in searchee string,
#		#else 0,to $s0
#		modifies s4-s6
##############################################
doExist:
		sub		$sp,$sp,4             #save return address
		sw		$ra,4($sp)


		lw		$s4, 8($sp)           #get param1
		lw		$s5, 12($sp)          #get param2
test:
		lb		$s6, 0($s5)           #get byte from string
		beqz	$s6,ret0
		beq		$s4,$s6,ret1          #if byte $t0 exists in string 
		addi	$s5, $s5, 1           #$s3 then return 1
		j		  test
ret0:
		li		$s4,0                 #otherwise return 0
		sw		$s4,8($sp)
		j		  done
ret1:
		li		$s4,1
		sw		$s4,8($sp)
done:
		lw		$ra,4($sp)
		add		$sp,$sp,4	
		jr		$ra

###############################################
#	returns length in $s0
##############################################
getLength:
		sub		$sp,$sp,4	         # save return address
		sw		$ra,4($sp)

		li		$s0, 0
		lw		$s1, 8($sp)
test1:
		lb		$s2, 0($s1)
		beqz	$s2, done1
		addi	$s0, $s0, 1
		addi	$s1, $s1, 1
		j		  test1
done1:
		lw		$ra,4($sp)
		add		$sp,$sp,4	
		jr		$ra
###############################################
#	replaces last byte of the string with zero
##############################################
removeNL:
		sub		$sp,$sp,4	         # save return address
		sw		$ra,4($sp)

		lw		$s1, 8($sp)
test2:
		lb		$s2, 0($s1)
		beqz	$s2, done2
		addi	$s1, $s1, 1
		j		  test2
done2:
		sub		$s1,$s1,1
		xor		$t0,$t0,$t0
		sb		$t0,0($s1)
		lw		$ra,4($sp)
		add		$sp,$sp,4	
		jr		$ra


###############################################
printString:
		
		sub		$sp,$sp,4           # save return address
		sw		$ra,4($sp)

		lw		$t0,8($sp)          # get parameter
	
		li		$v0, 4              # syscall 4 (print_str)
		move	$a0, $t0            # argument: string
		syscall                   # print  string
	
		lw		$ra,4($sp)
		add		$sp,$sp,4		
		jr		$ra		
