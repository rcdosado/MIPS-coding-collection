.data

msg1:     .asciiz "Enter a number:"
msg2:     .asciiz "\nNegative Count:"
msg3:     .asciiz "\nPositive count:"
msg4:     .asciiz "\n----------------"

input:    .word 0
negCount: .word 0
posCount: .word 0

.text

.globl main

main:
		
		sw $zero,input
		sw $zero,negCount
		sw $zero,posCount
repeat:
		li $v0, 4         # syscall 4 (print_str)
		la $a0, msg1      # argument: string
		syscall           # print  string

		li $v0,5          #get int
		syscall

		sw $v0,input      #store to num1

		lw $t0,input      #load 
		bgez $t0,posi	    #go to posi if input >= zero

		lw $t1,negCount
		addu $t1,$t1,$t0	#negCount+=input
		sw $t1,negCount
		
		b repeat		        #branch to rep

posi:		
    lw $t0,input
		beq $t0,$zero,brk

		lw $t1,posCount
		addu $t1,$t1,$t0	#posCount+=input
		sw $t1,posCount
		b	repeat
		
brk:		              #report part
		li $v0, 4		      # syscall 4 (print_str)
		la $a0, msg4		  # argument: string
		syscall			      # print  string	

		li $v0, 4		      # syscall 4 (print_str)
		la $a0, msg2		  # argument: string
		syscall			      # print  string		

		li $v0,1
		lw $a0,negCount
		syscall			      #print integer

		li $v0, 4		      # syscall 4 (print_str)
		la $a0, msg3		  # argument: string
		syscall			      # print  string		

		li $v0,1
		lw $a0,posCount
		syscall			      #print integer

		li $v0,10		      #terminate
		syscall



		
		



