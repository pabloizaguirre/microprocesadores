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
instructions_txt DB 10, " Developed by Pablo Izaguirre.", 10, 10, " Usage:", 10, 10, 9, "/I", 9, "Install the driver in case it is not previously installed.", 10, 10, 9, "/U", 9, "Uninstall the driver in case it is installed", 13, 10, '$'
int_55h_txt DB "Instruction 55h: ", '$'
int_57h_txt DB "Instruction 57h: ", '$'
not_installed_txt DB "Not installed", 13, 10, '$'
installed_txt DB "Installed", 13, 10, '$'

MODO_VIDEO db 0

; Interrupt service routine
isr PROC FAR
    ; Save modified registers
    ; Routine instructions

    ; We use 10h interrupción to enter in video mode
    MOV AH,0Fh ; Asking for video mode
    INT 10h ; Call to BIOS
    MOV MODO_VIDEO,AL ; We save the video mode and store it into AL

    mov ah, 00h ; We set the video mode
    mov al, 12h ; 640x480 16 color graphics (VGA)
    int 10h
    ;Int10H draw pixel --> AH=0Ch 	AL = Colour, BH = PageNumber, CX = x, DX = y
    mov ah, 0Ch
    ; Read from the stack the value for the colour
    mov al, 0Fh ; white colour 1111b
    mov bh, 00h ; page number (keep it always to zero)
    mov cx,40 ; X position
    mov dx,40 ; Y position
    int 10h

    ;Int15H active waiting in milliseconds: 1 millon us = 1 segundo
    MOV     CX, 2Dh ; CX:DX are the waiting time: 1 second = F:4240H --> 3 seconds 2D:C6C0h
    MOV     DX, 0C6C0h
    MOV     AH, 86H ;int15h with AH=86h to microseconds waiting in CX:DX
    INT     15H

    mov ah, 00h ; Restore the input configuration to video mode
    mov al, MODO_VIDEO ; 
    int 10h
    
    ; Restore modified registers
    iret
isr ENDP

installer PROC

    mov ah, 9                               ;FUNCTION THAT ALLOWS TO PRINT A STRING
    MOV DX,OFFSET install_status_txt		;PRINTS THE INSTALLATION STATUS TEXT
	INT 21H
    
    mov cx, 0
    mov ds, cx
    mov dx, OFFSET int_55h_txt
    ; int 21h
    cmp word ptr ds:[55h*4+2], 0
    je int_55h_installed
    mov dx, OFFSET not_installed_txt
    ; int 21h
    jmp fin_print_status
int_55h_installed:
    mov dx, OFFSET installed_txt
    ; int 21h
fin_print_status:
				            
	
    mov ah, 9
    MOV DX,OFFSET instructions_txt  		;PRINTS THE TEXT WITH THE INSTRUCTIONS
	INT 21H


    


    MOV AX,4C00H			; FIN DE PROGRAMA Y VUELTA AL DOS
 	INT 21H




    ; mov ax, 0
    ; mov es, ax
    ; mov ax, OFFSET isr
    ; mov bx, cs
    ; cli
    ; mov es:[ 55h*4 ], ax
    ; mov es:[ 55h*4+2 ], bx
    ; sti
    ; mov dx, OFFSET installer
    ; int 27h ; Terminate and stay resident
installer ENDP

; bp indica la instruccion que queremos desinstalar
uninstall_int PROC
    push ax bx cx ds es
    shl bp, 1
    shl bp, 1
    add bp, 2   ; not bx is bx * 4 + 2
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