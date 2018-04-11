TITLE Program 5 (Program5Diana.asm)

; Author: Diana Oh 
; Course / Project ID  CS271               Date: 11/5/2017
; Description:

;Let user specify number of values to display. Once user does, a display of the list, the median of the list, and the sorted list will be shown.  

; email: ohdi@oregonstate.edu;CS271_400
;Assignment number: Program #5 due November 19 2017


INCLUDE Irvine32.inc

; (insert constant definitions here)

;Constants 

	userMin=10
	userMax =200
	lo=100
	hi=999
	ten=10
	four=4

	.data

	; (insert variable definitions here)

	intro       BYTE "Sorting Random Integers Programmed by Diana Oh",0
	termMessage BYTE "Results certified by Diana Oh. Goodbye",0
	instruction BYTE "This program generates random numbers in the range [100 .. 999], displays the original list, sorts the list, and calculates the median value. Finally, it displays the list sorted in descending order.",0
	enterName   BYTE "What is your name?",0
	invalid		BYTE "Invalid input. ",0
	howMany		BYTE "How many numbers should be generated? [10 .. 200]: ",0
	median		BYTE "The median is ",0
	title1		BYTE "The unsorted random numbers",0
	title2		BYTE "The sorted list",0
	tester		BYTE "tester",0
	tester2		BYTE "tester2",0
	tester3		BYTE "tester3",0
	inSort		BYTE "in sort",0
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
	
	
	
	value		DWORD 0
	testV		DWORD 0
	testCounter	DWORD 5

	request		DWORD ?
	array		DWORD 200	DUP(?) 

	.code

	;main 
	main PROC

	;introduction procedure 

	push	OFFSET intro
	push	OFFSET instruction
	call	introduction

	;get data procedure 

	push	OFFSET	request
	call	getData

	;fillArray procedure 

	
	call	Randomize 

	push	request
	push	OFFSET array
	call	fillArray 


	;display unsorted list  {parameters: array (reference), request (value), title (reference)}


	push	OFFSET array
	push	request
	push	OFFSET title1 
	call	displayList


	;sort list {parameters: array (reference), request (value)}

	push	OFFSET array
	push	request
	call	sortList 

	;display median {parameters: array (reference), request (value)}

	push	OFFSET array
	push	request 
	call	medianP


	;display sorted list  {parameters: array (reference), request (value), title (reference)}

	push	OFFSET array
	push	request
	push	OFFSET title2 
	call	displayList

	 exit 

main ENDP

;introduction

introduction PROC 
		pushad
		mov		ebp, esp

		mov		edx, [ebp +40]
		call	WriteString 
		call	CrLf 

		mov		edx, [ebp +36]
		call	WriteString 
		call	CrLf 

		popad
		ret		8


introduction ENDP
;works 

;getUserData procedure
getData PROC 

	;	pushad
	;	mov		ebp, esp
		push	ebp
		mov		ebp, esp
		mov		ebx, [ebp + 8] 
normal:

		mov		edx, OFFSET howMany
		call	WriteString
		call	ReadInt
		;mov	[ebp + 36], eax  ;move what the user typed to request
		jmp		compare
	
	error:
		mov		edx, OFFSET invalid ;display out of range message
		call	WriteString
		mov		edx, OFFSET howMany
		call	WriteString
		call	ReadInt
		;mov		[ebp + 36], eax

	compare:
	
		cmp		eax, userMin
		jl		error ;moves up to error if out of range
		cmp		eax,userMax 
		jg		error ;jump to end of the loop if positive number entered
		


		mov		[ebx], eax
		pop		ebp
		ret		4


	;	mov		[ebp + 36], eax
		
	;	popad
	;	ret 4

getData ENDP

;sort list procedure

sortList proc  ;sort list {parameters: array (reference), request (value)}

	pushad 
	mov		ebp, esp
	mov		ecx,[ebp+36]  ;move request to ecx 
	mov		edi, [ebp+40] ; move array to edi 
	
	;compare the new ecx with request value let it loop with ecx

	mov		eax, 0 ; move 0 to k 
	outer:
	mov		ebx, eax ;move k into i what to do when k keep changing values save I
	
	;INNER LOOP
	 mov	edx, eax 
	inner: 

