;**************************************************************************
; MBS 2021. LABORATORY ASSIGNMENT 4a
; Author: Pablo Izaguirre garcia
; Group: 1301
; Task: 4a
;**************************************************************************

; CODE SEGMENT DEFINITION
CODE SEGMENT
ASSUME CS: CODE

ORG 256

start: jmp installer

install_status_txt DB 10, " Installation driver status: ", 13, 10, '$'
instructions_txt DB 10, 10, " Developed by Pablo Izaguirre.", 10, 10, " Usage:", 10, 10, 9, "/I", 9, "Install the driver in case it is not previously installed.", 10, 10, 9, "/U", 9, "Uninstall the driver in case it is installed", 13, 10, '$'
int_55h_txt DB 10, 9, "Int 55h: ", '$'
int_57h_txt DB 10, 9, "Int 57h: ", '$'
int_1ch_txt DB 10, 9, "Int 1Ch: ", '$'
not_installed_txt DB "Not installed", 13, 10, '$'
installed_txt DB "Installed", 13, 10, '$'
argument_error_txt DB "Incorrect arguments", 13, 10, '$'
installing_txt DB "Interruptions 55h, 57h and 1Ch installed", 13, 10, '$'
uninstalling_txt DB "Interruptions 55h, 57h and 1Ch uninstalled", 13, 10, '$'


MODO_VIDEO db 0

MSEC dw 0

; Interrupt service routine for 1Ch
isr_1ch PROC FAR
    push bx ax
    mov bx, MSEC
    add bx, 55
    cmp bx, 10000
    jb continue_1ch
    sub bx, 10000
    mov ah, 2
    mov dl, 43
    int 21h
    
continue_1ch:
    mov MSEC, bx
    pop ax bx
    jmp fin_isr
isr_1ch ENDP

isr_1ch_old PROC FAR
    iret
isr_1ch_old ENDP

; Interrupt service routine
isr PROC FAR
blue:   
    push bx
    mov bl, 1
    jmp start_isr

red:
    push bx
    mov bl, 4

start_isr:
    ; Save modified registers
    push di cx ax dx si
    ; Routine instructions

    ; di has the size of the square
    mov di, 10
    ; dx has the x position
    mov ch, 0
    mov cl, al
    ; dx has the y position
    mov dh, 0
    mov dl, ah

    ; ; We use 10h interrupción to enter in video mode
    ; MOV AH,0Fh ; Asking for video mode
    ; INT 10h ; Call to BIOS
    ; MOV MODO_VIDEO,AL ; We save the video mode and store it into AL
    ; mov ah, 00h ; We set the video mode
    ; mov al, 12h ; 640x480 16 color graphics (VGA)
    ; int 10h

    MOV SI, CX
    ADD SI, DI
DRAW_SQUARE_IR_NORTH:
    ;Int10H draw pixel --> AH=0Ch 	AL = Colour, BH = PageNumber, CX = x, DX = y
    mov ah, 0Ch
    ; Read from the stack the value for the colour
    mov al, bl ; 
    mov bh, 00h ; page number (keep it always to zero)
    int 10h
    INC CX
    CMP CX, SI
    JNE DRAW_SQUARE_IR_NORTH

    SUB SI, DI
    ADD DX, DI
DRAW_SQUARE_IR_SOUTH:
    ;Int10H draw pixel --> AH=0Ch 	AL = Colour, BH = PageNumber, CX = x, DX = y
    mov ah, 0Ch
    ; Read from the stack the value for the colour
    mov al, bl ; 
    mov bh, 00h ; page number (keep it always to zero)
    int 10h
    DEC CX
    CMP CX, SI
    JNE DRAW_SQUARE_IR_SOUTH

    MOV SI, DX
    SUB SI, DI
DRAW_SQUARE_IR_WEST:
    ;Int10H draw pixel --> AH=0Ch 	AL = Colour, BH = PageNumber, CX = x, DX = y
    mov ah, 0Ch
    ; Read from the stack the value for the colour
    mov al, bl ; 
    mov bh, 00h ; page number (keep it always to zero)
    int 10h
    DEC DX
    CMP DX, SI
    JNE DRAW_SQUARE_IR_WEST

    ADD CX, DI
    ADD SI, DI
DRAW_SQUARE_IR_EAST:
    ;Int10H draw pixel --> AH=0Ch 	AL = Colour, BH = PageNumber, CX = x, DX = y
    mov ah, 0Ch
    ; Read from the stack the value for the colour
    mov al, bl ; 
    mov bh, 00h ; page number (keep it always to zero)
    int 10h
    INC DX
    CMP DX, SI
    JNE DRAW_SQUARE_IR_EAST

    ; ;Int15H active waiting in milliseconds: 1 millon us = 1 segundo
    ; MOV     CX, 2Dh ; CX:DX are the waiting time: 1 second = F:4240H --> 3 seconds 2D:C6C0h
    ; MOV     DX, 0C6C0h
    ; MOV     AH, 86H ;int15h with AH=86h to microseconds waiting in CX:DX
    ; INT     15H

    ; mov ah, 00h ; Restore the input configuration to video mode
    ; mov al, MODO_VIDEO ; 
    ; int 10h

    ; Restore modified registers
    pop si dx ax cx di bx
fin_isr:
    iret
