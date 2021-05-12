;**************************************************************************
; MBS 2021. LABORATORY ASSIGNMENT 4
; Author: Pablo Izaguirre garcia
; Group: 1301
; Task: 2
;**************************************************************************
; DATA SEGMENT DEFINITION
DATA SEGMENT

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
    mov al, 13h ; 320x200 VGA
    int 10h

    ; blue:
    mov bl, 50
    mov bh, 100

    ; red:
    mov cl, 200
    mov ch, 100

    mov ax, bx
    int 55h
    mov ax, cx
    int 57h

    mov ah, 1
wait_for_key:
    int 16h
    jz wait_for_key

    mov ah, 0
    int 16h         ; this interruption will store in al the ascii code for the pressed key

    cmp al, "q"
    je fin

    call move_box
    mov ah, 1
    jmp wait_for_key

fin:
    ; END OF THE PROGRAMME
    mov ah, 00h ; Restore the input configuration to video mode
    mov al, MODO_VIDEO ; 
    int 10h

    mov ax, 4C00H
    int 21H
BEGIN ENDP
; SPACE FOR SUBROUTINES

; the ascii for the key has to be stored in al, bx has the blue position and cx has the red position
move_box proc NEAR
    
    cmp al, "a"
    jne key_s
    ; if the key is a
    cmp bl, 0
    jbe fin_move_box
    sub bl, 10
    jmp fin_move_box
key_s:
    cmp al, "s"
    jne key_d
    ; if the key is s
    cmp bh, 180
    jae fin_move_box
    add bh, 10
    jmp fin_move_box
key_d:
    cmp al, "d"
    jne key_w
    ; if key is d
    cmp bl, 240
    jae fin_move_box
    add bl, 10
    jmp fin_move_box
key_w:
    cmp al, "w"
    jne key_j
    ; if key is w
    cmp bh, 0
    jbe fin_move_box
    sub bh, 10
    jmp fin_move_box
key_j:
    cmp al, "j"
    jne key_k
    ; if the key is j
    cmp cl, 0
    jbe fin_move_box
    sub cl, 10
    jmp fin_move_box
key_k:
    cmp al, "k"
    jne key_l
    ; if the key is k
    cmp ch, 180
    jae fin_move_box
    add ch, 10
    jmp fin_move_box
key_l:
    cmp al, "l"
    jne key_i
    ; if key is l
    cmp cl, 240
    jae fin_move_box
    add cl, 10
    jmp fin_move_box
key_i:
    cmp al, "i"
    jne other_key
    ; if key is i
    cmp ch, 0
    jbe fin_move_box
    sub ch, 10
    jmp fin_move_box
other_key:
    ret
fin_move_box:
    mov ax, bx
    int 55h
    mov ax, cx
    int 57h
    ret
move_box endp

; END OF THE CODE SEGMENT
CODE ENDS
; END OF THE PROGRAMME POINTING OUT WHERE THE EXECUTION BEGINS
END BEGIN