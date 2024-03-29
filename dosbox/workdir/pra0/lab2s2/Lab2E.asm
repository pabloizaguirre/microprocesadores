;**************************************************************************
; MBS 2021. LABORATORY ASSIGNMENT 2
; Author: Pablo Izaguirre garcia
; Group: 1301
; Task: 2
;**************************************************************************
NUM_VECTORS EQU 4; Number of vectors to analize
NUM_ELEMENTS EQU 4; Number of elements in every single vector
TOTAL_ELEMENTS EQU NUM_VECTORS * NUM_ELEMENTS; Total numbers of elements in the matrix
MAX_VALUE EQU 4; Highest value of an element in a matrix
MIN_VALUE EQU 1; Lowest value of an element in a matrix
; DATA SEGMENT DEFINITION
DATA SEGMENT
    ; VECTOR DEFINITION
    vector1 db 1,3,2,4
    vector2 db 3,4,1,2
    vector3 db 2,1,4,3
    vector4 db 4,2,3,1
    vectorAux       DB ?,?,?,?
    numString       DB 7 dup(" ")           ; AN INTEGER CAN HAVE AT MOST 5 DIGITS
    pNumString      DD numString
    txtSpace    	DB " ", "$"
    newline         DB 13, 10, '$'
    ;ASCInumber DB " ", 13, 10, '$' ; String where the conversion of the numbers will be stored
    correctRow DB "VALID ROWS",13,10,'$'
    incorrectRow DB "INVALID ROWS",13,10,'$'
    correctColumn DB "VALID COLUMNS",13,10,'$'
    incorrectColumn DB "INVALID COLUMNS",13,10,'$'
    correctRegion DB "VALID REGIONS",13,10,'$'
    incorrectRegion DB "INVALID REGIONS",13,10,'$' 
    introduceVector DB 13,10,"INTRODUCE A VECTOR (I.E.: 1 2 3 4): ",'$'
    incorrectVector DB 13,10,"INCORRECT VECTOR",13,10,'$'
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
    
    CALL GET_MATRIX

    MOV CX, 0

    ; WE PRINT A NEW LINE
    MOV AH, 9
    MOV DX, OFFSET newline
	INT 21H

    CALL PRINT_MATRIX

    ; WE PRINT A NEW LINE
    MOV AH, 9
    MOV DX, OFFSET newline
	INT 21H

    CALL CHECK_ROWS
    ADD CX, BP
    CALL CHECK_COLUMNS
    ADD CX, BP
    ; IF CX IS 20, IT MEANS THAT THE ROWS AND THE COLUMNS ARE VALID, IF NOT, THEN THE REGIONS WILL BE INVALID
    CMP CX, 20
    JNE INVALID_REGION
    ; CHECK_REGION IS ONLY CALLED ONCE WE CHECK THAT THE COLUMNS AND THE ROWS ARE CORRECT
    CALL CHECK_REGION
    JMP FIN

INVALID_REGION:
    MOV AH, 9
    MOV DX, OFFSET incorrectRegion
    INT 21H

FIN:

    ; END OF THE PROGRAMME
    MOV AX, 4C00H
    INT 21H
BEGIN ENDP
; SPACE FOR SUBROUTINES

;*********************
; MATRIX PRINTING (1A)
;*********************

; THIS SUBROUTINE PRINTS THE MATRIX FORMED BY VECTOR1, VECTOR2, VECTOR3 AND VECTOR4
; IT USES DI, BP, AX, DS, DX, BX, SI
PRINT_MATRIX PROC NEAR
    MOV BP, 0
PM_IR1:
    MOV DI, 0
    ; WE PRINT A NEW LINE
    MOV AH, 9
    MOV DX, OFFSET newline
	INT 21H
PM_IR2:
    
    ; WE STORE THE INTEGER IN AX SO THAT TOSTRING TRANSFORMS IT INTO AN ASCII CHARACTER
    MOV AH, 0
    MOV AL, vector1[BP][DI]
    ; A STRING WITH THE NUMBER IS CREATED
    CALL TOSTRING
    ; THE STRING IS PRINTED
    MOV AH, 9
    MOV DS, DX
    MOV DX, BX
    INT 21H
    ; WE REPEAT THIS FOR ALL THE ELEMENTS IN THE VECTOR
    INC DI
    CMP DI, 4
    JNE PM_IR2
    ; WE PRINT AN EXTRA SPACE
    MOV DX, OFFSET txtSpace
	INT 21H
    ; WE DO THIS FOR EACH VECTOR
    ADD BP, 4
    CMP BP, 16
    JNE PM_IR1
    RET
