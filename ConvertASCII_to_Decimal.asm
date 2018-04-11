TITLE Program 6A (Program6ADianaFinal.asm)

; Author: Diana Oh 
; Course / Project ID  CS271               Date: 11/29/2017
; Description:

;Write a small test program that gets 10 valid integers from the user and stores the numeric values in an
;array. The program then displays the integers, their sum, and their average.This program contains a readVal 
;and writeVal procedure where the former converts a string into a number and the latter converts a number 
;into a string and then displays it. 

; email: ohdi@oregonstate.edu;CS271_400
;Assignment number: Program #6A due Dec 3 2017

INCLUDE Irvine32.inc

; (insert constant definitions here)

;getString macro 

getString MACRO  address, size1 

push    edx
push    ecx
mov     ecx, size1

mov     edx, address 
call    ReadString

pop     ecx
pop     edx  

ENDM

;displayString Macro  

displayString MACRO address 
push    edx 
mov     edx,address 
call    WriteString 
pop     edx
ENDM 

;CONSTANTS

maxSize=500000

    .data

    ; (insert variable definitions here)

    intro       BYTE "PROGRAMMING ASSIGNMENT 6: Designing Low Level IO Procedures. Written by: Diana Oh",0
    termMessage BYTE "Results certified by Diana Oh. Goodbye",0
    instruction BYTE "Please provide 10 unsigned decimal integers.Each number needs to be small enough to fit inside a 32 bit register.After you have finished inputting the raw numbers I will display a list of the integers, their sum, and their average value.",0
    userName    BYTE  33 DUP(?)
    hello       BYTE "Hello ",0
    unsigned    BYTE " Please enter an unsigned number: ",0
    sumMessage  BYTE "The sum of these numbers is:  ",0
    stgMessage  BYTE "You entered the following numbers:  ",0
    avgMessage  BYTE "The average is:  ",0
    thanks      BYTE "Thanks for playing!  ",0

    tryAgain    BYTE  "ERROR: You did not enter an unsigned number or your number was too big. Please try again: ",0
    userString  BYTE   100000 DUP(?) 
    tempString  BYTE   100 DUP (?)
    space       BYTE    "  , ",0
    tenArray    DWORD   10 DUP (?)
    tester  BYTE  "test ",0


    .code

    ;main 
main PROC

    ;introduction procedure 

    push    OFFSET intro
    push    OFFSET instruction
    call    introduction

    ;getValues  
    push    OFFSET tryAgain
    push    OFFSET unsigned
    push    SIZEOF userString 
    push    OFFSET userString
    push    OFFSET tenArray
    call    getValues  

    ;display list 
    push    OFFSET stgMessage
    push    OFFSET tempString
    push    OFFSET tenArray 
    call    displayList
   
    
    ;sum and array procedure 
    push    OFFSET avgMessage
    push    OFFSET sumMessage
    push    OFFSET tenArray
    push    OFFSET tempString 
    call    sumAndAvg

    ;farewell 
    push    OFFSET thanks
    call    farewell 

exit
main ENDP




;----------------------------------------
;getValues procedure 
;----------------------------------------

getValues PROC									;read val converts string to number 

pushad

mov     ebp, esp 
mov     edx, [ebp +36]		; the ten array 
mov     ebx, [ebp+40]		; the string input buffer
mov     esi, [ebp +44]		; string size 
mov     edi, [ebp+52]		; tryAgain message
mov     ecx, 10 

L1: 


displayString [ebp+48]

push    edi
push    esi 
push    ebx 
call    readVal

push    edi 



mov     eax, DWORD PTR userString                ;store the numeric value in eax 

mov     edi, 4									 ;move 4 to edi to increment the array	



mov     [edx],eax								;increment the array that contains ten integers 
add     edx, edi								;increment array using base indexed addressing

pop     edi										;restore previous edi value 
loop L1											;loop 10x to get 10 integers

popad
ret 20

getValues ENDP



;----------------------------------------
;displayList procedure
;----------------------------------------

displayList PROC 
							;converts one number at a time 

pushad
mov     ebp, esp 
mov     edi, [ebp +36]		;the ten array
mov     edx, [ebp +40]		;temp string 

mov     ecx, 10				;loop 10x

displayString [ebp+44]


L1: 

push    edx					;push tempstring to writeVal	
push    [edi]				;takes number in ten array and pushes it to writeVal which will convert it
call    WriteVal


cmp     ecx,1
je      skip
comma:
mov     al, ','             ;adds comma and space between numbers
call    WriteChar
mov     al, ' '
call    WriteChar

skip:						;don't add a comma if we reach last number in array

add     edi, 4				;increment edi to display content in next array index 

loop L1 

popad
ret 12

displayList ENDP


