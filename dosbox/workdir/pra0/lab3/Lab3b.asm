;*********************************************************************
;* 
;*
;* Microprocessor-Based Systems
;* 2020-2021
;* Lab 3a
;* 
;*
;* author: Pablo Izaguirre
;*
;* notes:
;*********************************************************************/

; DEFINITION OF THE CODE SEGMENT AS PUBLIC
_TEXT SEGMENT BYTE PUBLIC 'CODE'
    ASSUME CS:_TEXT
	MODO_VIDEO DB 0
	; BEGINNING OF THE MAIN PROCEDURE
	_MAIN PROC 
		;THE PROGRAMME STARTS
		PUBLIC _drawPixelsList
		
	_MAIN ENDP 

	;***********************
	; DRAW PIXELS LIST 2 F3
	;***********************

	_drawPixelsList proc far
		push bp
		mov bp, sp
		; we store the value of the registers we will be changing
		push ds
		push es
		push sp
		push bx
		push di
		push si
		push cx
		push dx

		; We use 10h interrupción to enter in video mode
		MOV AH,0Fh ; Asking for video mode
		INT 10h ; Call to BIOS
		MOV MODO_VIDEO,AL ; We save the video mode and store it into AL

		mov ah, 00h ; We set the video mode
		mov al, 12h ; 640x480 16 color graphics (VGA)
		int 10h

		mov bl, byte ptr [bp + 8]
		mov ah, 00h
		; We set the background colour to the color stored in bx
		mov ah, 0bh
		int 10h
		
		mov ds, [bp + 16]	; ds<-segment(pixellistx)

		mov si, 0
		mov di, 0 

	draw_pixels_list_ir:
		mov bx, [bp + 14]	; bx<-offset(pixelistx)
		mov cx, ds:[bx + di]
		
		mov es, [bp + 20]	; es<-segment(pixellisty)
		mov bx, [bp + 18]	; bx<-offset(pixellisty)
		mov dx, es:[bx + di]
		
		mov es, [bp + 24]	; es<-segment(pixellistColor)
		mov bx, [bp + 22]	; ax<-segment(pixellistColor)
		mov ax, es:[bx + si]

		;Int10H draw pixel --> AH=0Ch 	AL = Colour, BH = PageNumber, CX = x, DX = y
		mov ah, 0Ch
		; Read from the stack the value for the colour
		mov al, bl ; white colour 1111b
		mov bh, 00h ; page number (keep it always to zero)
		int 10h

		
		inc si
		; the elements of the pixelllistcolor are 2 bytes, so for each element we have to increase di by 2
		add di, 2
		cmp si, [bp + 6]		; if we have reached the number of pixels, we stop printing
		jl draw_pixels_list_ir

		; we get the waiting time from the stack
		mov cx, [bp + 12]
		mov dx, [bp + 10]

		;Int15H active waiting in milliseconds: 1 millon us = 1 segundo
		MOV     AH, 86H ;int15h with AH=86h to microseconds waiting in CX:DX
		INT     15H

		mov ah, 00h ; Restore the input configuration to video mode
		mov al, MODO_VIDEO ; 
		int 10h

		; we restore the value of the registers
		pop dx
		pop cx
		pop si
		pop di
		pop bx
		pop sp
		pop es
		pop ds
		pop bp
		ret
	_drawPixelsList endp

	
_TEXT ENDS 
END