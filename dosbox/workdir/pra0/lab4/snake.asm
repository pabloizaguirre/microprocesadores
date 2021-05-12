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
    collided_red_txt db " Red has collided", 13, 10, '$'
    collided_blue_txt db " Blue has collided", 13, 10, '$'
    blue_wins_txt db " Blue wins!!!", 13, 10, '$'
    red_wins_txt db " Red wins!!!", 13, 10, '$'
    positions_occupied_matrix db 19 dup(25 dup(0))
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

    ; we set the initial direction for the snakes (moving towards each other)
    mov byte ptr es:[278h], "d"
    mov byte ptr es:[279h], "j"

    ; we set the initial counter and update_time to 0 and 1000
    mov word ptr es:[27Ah], 1000
    mov byte ptr es:[27Ch], 0

    mov bx, -1
    mov dx, -1
bucle:
    ; blue
    mov ax, es:[273h]
    cmp ax, bx
    ; bx has the last registered position of blue, if it has changed, we update the game
    je bucle_red
    mov bx, ax
    ; if ah is 251 it means that the key q was pressed
    cmp ah, 251
    je fin
    ; the program checks if the new position is inside the limits
    cmp ah, 180             ; if < 0 => ah (unsigned) < 256
    ja limits_exceeded_blue
    cmp al, 240
    ja limits_exceeded_blue
    mov cx, ax
    call is_position_occupied
    cmp cx, 0
    jne collided_blue
    int 55h

bucle_red:
    ; red
    mov ax, es:[275h]
    cmp ax, dx
    ; dx has the last registered position of red, if it has changed, we update the game
    je bucle
    mov dx, ax
    ; now we check if the new position is correct, if not, red looses
    cmp ah, 180
    ja limits_exceeded_red
    cmp al, 240
    ja limits_exceeded_red
    mov cx, ax
    call is_position_occupied
    cmp cx, 0
    jne collided_red
    int 57h
    jmp bucle


collided_blue:
    mov dx, OFFSET collided_blue_txt
    mov bx, OFFSET red_wins_txt 
    jmp print_mistake

collided_red:
    mov dx, OFFSET collided_red_txt
    mov bx, OFFSET blue_wins_txt
    jmp print_mistake

limits_exceeded_blue:
    mov dx, OFFSET limits_exceeded_blue_txt
    mov bx, OFFSET red_wins_txt
    jmp print_mistake

limits_exceeded_red:
    mov dx, OFFSET limits_exceeded_red_txt
    mov bx, OFFSET blue_wins_txt

print_mistake:
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
    mov al, MODO_VIDEO 
    int 10h
    mov ax, 4C00H
    int 21H
BEGIN ENDP
; SPACE FOR SUBROUTINES

; the position has to be stored in cx
is_position_occupied proc NEAR
    push ax bp
    mov ax, 0
    mov al, ch
    ; we divide the y position by 10
    mov ch, 10
    div ch
    ; now al has x_pos/10
    mov ch, 25
    mul ch
    ; now ax has the row where the position is
    mov bp, ax
    ; now we have to find the column
    mov ax, 0
    mov al, cl
    mov cl, 10
    div cl
    ; now al has y_pos/10
    mov ah, 0
    add bp, ax
    
    cmp positions_occupied_matrix[bp], 0
    jne occupied
    mov cx, 0
    mov positions_occupied_matrix[bp], 1
    pop bp ax
    ret
occupied: 
    mov cx, 1
    pop bp ax
    ret
is_position_occupied endp

; END OF THE CODE SEGMENT
CODE ENDS
; END OF THE PROGRAMME POINTING OUT WHERE THE EXECUTION BEGINS
END BEGIN