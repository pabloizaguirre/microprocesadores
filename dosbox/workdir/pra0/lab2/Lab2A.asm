;**************************************************************************
; MBS 2021. LABORATORY ASSIGNMENT 2
; Author: PABLO IZAGUIRRE GARCIA
; Group: 2291
; Task: 1
;**************************************************************************

; DATA SEGMENT DEFINITION
DATA SEGMENT
    ; VECTOR DEFINITION
    vector1         DB 1,2,2,4
    vector2         DB 4,5,1,1
    vector3         DB 1,2,4,1
    errorNumDif     DB "Outside the set: [1,4]", 13, 10, '$'
    correctOutput   DB "Correct", 13, 10, '$'
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
    
    ; BX REPRESENTS WHICH VECTOR WE ARE ANALYZING
    MOV BX, 0  
IR:
    ; SI INDICATES THE INDEX INSIDE THE VECTOR
    MOV SI, 0
IR2:
    ; FIRST I CHECK IF THIS ELEMENT OF THE VECTOR IS GREATER OR EQUAL THAN ONE
    CMP vector1[BX][SI], 1
    JGE GREATERTHANONE
    ; IF THE NUMBER IS SMALLER THAN ONE THEN WE PRINT THE ERROR MESSAGE AND PROCEED TO ANALYZE THE NEXT VECTOR
    CALL PRINTERROR
    JMP NEXTVECTOR

    ; IF THE NUMBER WAS GREATER THAN ONE, NOW WE HAVE TO CHECK IF IT IS SMALLER OR EQUAL TO 4
GREATERTHANONE:
    CMP vector1[BX][SI], 4
    JLE LESSTHANFOUR
    ; IF THE NUMBER WAS GREATER THAN FOUR THEN WE PRINT THE ERROR MESSAGE AND PROCEED TO ANALYZE THE NEXT VECTOR
    CALL PRINTERROR
    JMP NEXTVECTOR

LESSTHANFOUR:
    ; IF NO ERROR HAS BEEN FOUND, WE LOOK AT THE NEXT VALUE OF THE VECTOR
    INC SI
    ; IF THERE ARE STILL SOME NUMBERS TO CHECK FROM THIS VECTOR WE ANALYZE THE NEXT ELEMENT
    CMP SI, 4
    JNE IR2
    ; IF THE PROGRAMME REACHES THIS POINT, IT MEANS THAT VECTOR[BX] IS CORRECT
    ; WE PRINT CORRECT
    MOV AH, 9
    MOV DX, OFFSET correctOutput
    INT 21H

NEXTVECTOR:
    ; WE LOOK AT THE NEXT VECTOR (BX IS INCREASED BY 4 BECAUSE THATS THE SIZE OF EACH VECTOR)
    ADD BX, 4
    ; IF THERE ARE STILL MORE VECTORS TO CHECK, THE PROGRAMME JUMPS TO IR
    CMP BX, 12
    JNE IR

    ; END OF THE PROGRAMME
    MOV AX, 4C00H
    INT 21H
BEGIN ENDP
; SPACE FOR SUBROUTINES

; THIS SUBROUTINE PRINTS THE ERROR MESSAGE
PRINTERROR PROC NEAR
    MOV AH, 9
    MOV DX, OFFSET errorNumDif
    INT 21H
    RET
PRINTERROR ENDP

; END OF THE CODE SEGMENT
CODE ENDS
; END OF THE PROGRAMME POINTING OUT WHERE THE EXECUTION BEGINS
END BEGIN