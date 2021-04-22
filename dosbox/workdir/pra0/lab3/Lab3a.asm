;*********************************************************************
;* 
;*
;* Microprocessor-Based Systems
;* 2020-2021
;* Lab 3b
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
		PUBLIC _drawPixel		
		PUBLIC _drawSquare
		
	_MAIN ENDP 


	;******************
	; DRAW PIXEL 1 F1
	;******************

	_drawPixel proc far
		; we store the value of the registers that we will be changing
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

		;we restore the value of the registers
		POP BX
		POP DX
		POP CX
		POP BP
		; ax<-0 to indicate that the execution was correct
		mov ax, 0
		ret

	DRAW_PIXEL_ERROR:
		; we restore the value of the registers
		POP BX
		POP DX
		POP CX
		POP BP
		; ax<-1 to indicate that there was an error
		MOV AX, -1
		RET
	_drawPixel endp

	;******************
	; DRAW SQUARE 1 F2
	;******************

	_drawSquare proc far
		; we store the value of the registers that we will be changing during the 
		; execution of this subroutine
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

		; we check that the input values are correct
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
		; a -1 is stored in ax to indicate that the execution failed
		MOV AX, -1
		; we restore the value of the registers
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

		; we store 0 in ax to indicate that the execution was correct
		MOV AX, 0
		; we restore the value of the registers
		POP SI
		POP DI
		POP DX
		POP CX
		POP BX
		POP BP

		RET
	_drawSquare endp

	
_TEXT ENDS 
END