PRINT_MATRIX ENDP

; THIS SUBROUTINE TRANSFORMS AN INTEGER INTO AN ASCII STRING. THE INTEGER HAS TO BE STORED IN AX AND THE ROUTINE WILL
; RETURN THE MEMORY ADDRESS WHERE THE STRING IS STORED IN DX:BX
; IT USES BX, SI, DX, AX
TOSTRING PROC NEAR
    MOV BX, 10
    ; SI CONTAINS THE INDEX IN THE STRING WHERE THE NEXT NUMBER HAS TO BE WRITTEN
    MOV SI, 5
IRTOSTRING:
    ; WE MAKE SURE DX IS SET TO 0
    MOV DX, 0
    ; AX IS DIVIDED BY 10
    IDIV BX
    ; THE REMAINDER OF THE DIVISION IS STORED IN DX, SO WE INCREMENT THIS NUMBER BY THE POSITION OF 0 IN THE ASCII TABLE (30H)
    ADD DX, 30H
    ; THIS NUMBER (BETWEEN 30H AND 39H) IS STORED IN THE NEXT AVAILABLE POSITION IN THE ARRAY
    MOV numString[SI], DL
    DEC SI
    ; IF THE QUOTIENT IS 0 IT MEANS THAT WE HAVE ALREADY FOUND THE LAST DIGIT
    CMP AX, 0
    JNE IRTOSTRING

    MOV numString[SI], " "
    MOV numString[6], "$"
    MOV BX, WORD PTR pNumString
    ; BX HAS THE PREVIOUS POSITION TO THE ONE WHERE THE MOST SIGNIFICANT DIGIT WAS STORED
    ADD BX, SI
    ; DX HAS THE SEGMENT WHERE THE STRING IS LOCATED
    MOV DX, WORD PTR pNumString[2]
    RET
TOSTRING ENDP

;******************
; ROW CHECKING (1B)
;******************

; SUBROUTINE THAT CHECKES THAT THERE ARE NO REPEATED ELEMENTS IN A ROW AND IF THE ELEMENTS BELONG TO [1,4]
; IF BP IS 16, THE ROWS WHERE CORRECT
CHECK_ROWS PROC NEAR
    MOV BP, 0
CR_IR:
    ; CHECK IF THERE ARE DUPLICATED ELEMENTS
    CALL VECTORDUPLICATES
    CMP SI, 4
    ; IF THERE ARE, PRINT INVALID
    JNE CR_INVALID
    ; WE CHECK IF THE ELEMENTS ARE IN THE CORRECT RANGE
    CALL VECTORINRANGE
    CMP SI, 4
    ; IF NOT, WE PRINT INVALID
    JNE CR_INVALID
    ADD BP, 4
    CMP BP, 16
    JNE CR_IR
    ; IF THE PROGRAM REACHES THIS POINT IT MEANS THAT THE MATRIX IS CORRECT
    ; PRINT VALID ROWS
    MOV AH, 9
    MOV DX, OFFSET correctRow
    INT 21H
    RET
CR_INVALID:
    ; PRINT INVALID ROWS 
    MOV AH, 9
    MOV DX, OFFSET incorrectRow
    INT 21H
    RET
CHECK_ROWS ENDP

; THIS SUBROUTINE CHECKS THAT THE VECTOR BP IS BETWEEN 1 AND 4
; WHEN THE SUBROUTINE ENDS, IF SI IS 4, IT MEANS THAT THE ELEMENTS OF THE VECTOR ARE IN THE CORRECT RANGE
VECTORINRANGE PROC NEAR
    ; SI INDICATES THE INDEX INSIDE THE VECTOR
    MOV SI, 0
VR_IR:
    ; FIRST I CHECK IF THIS ELEMENT OF THE VECTOR IS GREATER OR EQUAL THAN ONE
    CMP vector1[BP][SI], 1
    JGE GREATERTHANONE
    RET

    ; IF THE NUMBER WAS GREATER THAN ONE, NOW WE HAVE TO CHECK IF IT IS SMALLER OR EQUAL TO 4
GREATERTHANONE:
    CMP vector1[BP][SI], 4
    JLE LESSTHANFOUR
    RET

LESSTHANFOUR:
    ; IF NO ERROR HAS BEEN FOUND, WE LOOK AT THE NEXT VALUE OF THE VECTOR
    INC SI
    ; IF THERE ARE STILL SOME NUMBERS TO CHECK FROM THIS VECTOR WE ANALYZE THE NEXT ELEMENT
    CMP SI, 4
    JNE VR_IR
    ; IF THE PROGRAM REACHES THIS POINT, IT MEANS THAT VECTOR[BP] IS CORRECT
    RET
