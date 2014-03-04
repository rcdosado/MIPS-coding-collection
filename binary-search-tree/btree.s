		.data
        
		.text

##---------------------------------------
#	Main function
#   this is entry point of the application
#----------------------------------------
main:

	
exit:
	li	$v0,10
	syscall

#--------------------------------------------------------

#--------------------------------------------------------
printInteger:

	subu	$sp,$sp,8
	sw	$ra,0($sp)
	sw	$a0,4($sp)	
	
	#assuming $a0 contains int to print
	move	$a0,$a1
	li	$v0,1
	syscall

	lw	$a0,4($sp)
	lw	$ra,0($sp)
	addu	$sp,$sp,8
	jr	$ra
#---------------------------------------
#	in:	$a0, the parent node that 
#	on entry:
#	-----------------
#	  node address <-- top of stack
#	-----------------
#	  TOS+4
#	-----------------
#---------------------------------------
printtree:

	sub	$sp,$sp,8
	sw	$a0,0($sp)	#save orig $a0 as new TOS
	sw	$ra,4($sp)	#save return address as TOS+4
	lw	$a0,8($sp)	#access param1 in TOS+8

	j	leftmost

recur:
	sub	$sp,$sp,4	
	lw	$a1,4($a0)	#access node->left
	sw	$a1,0($sp)	#push it to the stack
	jal	printtree

	
	lw	$a1,0($a0)	# $a1 should contain node->data
	jal	printInteger

	#node is assumed to be in $a0
	lw	$a0,8($a0)	#access node->right

leftmost:
	bne	$a0,$zero,recur
	lw	$a0,0($sp)	#hold the previous node
	lw	$ra,4($sp)	#hold the return address
	add	$sp,$sp,12
	jr	$ra
#---------------------------------------
#	goes to the smallest data from a BST
#	in:	push parent node to -> 0($sp)
#	out:	returns the node with smallest data in $a0
#	comment : modifies $a0,restores $t0
#---------------------------------------

locateSmall:
	sub	$sp,$sp,8
	sw	$ra,0($sp)	#save return address
	sw	$t0,4($sp)
	lw	$t0,8($sp)	#load param1
	j	seeIfZero

back1:
	lw	$t0,4($t0)
seeIfZero:
	lw	$a0,4($t0)	#
	bne	$a0,$zero,back1

	lw	$ra,0($sp)
	lw	$t0,4($sp)
	add	$sp,$sp,4
	jr	$ra
#---------------------------------------
#	malloc
#	li $a0 8 #enough space for two integers
#	li $v0 9 #syscall 9 (sbrk)
#	syscall
# 	address of the allocated space is now in $v0
#---------------------------------------
malloc:
	subu	$sp,$sp,4
	sw	$ra,4($sp)

	nop
	nop	
ret0:
	lw	$ra,4($sp)
	add	$sp,$sp,4
	jr	$ra
#---------------------------------------
#	creates 3 nodes containing 1,2,3	
#	returns the top node in $v1
#---------------------------------------
	
build123:


	sub	$sp,$sp,36
	sw	$ra,4($sp)
	sw	$t0,8($sp)
	sw	$t1,12($sp)
	sw	$t2,16($sp)
	sw	$t3,20($sp)
	sw	$t4,24($sp)
	sw	$v0,28($sp)
	sw	$s0,32($sp)
	
	move	$s0,$zero
#-----------add node 2-------------------------

	sub	$sp,$sp,4
	li	$t0,2
	sw	$t0,4($sp)
	jal	newNode
	add	$sp,$sp,4
	
	sw	$v0,nodes($s0)
	add	$s0,4

#-----------add node 1----------------------------
	sub	$sp,$sp,4
	li	$t0,1
	sw	$t0,4($sp)
	jal	newNode
	add	$sp,$sp,4

	sw	$v0,nodes($s0)
	add	$s0,4

#---------- add node 3-----------------------------
	sub	$sp,$sp,4
	li	$t0,3
	sw	$t0,4($sp)
	jal	newNode
	add	$sp,$sp,4

	sw	$v0,nodes($s0)
	add	$s0,4
		
#---------------------------------------

	la	$s0,nodes	#get first nodes storage
	lw	$t0,0($s0)	#get node 2
	lw	$t1,4($s0)	#get node 1
	lw	$t2,8($s0)	#get node 3


#-------linked them --------------------------------
	move	$s0,$t0		#get s0=node2
	sw	$t1,4($s0)	#s0->left=t1	
	sw	$t2,8($s0)	#s0->right=t2

	move	$s0,$t1
	sw	$zero,4($s0)
	sw	$zero,8($s0)
	
	move	$s0,$t2
	sw	$zero,4($s0)
	sw	$zero,8($s0)

	move	$v1,$t0		#returns $v1 the topnode


	lw	$s0,32($sp)
	lw	$v0,28($sp)
	lw	$t4,24($sp)
	lw	$t3,20($sp)
	lw	$t2,16($sp)
	lw	$t1,12($sp)
	lw	$t0,8($sp)
	lw	$ra,4($sp)

	add	$sp,$sp,36
	jr	$ra
	