;----------------------------------------
;writeval procedure
;----------------------------------------

writeVal PROC

;Cite: https://stackoverflow.com/questions/29065108/masm-integer-to-string-using-std-and-stosb

pushad
mov     ebp, esp

mov     eax, [ebp + 36]      ;current number 

L1: ;NUMBER TO STRING 

mov     edi, [ebp + 40]     ; address of tempString
mov     ecx, 0              ;initialize counter to 0


changeToString:

; store first digit into edx

mov     ebx, 10 
cdq
xor     edx, edx 
div     ebx                 ;divide number by 10
add     edx, 48             ;take remainder and add 48
push    edx                 ;push remainder+48 on stack
inc     ecx                 ;keeps track of how many times we pushed

cmp     eax, 0
je      L2 
jmp     changeToString

L2:
pop     eax                 ;pop single digit off stack
stosb                       ;store in tempString
loop    L2

mov     al, 0               ;add null terminator to end of string
stosb
mov  edi, [ebp + 40]        ;load starting address of tempString to print

displayString edi

popad
ret 8
writeVal ENDP 





;-----------------------
;readVal procedure
;-----------------------

readVal PROC

pushad
mov     ebp, esp

Start: 

mov     edx,[ebp+36]        ;user string
mov     eax, [ebp +40]      ;size 
getString   edx, eax        ;pass string and size of string to get string
mov     esi, edx
mov     ebx,0 


cmp     eax, 10             ;do not allow numbers greater than 10 digits to move forward
jg      Invalid				;jump to invalid if user input is greater than 10 digits

mov     ecx, eax            ;move the string length to ecx  


characterLoop: 
mov eax, 0 
lodsb                       ;loads byte from esi into eax 


cmp     eax, 48				;check if it's a valid number in respect to the ascii table 
jl      Invalid				;discard value if less than 48
cmp     eax, 57				;discard value if greater than 48
jg      Invalid				;jump to invalid to prompt user for another value
jmp     Success				;value is valid

 Invalid: 

 displayString [ebp+44]
 jmp    Start				;value is invalid. prompt user to enter another value

                            

Invalid2:					;goes to invalid 2 to pop eax in case carry flag gets set before eax gets popped
pop     eax
displayString [ebp+44]

 jmp    Start

 Success: 

 sub    eax, 48             ;eax is str[k]
 push   eax                 ;because you need to alter eax for the multiplication
 mov    eax, 10 
 mul    ebx                 ;muliply ebx by 10 to continue converting the string to number 

 jc     Invalid2            ;this invalid ensures the eax gets popped 

 mov    ebx, eax
 pop    eax
 add    eax, ebx
 jc     Invalid             ;regular invalid, pop happens before so we don't have to go to second invalid
 mov    ebx, eax

  loop characterLoop		;jump to inspect remaining user input

EndL: 

mov     DWORD PTR userString, ebx   ; move the number thats been converted from a string to the array

popad
ret 12

readVal ENDP



;----------------------------------------
;sum and average procedure
;----------------------------------------

sumAndAvg proc
 ;Cite CS271 Lectures and Slides

pushad 
mov     ebp, esp
mov     esi,[ebp+40] ;array
mov     ebx, [ebp +36] ;temp string 


mov     ecx, 10                     ;move 10 to ecx because we sum
mov     eax, 0                      ;clear the eax register by putting a zero in it
    
L1:
add     eax, [esi]                  ;add first value in array to eax 
add     esi, 4                      ;increment esi by four and keep adding 
loop    L1							;loop until all values have been added


call CrLf
displayString [ebp+44]
call CrLf 

push    ebx							;push tempstring to writeval
push    eax							;push sum to writeval
call    writeVal					;call writeval to convert sum to string and display it


;calculate average
push    ebx
mov     ebx, 10                     ;find average by dividing the 10 numbers in the array by 10 
mov     edx, 0 
div     ebx 


call CrLf
displayString [ebp+48]
call CrLf

pop ebx 

push    ebx							;push tempstring to writeval
push    eax							;push average to writeval
call    WriteVal					;call writeval to convert sum to string and display it


popad 
ret 16

sumAndAvg   ENDP



;----------------------------------------
;introduction procedure 
;----------------------------------------

introduction PROC 
        pushad

        mov     ebp, esp
        displayString [ebp +40]
        call    CrLf 
        call    CrLf 

        displayString [ebp +36]
        call    CrLf 
        call    CrLf
        popad
        ret     8

introduction ENDP




;----------------------------------------
;farewell procedure 
;----------------------------------------


farewell PROC
pushad
mov ebp, esp 

mov ebx, [ebp+36]

call CrLf
displayString [ebp +36]

popad 
ret 4

farewell ENDP


END main 