VECTORINRANGE ENDP

; THIS SUBROUTINE CHECKS THAT THE VECTOR BP HAS NO DUPLICATE NUMBERS
; WHEN THE SUBROUTINE ENDS, IF SI IS 4, IT MEANS THAT THERE ARE NO REPEATED ELEMENTS IN THE VECTOR
VECTORDUPLICATES PROC NEAR
    ; SI INDICATES THE INDEX INSIDE THE VECTOR
    MOV SI, 0
VD_IR:
    ; DI INDICATES THE INDEX OF THE ELEMENTS INSIDE OF THE VECTOR WHERE WE STORE THE NUMBERS ALREADY USED
    MOV DI, SI
    ; WE STORE THE CURRENT NUMBER IN AH
    MOV AH, vector1[BP][SI]
CHECK_DUPES:
    DEC DI
    ; IF DI IS EQUAL TO -1, THEN THE AUXILIARY VECTOR HAS BEEN CHECKED COMPLETELY AND NO DUPLICATE HAS BEEN FOUND
    CMP DI, -1
    JE CORRECT
    ; COMPARE THE VALUE WITH EACH OF THE PREVIOUS ONES
    CMP vectorAux[DI], AH
    JNE CHECK_DUPES
    RET

CORRECT:
    ; THE ANALYZED NUMBER IS STORED IN THE AUXILIARY VECTOR
    MOV vectorAux[SI], AH
    ; WE CHECK IF THE WHOLE VECTOR HAS BEEN ANALYZED 
    INC SI
    CMP SI, 4
    JNE VD_IR
    ; IF THE PROGRAM REACHES THIS POINT, IT MEANS THAT VECTOR[BP] IS CORRECT
    ; WE PRINT CORRECT
    RET
VECTORDUPLICATES ENDP

;*********************
; COLUMN CHECKING (1C)
;*********************

; SUBROUTINE THAT CHECKES THAT THERE ARE NO REPEATED ELEMENTS IN A ROW AND IF THE ELEMENTS BELONG TO [1,4]
; IF BP IS 4, IT MEANS THAT THE COLUMNS ARE CORRECT
CHECK_COLUMNS PROC NEAR
    MOV BP, 0
CC_IR:
    ; WE CHECK IF THERE ARE DUPLICATED ELEMENTS
    CALL COLUMNDUPLICATES
    CMP SI, 16
    ; IF THERE ARE, PRINT INVALID
    JNE CC_INVALID
    INC BP
    CMP BP, 4
    JNE CC_IR
    ; IF THE PROGRAM REACHES THIS POINT IT MEANS THAT THE MATRIX IS CORRECT
    ; PRINT VALID COLS
    MOV AH, 9
    MOV DX, OFFSET correctColumn
    INT 21H
    RET
CC_INVALID:
    ; PRINT INVALID COLS 
    MOV AH, 9
    MOV DX, OFFSET incorrectColumn
    INT 21H
    RET
CHECK_COLUMNS ENDP

; THIS SUBROUTINE CHECKS THAT THE COLUMN BP HAS NO DUPLICATE NUMBERS
; WHEN THE SUBROUTINE ENDS, IF SI IS 16, IT MEANS THAT THERE ARE NO REPEATED ELEMENTS IN THE COLUMN
COLUMNDUPLICATES PROC NEAR
    ; SI INDICATES THE INDEX INSIDE THE COLUMN
    MOV SI, 0
    MOV BX, 0
COL_DUP_IR:
    ; DI INDICATES THE INDEX OF THE ELEMENTS INSIDE OF THE VECTOR WHERE WE STORE THE NUMBERS ALREADY USED
    MOV DI, BX
    ; WE STORE THE CURRENT NUMBER IN AH
    MOV AH, vector1[SI][BP]
COL_CHECK_DUPES:
    DEC DI
    ; IF DI IS EQUAL TO -1, THEN THE AUXILIARY VECTOR HAS BEEN CHECKED COMPLETELY AND NO DUPLICATE HAS BEEN FOUND
    CMP DI, -1
    JE COL_DUP_CORRECT
    ; COMPARE THE VALUE WITH EACH OF THE PREVIOUS ONES
    CMP vectorAux[DI], AH
    JNE COL_CHECK_DUPES
    RET