isr ENDP

installer PROC
    mov ah, 9           ; ah is set to 9 so we can print text using int 21h
    ; check the parameters:
    ; in ds:[80h] there is a byte that indicates the size of the parameters
    cmp byte ptr ds:[80h], 0
    je no_arguments
    ; if the argument is /U we uninstall the interruptions (it is compared to I/ because the system is little endian)
    cmp word ptr ds:[82h], "U/"
    je uninstall
    ; if the argument is /I we install the interruptions (it is compared to I/ because the system is little endian)
    cmp word ptr ds:[82h], "I/"
    call install
    

    ; if something different happens, we print an error
    mov dx, OFFSET argument_error_txt
    int 21h

    jmp fin

uninstall:
    mov bp, 55h
    call uninstall_int
    mov bp, 57h
    call uninstall_int
    ; To uninstall our program from int 1ch we have to install the previous program
    mov bp, 1Ch
    call uninstall_int
    mov ax, 0
    mov es, ax
    mov bx, cs
    mov ax, OFFSET isr_1ch_old
    cli
    mov es:[ 1Ch*4 ], ax
    mov es:[ 1Ch*4+2 ], bx
    sti
    ; We print that the interruptions have been uninstalled
    mov dx, OFFSET uninstalling_txt
    int 21h
    jmp fin


; the next part prints information about the program and its usage
no_arguments:
    mov dx,OFFSET install_status_txt		;PRINTS THE INSTALLATION STATUS TEXT
	int 21h
    
    ; print int 55h
    mov cx, cs
    mov ds, cx
    mov dx, OFFSET int_55h_txt
    int 21h

    ; First we check if the interruption 55h has been installed by checking if the interrupt vector is set to 0
    mov cx, 0
    mov es, cx
    cmp word ptr es:[55h*4], 0
    jne int_55h_installed
    cmp word ptr es:[55h*4+2], 0
    jne int_55h_installed
    ; if we reach this point it means that the vector is 0
    mov dx, OFFSET not_installed_txt
    int 21h
    jmp check_int_57h
int_55h_installed:
    mov dx, OFFSET installed_txt
    int 21h
    
check_int_57h:
    mov dx, OFFSET int_57h_txt
    int 21h
    ; now I check if the interruption 57h has been installed
    cmp word ptr es:[57h*4], 0
    jne int_57h_installed
    cmp word ptr es:[57h*4+2], 0
    jne int_57h_installed
    ; if we reach this point it means that the vector is 0
    mov dx, OFFSET not_installed_txt
    int 21h
    jmp check_int_1ch
int_57h_installed:
    mov dx, OFFSET installed_txt
    int 21h

check_int_1ch:
    mov dx, OFFSET int_1ch_txt
    int 21h
    ; now I check if the interruption 1ch has been installed
    cmp word ptr es:[1ch*4], OFFSET isr_1ch
    jne int_1ch_not_installed
    ; mov bx, cs
    ; cmp word ptr es:[1ch*4+2], bx
    ; jne int_1ch_not_installed
    ; if we reach this point it means that it has been installed
    mov dx, OFFSET installed_txt
    int 21h
    jmp fin_print_status
int_1ch_not_installed:
    mov dx, OFFSET not_installed_txt
    int 21h

fin_print_status:
    mov ah, 9
    MOV DX, OFFSET instructions_txt  		;PRINTS THE TEXT WITH THE INSTRUCTIONS
	INT 21H

fin:
    ; we end the program
    mov ax,4C00H			; FIN DE PROGRAMA Y VUELTA AL DOS
 	int 21h
installer ENDP

install PROC NEAR
    mov dx, OFFSET installing_txt
    int 21h
    mov ax, 0
    mov es, ax
    mov ax, OFFSET blue
    mov bx, cs
    cli
    mov es:[ 55h*4 ], ax
    mov es:[ 55h*4+2 ], bx
    sti
    mov ax, OFFSET red
    cli
    mov es:[ 57h*4 ], ax
    mov es:[ 57h*4+2 ], bx
    sti
    mov ax, OFFSET isr_1ch
    cli
    mov es:[ 1Ch*4 ], ax
    mov es:[ 1Ch*4+2 ], bx
    sti
    mov dx, OFFSET installer
    int 27h ; Terminate and stay resident
install ENDP

; bp indica la instruccion que queremos desinstalar
uninstall_int PROC
    push ax bx cx ds es
    shl bp, 1
    shl bp, 1
    add bp, 2   ; now bp is bp * 4 + 2
    mov cx, 0
    mov ds, cx ; Segment of interrupt vectors
    mov es, ds:[ bp ] ; Read ISR segment
    mov bx, es:[ 2Ch ] ; Read segment of environment from ISR’s PSP.
    mov ah, 49h
    int 21h ; Release ISR segment (es)
    mov es, bx
    int 21h ; Release segment of environment variables of ISR
    ; Set vector of interrupt 40h to zero
    cli
    sub bp, 2
    mov ds:[ bp ], cx ; cx = 0
    add bp, 2
    mov ds:[ bp ], cx
    sti
    pop es ds cx bx ax
    ret
uninstall_int ENDP

; END OF THE CODE SEGMENT
CODE ENDS
; END OF THE PROGRAMME POINTING OUT WHERE THE EXECUTION BEGINS
END start