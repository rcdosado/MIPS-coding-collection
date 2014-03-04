        .data



msg1:     .asciiz "\nEnter number:"
msg2:     .asciiz "\nEnter 1-10 (other number to terminate)"
msg3:     .asciiz "\nEnter N:"
msg4:     .asciiz	"\nHeres your number : "
msg5:     .asciiz	"\nbye!"

n:        .word	0
ctr:      .word	0
numArray:	.space	44 #11x4
addr:	    .word 0

        .text
        .globl main
main:   
        lw $t0,ctr
        lw $t1,addr
getNum:

        li $v0, 4             # syscall 4 (print_str)
        la $a0, msg1          # argument: string
        syscall               # print  string

        li $v0,5              # get integer
        syscall
        sw $v0,numArray($t1)	# store to address pointed by addr

        addi $t1,$t1,4		    # go next slot

        addi $t0,$t0,1		    # increment counter
        blt	$t0,10,getNum

                              # at this point $t0 holds 10 
                              # and $t1 hold  address numArray[9]
        lw $t2,n
tryagain:
        li $v0, 4		          # syscall 4 (print_str)
        la $a0, msg2		      # argument: string
        syscall		            # print  string
        la $a0, msg3		      # argument: string
        syscall			          # print  string

        li $v0,5		#get N
        syscall
        move $t2,$v0	
        
        
        blt $t2,1,bye		      # if( !(n>=1 && m<=10) )		
        bgt $t2,10,bye

                              # print the index n

        li $v0, 4		          # syscall 4 (print_str)
        la $a0, msg4		      # argument: string
        syscall			          # print  string

        sub $t2,$t2,1		      # index--
        mul	$t2,$t2,4	        # index*=4;

        li $v0,1
        lw $a0,numArray($t2)
        syscall			          # print integer

        b	tryagain
bye:		
        li $v0, 4		          # syscall 4 (print_str)
        la $a0, msg5		      # argument: string
        syscall			          # print  string

        li $v0,10		          # terminate
        syscall
