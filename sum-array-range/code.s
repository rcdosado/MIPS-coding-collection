#--------------------------------------------------------
#		data	area
#--------------------------------------------------------

	.data
msg0:	.asciiz "Welcome User :)" 
msg1:	.asciiz "\nWhat is N?:"
msg2:	.asciiz "\nNow give the values of the array\n"
msg21:	.asciiz	"Input value:"
msg3:	.asciiz "\nWhat are the low and high (must be in 1-N) range\n"
msg4:	.asciiz	"What is the low range:"
msg5:	.asciiz "What is the high range:"
msg6:	.asciiz "\nSum is "

n:	.word 0
ctr:	.word 0


low:	.word	0
high:	.word	0

sum:	.word	0
array:	.space 40



	.text

#--------------------------------------------------------
	#provide $a0 the stringzero 
#--------------------------------------------------------
printStr:

	subu	$sp,$sp,4
	sw	$ra,4($sp)
	
	li	$v0,4
	#assume $a0 contains the address
	#of the string zero
	syscall

	lw	$ra,4($sp)
	addu	$sp,$sp,4
	jr	$ra


#--------------------------------------------------------

#--------------------------------------------------------
sumArray:

	subu	$sp,$sp,4
	sw	$ra,4($sp)
	
	#	ASSUMPTIONS
	#	$a0 first param , points to array
	#	$a1 second param , low integer
	#	$a2 third param , high integer
		
	lw	$t0,0($a0)		#$t0 will hold the first element in array $a0
	beqz	$t0,ret1		#if it points the zero then return
	

	slt	$t1,$a1,$a2      	# checks if $a1 > $a2
	beqz 	$t1,ret1     		# if $a1 > $a2, goes to label1
	beq 	$a1,$a2,ret1	   	# if $a1 = $a2 goes to label2 
	

	sub	$a1,$a1,1
	sub	$a2,$a2,1
	#	$t1 <- $a1
	#	$t2 <- $a2
	move	$t0,$a0
	move	$t1,$a1
	move	$t2,$a2
	li	$t5,0
	
	mul	$t1,$t1,4
	add	$t1,$t1,$t0
	mul	$t2,$t2,4	
	add	$t2,$t2,$t0

	move	$t0,$t1
sumit:	
	bgt	$t1,$t2,gohere

	lw	$t4,0($t0)
	add	$t5,$t5,$t4
	add	$t0,$t0,4
	add	$t1,$t1,4	

	j	sumit
	
gohere:
	move	$v0,$t5
	
ret1:
	lw	$ra,4($sp)
	addu	$sp,$sp,4
	jr	$ra
	

#--------------------------------------------------------
#	allows you to get integer from console
#--------------------------------------------------------
get_integer:

	subu	$sp,$sp,4
	sw	$ra,4($sp)

	li	$v0,5
	syscall
	#returns $v0, the input integer	
	
	lw	$ra,4($sp)
	addu	$sp,$sp,4
	jr	$ra

#--------------------------------------------------------

#--------------------------------------------------------
printInteger:

	subu	$sp,$sp,8
	sw	$ra,4($sp)
	
	#assuming $a0 contains int to print
	li	$v0,1
	syscall
	lw	$ra,4($sp)
	addu	$sp,$sp,8
	jr	$ra

#--------------------------------------------------------

#--------------------------------------------------------
main:
	
	la	$a0,msg0
	jal	printStr
	
	la	$a0,msg1
	jal	printStr

	jal	get_integer
	sw	$v0,n
	
	la	$a0,msg2
	jal	printStr
	
#-----------------------------------
	lw	$t1,n
	beqz	$t1,exit
	
	li	$t0,0
get_input:

	la	$a0,msg21
	jal	printStr

	jal	get_integer	
	sw	$v0,array($t0)
	add	$t0,$t0,4

	sub	$t1,$t1,1
	bgtz	$t1,get_input
#---------------------------------


	la	$a0,msg3
	jal	printStr

	la	$a0,msg4	#what is low?
	jal	printStr
	jal	get_integer
	sw	$v0,low

	la	$a0,msg5	#what is high?
	jal	printStr
	jal	get_integer
	sw	$v0,high

	
	la	$a0,array
	lw	$a1,low
	lw	$a2,high		
	jal	sumArray	
	sw	$v0,sum

	la	$a0,msg6
	jal	printStr
	lw	$a0,sum
	jal	printInteger	
	
	
exit:
	li	$v0,10
	syscall
