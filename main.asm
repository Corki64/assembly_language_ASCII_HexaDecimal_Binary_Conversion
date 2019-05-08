; Luis Cortez
; Module Five Programming Assignment
;

INCLUDE c:\Irvine\Irvine32.inc
.386
.model flat,stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword


.data
     char byte ?
     obj byte ?

.code

; DigitValue2ASCII 
; Excercise One - will convert the hexademical value of a digit
; into the ASCII equivelant.
DigitValue2ASCII proc
     MOV DL, AL          ; Will read in from AL (readChar)
     CMP DL, 09h         ; Compares AL to 0Ah (10) 
     
     JA isAbove      ; Conditional jump if above 9
     ADD AL, 30h
     JMP endOfMethod     ; Jumps to end of method
     
isAbove : 
     SUB DL, 0Ah
     ADD DL, 41h

endOfMethod :
     RET                 ; Return to call

DigitValue2ASCII endp

; WriteHexByte
; Excercise Two - will display the value of reigister AL to the console
; Making use of both carriage return and line feed.
; This is a rewrite of excercise 2 from the previous assignment using
; conditional jumps.
WriteHexByte proc

     MOV DH, AL               ; Will read in from AL (readChar) - store value in DH
     AND AL, 0F0h             ; Gets the most sig. nibble         
     SHR AL, 4                ; Shift right to the least significant nibble
     CALL DigitValue2ASCII    ; Stores the ASCII value of most sig. nibble in DL
     MOV AL, DL               ; Loads character to print
     CALL WriteChar           ; Print to console

     MOV AL, DH               ; Reload original value into AL
     AND AL, 0Fh              ; Gets the least sig. nibble
     CALL DigitValue2ASCII    ; Stores the ASCII value of least sig. nibble in DL
     MOV AL, DL               ; Loads character to print
     CALL WriteChar           ; Print to console

     MOV AL, 'h'              ; Load 'h' into AL write register.
     CALL WriteChar
     MOV AL, 0Ah              ; Loads new line into AL register.
     CALL WriteChar
     MOV AL, 0Dh              ; Load carriage return
     CALL WriteChar

          RET                 ; Return to call

WriteHexByte endp

; ASCII2DigitValue
; Exercise Three - will convert the ASCII code of value in AL to
; its digit value in DL
ASCII2DigitValue proc

     MOV DL, AL               ; Moves ASCII to DL for conversion
     CMP DL, 39h
     JA ifAbove

     SUB DL, 30h
     JMP endOfMethod

ifAbove : 
     SUB DL, 41h
     ADD DL, 0Ah

endOfMethod :
          RET                 ; Return to call

ASCII2DigitValue endp


; ReadHexByte
; Exercise Four - will receive 2 values from user and store them in AL
ReadHexByte proc

     CALL ReadChar            ; Reads the first value into AL
     CALL ASCII2DigitValue    ; First digit converted to value, stored in DL
     MOV DH, DL               ; Moves value of first digit to DH

     CALL ReadChar            ; Reads the second value into AL
     CALL ASCII2DigitValue    ; Second digit converted to value, stored in DL

     MOV AL, DL               ; Second value moved to AL
     SHL DH, 4                ; Shift left DH 4 to get most sig. nibble
     ADD AL, DH

     RET                      ; Return to call

ReadHexByte endp

; SumFirstN
; Exercise Five - Compute the sum S of the first n integers
; and store S in register DX.
SumFirstN proc
     MOV ECX, 00h             ; Zero out ECX
     MOV CL, AL               ; Moves in the number of times to repeat
     MOV DX, 0h               ; Zero out DX
     MOV BX, 1h               ; Counter

SUM:
     ADD DX, BX               ; Added sum of integers
     ADD BX, 1h               ; Increment counter
     LOOP SUM                 ; Loop until ECX = 0

     RET                      ; Return to call

SumFirstN endp

main proc

     CALL ReadHexByte         ; Reads input from user
     CALL SumFirstN           ; Uses input from user
     CALL WriteHexByte        ; Prints result
invoke ExitProcess, 0
main endp
end main

