TITLE Program 4 (composite2.asm)

; Author: Diana Oh 
; Course / Project ID  CS271               Date: 11/5/2017
; Description:

;Let user specify number of composite numbers to display and then display them. Use input validation so input is within specified range. 

; email: ohdi@oregonstate.edu;CS271_400
;Assignment number: Program #4 due November 5


INCLUDE Irvine32.inc

; (insert constant definitions here)

;Constants 

	MAX= 400 
	MIN = 1


	.data

	; (insert variable definitions here)

	intro       BYTE "Composite Numbers Programmed by Diana Oh",0
	termMessage BYTE "Results certified by Diana Oh. Goodbye",0
	instruction BYTE "Enter the number of composite numbers you would like to see.I will accept orders for up to 400 composites.",0
	enterName   BYTE "What is your name?",0
	outRange	BYTE "Out of range. Try again",0
	ent			BYTE "Enter the number of composites to display [1 .. 400]: ",0

	userName	BYTE  33 DUP(?)
	hello		BYTE "Hello ",0
	goodbye		BYTE "Goodbye ",0
	space		BYTE "     ",0


	input		DWORD ?
	temp		DWORD ?
	divisor		DWORD 2
	actual		DWORD ?
	count		DWORD 4
	composite	DWORD 4
	number		DWORD 0
	found		DWORD 0
	
	ten			DWORD 10
	
	value		DWORD 0
	testV		DWORD 0


	.code

	;main 
	main PROC

	call introduction
	call getUserData ; validate subroutine 
	call showComposites ; call isComposite subroutine 
	call farewell 

	 exit 

main ENDP

;introduction

introduction PROC 

		mov		edx, OFFSET intro
		call	WriteString 
		call	CrLf 
		mov		edx, OFFSET instruction
		call	WriteString 
		call	CrLf 
		ret

introduction ENDP

;getUserData procedure
getUserData PROC 

normal:
		mov	edx, OFFSET ent
		call	WriteString
		call	ReadInt
		mov		input, eax  

		call	validate 
		ret

getUserData ENDP 



;validate procedure

validate PROC 


jmp		compare
	
	error:
		mov		edx, OFFSET outRange
		call	WriteString
		call	ReadInt
		mov		input, eax

	compare:
	
		cmp		input, MIN
		jl		error ;moves up to error if out of range
		cmp		input,MAX  
		jg		error ;jump to end of the loop if positive number entered
		ret
validate ENDP



;showComposites procedure

showComposites PROC 

mov		ecx, input ;count decrements input is n

L1: ; loop for each n 

calculate: 
;returns a composite number for the first int if not traverses along within the bigger loop
call	isComposite


;compare if it was found 

cmp		found, 0    ;  means not found 

je		NF 
jne		F

NF: 
;4,5,6,7,8,9
inc		ecx 
inc		composite 
jmp		endLoop 


F: ;found so write it out 
mov		eax, composite 
call	WriteDec 
inc		composite 

mov		edx, OFFSET space ; gives space between integers
call	WriteString 
	
dec		ten ; variable
cmp		ten , 1
jl		newline ;new line needed 
jmp		endLoop 
 
newline:
call	CrLf 
mov		ten, 10
jmp		endLoop


endLoop: 

loop L1
ret 

showComposites ENDP


;isComposite procedure


isComposite PROC 
;compare the count against every possible divisor and print and end this loop when found

findComposite:

	
mov		eax, composite  ;count is 4  4,5,6,7,8
mov		ebx, divisor ;if it divides by an int that's smaller than it's composite and it's already greater than 4 
;quotient eax and remainder edx

cdq
div		ebx 
cmp		edx,0 ;see if the remainder contains a zero the divisors are less than the number 
je		compFound ;jump if no remainder 
jne		continue

compFound:

mov		eax, 2  ;reset divisor and increase count 
mov		divisor, eax
mov		eax, 1
mov		found, eax
jmp		endFunction ; resent divisor and end function 


continue: ;continue as long as composite wasn't found divide by all posible divisors

inc		divisor 
mov		ebx, divisor 

 
cmp		ebx, composite ;if the divisor and the composite are equal 
je		prime

;else 
jmp		findComposite ; find composite now with an increased divisor 


prime: 

mov		eax, 2  ;reset divisor and increase count 
mov		divisor, eax
mov		eax, 0 
mov		found, eax 

endFunction: 

ret 

isComposite ENDP


;farewell 

farewell PROC 
Call CrLf 
mov	edx, OFFSET termMessage 
Call WriteString 
Call CrLf
ret
farewell ENDP 

	END main 