COL_DUP_CORRECT:
    ; THE ANALYZED NUMBER IS STORED IN THE AUXILIARY VECTOR
    MOV vectorAux[BX], AH
    ; WE CHECK IF THE WHOLE COLUMN HAS BEEN ANALYZED 
    INC BX
    ADD SI, 4
    CMP SI, 16
    JNE COL_DUP_IR
    ; IF THE PROGRAM REACHES THIS POINT, IT MEANS THAT THE COLUMN BP IS CORRECT
    ; WE PRINT CORRECT
    RET
COLUMNDUPLICATES ENDP

;*********************
; REGION CHECKING (2A)
;*********************

; THIS SUBROUTINE CHECKS THAT THERE ARE NO REPEATED ELEMENTS IN EACH REGION OF THE MATRIX
; BEFORE CALLING THIS SUBROUTINE CHECK_ROWS AND CHECK_COLUMNS MUST HAVE RETURNED OK
CHECK_REGION PROC NEAR
    MOV BP, 0
    MOV SI, 0
    MOV CX, 1
    CALL REGION_DIAGONALS_DUPLICATED
    AND CX, BX
    MOV SI, 2
    CALL REGION_DIAGONALS_DUPLICATED
    AND CX, BX
    MOV BP, 8
    CALL REGION_DIAGONALS_DUPLICATED
    AND CX, BX
    MOV SI, 0
    CALL REGION_DIAGONALS_DUPLICATED
    AND CX, BX
    MOV AH, 9
    CMP CX, 1
    JNE CREG_INVALID
    MOV DX, OFFSET correctRegion
    INT 21H
    RET
CREG_INVALID:
    MOV DX, OFFSET incorrectRegion
    INT 21H
    RET

CHECK_REGION ENDP

; THIS SUBROUTINE CHECKS IF A REGION WITH THE FIRST ELEMENT [BP][SI] HAS DUPLICATES IN ITS DIAGONALS
; IF THE REGION IS CORRECT IT STORES A 1 IN BX
REGION_DIAGONALS_DUPLICATED PROC NEAR
    MOV BX, BP
    ADD BX, 4
    MOV DI, SI
    INC SI
    MOV DH, vector1[BX][DI]
    CMP vector1[BP][SI], DH
    JE RDD_INVALID
    MOV DH, vector1[BP][DI]
    CMP vector1[BX][SI], DH
    JE RDD_INVALID
    MOV BX, 1
    RET
RDD_INVALID:
    MOV BX, 0
    RET

REGION_DIAGONALS_DUPLICATED ENDP

;***********************
; ASKING FOR MATRIX (2B)
;***********************

GET_MATRIX PROC NEAR
    MOV BP, 0
GET_MATRIX_IR:
    ; WE GET VECTOR BP AND STORE IT IN VECTOR1[BP]
    CALL GET_VECTOR
    ; WE DO THIS 4 TIMES
    ADD BP, 4
    CMP BP, 16
    JNE GET_MATRIX_IR
    RET
GET_MATRIX ENDP

; THIS SUBROUTINE ASKS FOR THE VECTOR CORRESPONDING TO MATRIX[BP]
GET_VECTOR PROC NEAR
    MOV AH, 9
    MOV DX, OFFSET introduceVector
    INT 21H

    MOV SI, 0

GET_VECTOR_IR:
    ; THE PROGRAM READS A NUMBER FROM SCREEN
    MOV AH, 1
    INT 21H

    ; THE NUMBER IS NOW STORED IN AL IN ASCII, IT HAS TO BE CONVERTED TO ITS CORRESPONDING INT
    ADD AL, -48
    ; WE CHECK THAT A NUMBER WAS INPUTED
    CMP AL, 0
    JB GET_VECTOR_INCORRECT_VECTOR
    CMP AL, 9
    JA GET_VECTOR_INCORRECT_VECTOR

    MOV vector1[BP][SI], AL

    ; A SPACE IS PRINTED TO SEPARATE THE ELEMENTS ON SCREEN
    MOV AH, 2
    MOV DL, 32
    INT 21H
    
    ; IF 4 NUMBERS HAVE BEEN READ, THE SUBROUTINE ENDS
    INC SI
    CMP SI, 4
    JNE GET_VECTOR_IR

    RET

GET_VECTOR_INCORRECT_VECTOR:
    ; PRINT INCORRECT VECTOR
    MOV AH, 9
    MOV DX, OFFSET incorrectVector
    INT 21H
    ; END OF THE PROGRAMME
    MOV AX, 4C00H
    INT 21H
GET_VECTOR ENDP

; END OF THE CODE SEGMENT
CODE ENDS
; END OF THE PROGRAMME POINTING OUT WHERE THE EXECUTION BEGINS
END BEGIN