;put value of k in j need to increase j in rel to k
	inc		edx  ;increase k j=k+1 JJJJ
	cmp		edx, [ebp+36]  ;compare j with request j<request
	jge		outerEnd ;break out of inner loop if j is g/e to request

	;if array[j]>array[i]

	mov		esi, [edi +edx*4]
	cmp		esi, [edi + ebx*4]  ; array j with array i

	jg		greater
	jmp		ignore


	greater:
	;i=j 
	mov		ebx, edx  ; i=j
		
	ignore:

	jmp inner 
	
	outerEnd: ;escape inner loop
	
	push	eax	
	push	ecx
	push	edx

	mov		edx, eax
	;esi, [edi +edx*4]

	mov		eax, edx ;eax contain the value of edx  [edi +eax*4] THIS NEEDS TO BE  EAX
	mov		ecx, 4
	mul		ecx

	add		eax,edi 
	push	eax 
	
	; second

	mov		eax, ebx ;eax contain the value of ebx [edi + ebx*4]
	mov		ecx, 4
	mul		ecx

	add		eax, edi
	push	eax

	call	exchange 

	pop		edx
	pop		ecx
	pop		eax

	inc		eax ;increase k 
	loop	outer ;this is an ecx loop you only worry about incrementing k but it 
	;will eventually just close loop when ecx decrements to 0 

	finished: 

	popad 
	ret 12

sortList ENDP

;exchange procedure


exchange proc

;exchange array[k], array[i]

	pushad 
	mov		ebp, esp
	mov		esi, [ebp+40]
	mov		eax, [esi]   
	mov		edi,[ebp+36]
	xchg	eax, [edi] ;37 des into eax
	mov		[esi] , eax

	
	popad
	ret 8 

exchange ENDP 



;fill data procedure 

fillArray proc

;cite: Assembly Language for x86 Processor Kip Irvine p 381
	pushad 
	mov		ebp, esp
	mov		edi, [ebp + 36]   ;move array to edi 
	mov		ecx,  [ebp + 40]  
	;mov		ecx, 20

	mov		edx, hi
	sub		edx, lo  ;subtract hi-lo
	
L1:
	mov		eax, edx  ;get absolute range
	call	RandomRange
	add		eax, lo
	mov		[edi], eax  ;eax now has the random number
	add		edi, 4
	loop	L1
	popad 
	ret 8


fillArray ENDP




;display list procedure

displayList proc

pushad
mov		ebp, esp
mov		edi, [ebp + 44] ; array is here 
mov		ecx, [ebp + 40]  ;request is here 
mov		ebx, 10
mov		edx, [ebp +36] ;title is here 
 


call	WriteString 
call	CrLf  ;display the title 

L1: 

mov		eax, [edi] ;move the value to eax
call	WriteDec
mov		edx, OFFSET space
call	WriteString 	
add		edi, 4


dec		ebx ; variable
cmp		ebx , 1
jl		newline ;new line needed 
jmp		endLoop 
 
newline:
call	CrLf 
mov		ebx,10
jmp		endLoop


endLoop: 

loop L1 

popad 
ret 12

displayList ENDP


;median procedure

medianP proc

;display median {parameters: array (reference), request (value)}
	pushad
	mov		ebp, esp

	mov		edi,[ebp+40]

	mov		eax, [ebp+36]   ;move request to eax to see if it's odd or even 
	mov		ebx,2
	mov		edx, 0
	div		ebx
	mov		eax, 0 

	cmp		edx, 0 ;if it's equal its even 
	je		evenN

	odd:

	mov		eax, [ebp +36]   ;move request to eax
	dec		eax
	mov		ebx, 2
	mov		edx, 0
	div		ebx  ;eax now contains the right index

	mov		ebx, [edi + 4*eax]  ;now contains the median 
	call	CrLf
	mov		edx, OFFSET	median
	call	WriteString  ; the median is 
	mov		eax, ebx
	call	WriteDec
	call	CrLf

	jmp	endMedian


	evenN: 
	mov		eax, [ebp +36] 
	mov		ebx, 2
	mov		edx, 0 ; DONE 
	div		ebx  ;eax now contains one of the the right indices
	mov		ecx, eax 

	dec		eax ; get the index on the left of the index above

	mov		esi,[edi+ 4*ecx]
	mov		edx,[edi + 4*eax]


	mov		ebx, esi 
	mov		eax,edx
	add		eax, ebx   ;eax now has the correct sum of the two indexes 
	
	mov		ebx, 2
	mov		edx, 0
	div		ebx

	;eax now has the mdeia 
	call	CrLf 
	mov		edx, OFFSET	median
	call	WriteString 
	call	WriteDec ;correct value is already in eax 
	call	CrLf

	endMedian: 

	popad 
	ret 8 

medianP ENDP



















	END main 