TITLE Program 2 (project1.asm)

; Author: Diana Oh 
; Course / Project ID  CS271               Date: 10/1/2017
; Description:

;Let user specify number of fibonacci numbers to be displayed and output those Fibonacci numbers. Perform input validation so user enter numbers within range 1-46.

; email: ohdi@oregonstate.edu;CS271_400
;Assignment number: Program #2 due October 15


INCLUDE Irvine32.inc

; (insert constant definitions here)

;Constants 

	MAX= 46 


	.data

	; (insert variable definitions here)

	intro       BYTE "Fibonacci Numbers Programmed by Diana Oh",0
	termMessage BYTE "Results certified by Diana Oh",0
	instruction BYTE "Enter the number of Fibonacci terms to be displayed. Give the number as an integer in the range [1 .. 46].",0
	enterName   BYTE "What is your name?",0
	outRange	BYTE "Out of range. Enter a number in [1 .. 46] ",0
	want		BYTE "How many Fibonacci terms do you want?  ",0
	userName	BYTE  33 DUP(?)
	hello		BYTE "Hello ",0
	goodbye		BYTE "Goodbye ",0
	space		BYTE "     ",0

	input		DWORD ?
	temp		DWORD ?
	five		DWORD 0

	.code
	main PROC


	; (insert executable instructions here)

	; introduction

		mov		edx, OFFSET intro
		call	WriteString 
		call	CrLf 

	;get user name ASK

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

	
		;post test loop. keep asking the same question untilt he number is valid. store the valid number into a variable
	; getUserData (validate) 
	
	normal:
		mov		edx, OFFSET want
		;missing want statement 
		call	WriteString
		call	ReadInt
		mov		input, eax  ;confused
		jmp		compare
	
	error:
		mov		edx, OFFSET outRange
		;missing want statement 
		call	WriteString
		call	ReadInt
		mov		input, eax

	compare:
	
		cmp		input, 1
		jl		error
		cmp		input,MAX
		jg		error


	; displayFibs 1 1 2 3 

			mov		ecx, input

	L1:

		cmp		input, ecx  ;if the input and ecx are equal that means 1 should print out cause everything decrements afterwards
		je		print1
		jmp		calculations

		print1: ;print the first one of the sequence 
			mov		eax, 1 
			call	WriteDec
			mov		edx, OFFSET space
			call	WriteString 	
			mov		eax, 0 
			mov		ebx, 1
			mov		five, 4
			jmp		endLoop  ; go to end of loop to update the ecx
	

		newline:
			call	CrLf 
			mov		five, 5
			jmp		endLoop
			;jmp		L1
			

		calculations:

		; handles the calcuations and enters space between integers
			
			add		eax, ebx
			call	WriteDec 
			mov		edx, OFFSET space ; gives space between integers
			call	WriteString 
			mov		temp, eax   ;the sum 1 goes to temp
			mov		eax, ebx
			mov		ebx, temp	
			dec		five ; variable
			cmp		five, 1
			jl		newline


	endLoop:
			loop	L1
;farewell
	bye:
		call	CrLf 
		call	CrLf 
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
