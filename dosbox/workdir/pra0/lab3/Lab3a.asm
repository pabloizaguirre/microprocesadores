;*********************************************************************
;* 
;*
;* Microprocessor-Based Systems
;* 2020-2021
;* Lab 3a
;* 
;*
;* author: 
;*
;* notes: empty example
;*********************************************************************/

; DEFINITION OF THE CODE SEGMENT AS PUBLIC
_TEXT SEGMENT BYTE PUBLIC 'CODE'
    ASSUME CS:_TEXT
	MODO_VIDEO DB 0
	; BEGINNING OF THE MAIN PROCEDURE
	_MAIN PROC 
		;THE PROGRAMME STARTS
		PUBLIC _drawPixel		
		PUBLIC _drawSquare
		PUBLIC _drawPixelsList
		
	_MAIN ENDP 


	;******************
	; DRAW PIXEL 1 F1
	;******************

	_drawPixel proc far
		PUSH BP
		MOV BP, SP
		PUSH CX
		PUSH DX
		PUSH BX

		MOV CX, [BP + 8]	; CX <- X
		MOV DX, [BP + 10]	; DX <- Y
		MOV BX, [BP + 6]	; BX <- COLOUR

		; We check that the position is in range
		CMP CX, 0
		JL DRAW_PIXEL_ERROR
		CMP CX, 640
		JG DRAW_PIXEL_ERROR
		CMP DX, 0
		JL DRAW_PIXEL_ERROR
		CMP DX, 480
		JG DRAW_PIXEL_ERROR

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
		mov al, bl ; white colour 1111b
		mov bh, 00h ; page number (keep it always to zero)
		int 10h

		;Int15H active waiting in milliseconds: 1 millon us = 1 segundo
		MOV     CX, 2Dh ; CX:DX are the waiting time: 1 second = F:4240H --> 3 seconds 2D:C6C0h
		MOV     DX, 0C6C0h
		MOV     AH, 86H ;int15h with AH=86h to microseconds waiting in CX:DX
		INT     15H

		mov ah, 00h ; Restore the input configuration to video mode
		mov al, MODO_VIDEO ; 
		int 10h

		;mov [BP + 2], 0
		POP BX
		POP DX
		POP CX
		POP BP
		mov ax, 0
		ret

	DRAW_PIXEL_ERROR:
		;mov [BP + 2], -1
		POP BX
		POP DX
		POP CX
		POP BP
		MOV AX, -1
		RET
	_drawPixel endp

	;******************
	; DRAW SQUARE 1 F2
	;******************

	_drawSquare proc far
		PUSH BP
		MOV BP, SP
		PUSH BX
		PUSH CX
		PUSH DX
		PUSH DI
		PUSH SI

		MOV CX, [BP + 10]	; CX <- X
		MOV DX, [BP + 12]	; DX <- Y
		MOV DI, [BP + 8]	; DI <- SIZE
		MOV BX, [BP + 6]	; BX <- COLOR

		CMP CX, 0
		JL DRAW_SQUARE_ERROR
		CMP DX, 0
		JL DRAW_SQUARE_ERROR
		MOV AX, 640
		SUB AX, DI
		CMP CX, AX
		JG DRAW_SQUARE_ERROR
		MOV AX, 480
		SUB AX, DI
		CMP DX, AX
		JG DRAW_SQUARE_ERROR

		JMP DRAW_SQUARE_CONTINUE

	DRAW_SQUARE_ERROR:
		MOV AX, -1
		POP SI
		POP DI
		POP DX
		POP CX
		POP BX
		POP BP
		RET
	
	DRAW_SQUARE_CONTINUE:
		
		; We use 10h interrupción to enter in video mode
		MOV AH,0Fh ; Asking for video mode
		INT 10h ; Call to BIOS
		MOV MODO_VIDEO,AL ; We save the video mode and store it into AL
		mov ah, 00h ; We set the video mode
		mov al, 12h ; 640x480 16 color graphics (VGA)
		int 10h

		MOV SI, CX
		ADD SI, DI
	DRAW_SQUARE_IR_NORTH:
		;Int10H draw pixel --> AH=0Ch 	AL = Colour, BH = PageNumber, CX = x, DX = y
		mov ah, 0Ch
		; Read from the stack the value for the colour
		mov al, bl ; white colour 1111b
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
		mov al, bl ; white colour 1111b
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
		mov al, bl ; white colour 1111b
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
		mov al, bl ; white colour 1111b
		mov bh, 00h ; page number (keep it always to zero)
		int 10h
		INC DX
		CMP DX, SI
		JNE DRAW_SQUARE_IR_EAST

		;Int15H active waiting in milliseconds: 1 millon us = 1 segundo
		MOV     CX, 2Dh ; CX:DX are the waiting time: 1 second = F:4240H --> 3 seconds 2D:C6C0h
		MOV     DX, 0C6C0h
		MOV     AH, 86H ;int15h with AH=86h to microseconds waiting in CX:DX
		INT     15H

		mov ah, 00h ; Restore the input configuration to video mode
		mov al, MODO_VIDEO ; 
		int 10h

		MOV AX, 0
		POP SI
		POP DI
		POP DX
		POP CX
		POP BX
		POP BP

		RET
	_drawSquare endp

	;***********************
	; DRAW PIXELS LIST 2 F3
	;***********************

	_drawPixelsList proc far
		push bp
		mov bp, sp
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
		
		mov ds, [bp + 15]	; ds<-segment(pixellistx)
		
		;mov es, [bp + 19]	; es<-segment(pixellisty)
		;mov di, [bp + 17]	; di<-offset(pixellisty)

		;mov sp, [bp + 23]	; sp<-segment(pixellistColor)

		mov si, 0
		mov di, 0 

	draw_pixels_list_ir:
		mov bx, [bp + 13]	; bx<-offset(pixelistx)
		mov cx, ds:[bx + di]
		
		mov es, [bp + 19]	; es<-segment(pixellisty)
		mov bx, [bp + 17]	; bx<-offset(pixellisty)
		mov dx, es:[bx + di]
		
		mov es, [bp + 23]	; es<-segment(pixellistColor)
		mov bx, [bp + 21]	; ax<-segment(pixellistColor)
		mov ax, es:[bx + si]

		;Int10H draw pixel --> AH=0Ch 	AL = Colour, BH = PageNumber, CX = x, DX = y
		mov ah, 0Ch
		; Read from the stack the value for the colour
		mov al, bl ; white colour 1111b
		mov bh, 00h ; page number (keep it always to zero)
		int 10h

		inc si
		add di, 2
		cmp si, [bp + 6]
		jl draw_pixels_list_ir

		mov cx, [bp + 11]
		mov dx, [bp + 9]

		;Int15H active waiting in milliseconds: 1 millon us = 1 segundo
		MOV     AH, 86H ;int15h with AH=86h to microseconds waiting in CX:DX
		INT     15H

		mov ah, 00h ; Restore the input configuration to video mode
		mov al, MODO_VIDEO ; 
		int 10h

		mov ax, 0
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