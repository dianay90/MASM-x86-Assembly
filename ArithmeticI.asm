TITLE Program 3 (project1.asm)

; Author: Diana Oh 
; Course / Project ID  CS271               Date: 10/27/2017
; Description:

;This program outputs the sum, average, and count of the negative integers entered, if any are entered. Positive integers are discarded. 

; email: ohdi@oregonstate.edu;CS271_400
;Assignment number: Program #3 due October 29


INCLUDE Irvine32.inc

; (insert constant definitions here)

;Constants 

	MIN=-100


	.data

	; (insert variable definitions here)

	intro       BYTE "Welcome to the Integer Accumulator by Diana Oh",0
	termMessage BYTE ". Thank you for playing Integer Acculumator!",0
	enterName   BYTE "What is your name?",0
	outRange	BYTE "Out of range. Please enter a valid number",0
	instruction	BYTE "Please enter numbers in [-100, -1].Enter a non-negative number when you are finished to see results",0
	userName	BYTE  33 DUP(?)
	hello		BYTE "Hello ",0
	goodbye		BYTE "It's been a pleasure to meet you, ",0
	noValid		BYTE "No valid integers were entered. ",0

	
	youEntered	BYTE "You entered ",0
	validNumber	BYTE " valid numbers ",0
	theSum		BYTE "The sum of your valid numbers is",0 
	theRounded	BYTE ". The rounded average is",0 


	input		SDWORD ?
	count		DWORD 0
	sum			SDWORD 0
	average		SDWORD 0

	.code
	main PROC


	; (insert executable instructions here)

	; introduction

		mov		edx, OFFSET intro
		call	WriteString 
		call	CrLf 

	;get user name 

		mov		edx,OFFSET enterName
		call	WriteString ;writes to screen
		mov		edx, OFFSET userName 
		mov		ecx, 32   ;size of username
		call	ReadString


	;greet user 
		mov		edx, OFFSET hello 
		call	WriteString
		mov		edx, OFFSET userName
		call	WriteString 
		call	CrLf

	;userInstructions
		mov		edx, OFFSET instruction
		call	WriteString
		call	CrLf

	
	; getUserData (validate) validate data to be between [-100,-1] 
	
	normal:
		;mov	edx, OFFSET want
		;call	WriteString
		call	ReadInt
		mov		input, eax  
		jmp		compare
	
	error:
		mov		edx, OFFSET outRange
		call	WriteString
		call	ReadInt
		mov		input, eax

	compare:
	
		cmp		input, MIN
		jl		error ;moves up to error if out of range
		cmp		input,-1  
		jg		display ;jump to end of the loop if positive number entered


	; negative integers calculation

	;calculate sum

		inc		count
		mov		eax, sum 
		add		eax, input
		mov		sum, eax

	;calculate average

		mov		eax, sum
		mov		ebx, count
		cdq
		idiv	ebx
		mov		average,  eax

		jmp normal


display:
	
	cmp		input,0 
	je		specialMessage

	mov		edx, OFFSET youEntered
	call	WriteString
	mov		eax, count
	call	WriteInt
	mov		edx, OFFSET validNumber
	call	WriteString 
	call	CrLf

;display sum 

	mov		edx, OFFSET theSum
	call	WriteString
	mov		eax, sum
	call	WriteInt

;display average

	mov		edx, OFFSET theRounded
	call	WriteString
	mov		eax, average
	call	WriteInt
	
;farewell
bye:

		cmp		input,0 
		jne		final

specialMessage:

		mov		edx, OFFSET noValid
		call	WriteString

final:

		 
		mov		edx, OFFSET termMessage
		call	WriteString 
		call	CrLf
		mov		edx, OFFSET goodbye
		call	WriteString 
		mov		edx,OFFSET userName
		call	WriteString ;writes to screen
		call	CrLf


		exit	; exit to operating system
	main ENDP

	; (insert additional procedures here)

	END main
