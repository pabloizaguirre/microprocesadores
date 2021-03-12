;**************************************************************************
; MBS 2021. BASIC STRUCTURE OF AN ASSEMBLER PROGRAMME
;**************************************************************************
; DATA SEGMENT DEFINITION
DATA SEGMENT
;-- fill with the requested data
DATA ENDS
;**************************************************************************
; STACK SEGMENT DEFINITION
STACKSEG SEGMENT STACK "STACK"
DB 40H DUP (0) ; initialization example, 64 bytes initialize to 0
STACKSEG ENDS
;**************************************************************************
; EXTRA SEGMENT DEFINITION
EXTRA SEGMENT
RESULT DW 0,0 ; initialization example. 2 WORDS (4 BYTES)
EXTRA ENDS
;**************************************************************************
; CODE SEGMENT DEFINITION
CODE SEGMENT
ASSUME CS: CODE, DS: DATA, ES: EXTRA, SS: STACKSEG
; BEGINNING OF MAIN PROCEDURE
BEGIN PROC
    ; INITIALIZE THE SEGMENT REGISTER WITH ITS VALUE
    MOV AX, DATA
    MOV DS, AX
    MOV AX, STACKSEG
    MOV SS, AX
    MOV AX, EXTRA
    MOV ES, AX
    MOV SP, 64 ; LOAD A STACK POINTER WITH THE HIGHEST VALUE
    ; END OF INITIALIZATIONS
    ; BEGINNING OF THE PROGRAMME
    
    MOV AX, 0372H
    MOV DS, AX

    MOV AX, 0362H
    MOV ES, AX

    MOV BX, 0212H
    MOV DI, 1010H

    ; a, b, c
    MOV AL, DS:[0211H]

    MOV AX, [BX]

    MOV [DI], AL

    ; a1, b1, c1
    MOV AL, ES:[0311H]

    MOV SI, 0312H
    MOV AX, ES:[SI]

    MOV ES:[1110H], AL


    ; END OF THE PROGRAMME
    MOV AX, 4C00H
    INT 21H
BEGIN ENDP
; END OF THE CODE SEGMENT
CODE ENDS
; END OF THE PROGRAMME POINTING OUT WHERE THE EXECUTION BEGINS
END BEGIN 