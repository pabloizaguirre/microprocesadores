;**************************************************************************
; MBS 2021. LABORATORY ASSIGNMENT 4
; Author: Pablo Izaguirre garcia
; Group: 1301
; Task: 3
;**************************************************************************
; DATA SEGMENT DEFINITION
DATA SEGMENT
    limits_exceeded_blue_txt db " Blue exceeded the limits", 13, 10, '$'
    limits_exceeded_red_txt db " Red exceeded the limits", 13, 10, '$'
    blue_wins_txt db " Blue wins!!!", 13, 10, '$'
    red_wins_txt db " Red wins!!!", 13, 10, '$'
DATA ENDS
;**************************************************************************
; STACK SEGMENT DEFINITION
STACKSEG SEGMENT STACK "STACK"
    DB 40H DUP (0) ; initialization example, 64 bytes initialize to 0
STACKSEG ENDS
;**************************************************************************
; EXTRA SEGMENT DEFINITION
EXTRA SEGMENT
    
EXTRA ENDS
;**************************************************************************
; CODE SEGMENT DEFINITION
CODE SEGMENT
ASSUME CS: CODE, DS: DATA, ES: EXTRA, SS: STACKSEG
; BEGINNING OF MAIN PROCEDURE
MODO_VIDEO DB 0
BEGIN PROC
    ; INITIALIZE THE SEGMENT REGISTER WITH ITS VALUE
    mov ax, DATA
    mov ds, ax
    mov ds, ax
    mov ax, STACKSEG
    mov ss, ax
    mov ax, EXTRA
    mov es, ax
    mov sp, 64; LOAD A STACK POINTER WITH THE HIGHEST VALUE
    ; END OF INITIALIZATIONS 
    ; BEGINNING OF THE PROGRAMME
    ; We use 10h interrupción to enter in video mode
    MOV AH,0Fh ; Asking for video mode
    INT 10h ; Call to BIOS
    MOV MODO_VIDEO,AL ; We save the video mode and store it into AL
    mov ah, 00h ; We set the video mode
    mov al, 0Dh ; 320x200 VGA
    int 10h

    ; we store in es the segment where the program executed by int 1ch is stored so we can access the variables
    mov ax, 0
    mov es, ax
    mov ax, es:[1Ch*4+2]
    mov es, ax

    ; we set the x and y position od both players
    ; blue:
    mov byte ptr es:[273h], 50
    mov byte ptr es:[274h], 100

    ; red:
    mov byte ptr es:[275h], 200
    mov byte ptr es:[276h], 100

bucle:
    ; blue
    mov ax, es:[273h]
    ; if ah is 251 it means that the key q was pressed
    cmp ah, 251
    je fin
    ; the program checks if the new position is inside the limits
    cmp ah, 180             ; if < 0 => ah (unsigned) < 256
    ja limits_exceeded_blue
    cmp al, 240
    ja limits_exceeded_blue
    int 55h

    ; red
    mov ax, es:[275h]
    cmp ah, 180
    ja limits_exceeded_red
    cmp al, 240
    ja limits_exceeded_red
    int 57h
    jmp bucle


limits_exceeded_blue:
    mov dx, OFFSET limits_exceeded_blue_txt
    mov bx, OFFSET red_wins_txt
    jmp print_limits_exceeded

limits_exceeded_red:
    mov dx, OFFSET limits_exceeded_red_txt
    mov bx, OFFSET blue_wins_txt

print_limits_exceeded:
    mov ah, 00h ; Restore the input configuration to video mode
    mov al, MODO_VIDEO ; 
    int 10h
    mov ah, 9
    int 21h

print_winner:
    mov ah, 9
    mov dx, bx
    int 21h
    mov ax, 4C00H
    int 21H

fin:
    ; END OF THE PROGRAMME
    mov ah, 00h ; Restore the input configuration to video mode
    mov al, MODO_VIDEO ; 
    int 10h
    mov ax, 4C00H
    int 21H
BEGIN ENDP
; SPACE FOR SUBROUTINES


; END OF THE CODE SEGMENT
CODE ENDS
; END OF THE PROGRAMME POINTING OUT WHERE THE EXECUTION BEGINS
END BEGIN