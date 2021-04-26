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
	MULT_ARRAY DB 1,2,4,8,5,10,9,7,3,6
	; BEGINNING OF THE MAIN PROCEDURE
	_MAIN PROC 
		;THE PROGRAMME STARTS
		PUBLIC _findSubString	
		PUBLIC _calculateSecondDC
		
	_MAIN ENDP 


	;******************
	; FIND SUBSTRING F1
	;******************

	_findSubString proc far
		push bp 
		mov bp, sp 
		push es
		push di
		push ds
		push dx
		push si
		
		mov es, [bp + 8]	; es <- segment(str)
		mov di, [bp + 6]	; di <- offset(str)

		mov ds, [bp + 12]	; ds <- segment(substr)
		mov bx, [bp + 10]	; dx <- offset(substr)

		mov si, 0
		mov ah, byte ptr ds:[bx]		; ah is the character we are checking from the substring

	find_substring_ir1:
		mov al, byte ptr es:[di]		; al is the character we are checking from the string
		cmp al, 0
		; if ah is 0 we have reached the end of the string without finding the substring
		je find_substring_notfound

		inc di
		cmp al, ah
		je find_substring_match
		; this part executes when the letter are different
		mov si, 0
		mov ah, byte ptr ds:[bx + si]	; we start all over again and search for the whole substring
		
		; we look at the next letter
		jmp find_substring_ir1

	find_substring_match:
		inc si
		mov ah, byte ptr ds:[bx + si]	; there was a match, so we check if the next element of both strings match (or if we have already found the whole substring)
		cmp ah, 0
		jne find_substring_ir1
		; if it reaches this point it means that the substring was found in the string
		mov ax, di			; di is the offset of the last checked element of the string
		sub ax, [bp + 6]	; [bp + 6] is the offset of the first element of the string => now ax is the index if the last checked element of the string
		sub ax, si			; si is the size of the substring => now ax is the index of the first time the substring appears in the string
		jmp find_substring_end

	find_substring_notfound:
		mov ax, -1

	find_substring_end:
		pop si
		pop dx
		pop ds
		pop di
		pop es
		pop bp
		ret
	_findSubString endp

	;************************
	; CALCULATE SECOND DC F2
	;************************

	_calculateSecondDC proc far
		push bp
		mov bp, sp
		push es
		push bx
		push si
		push dx
		push cx

		les bx, [bp + 6]		; es <- segment(accNumber); bx <- offset(accNumber)

		mov si, 0				; si is the counter
		mov dx, 0				; dx stores the sum

	calculate_second_dc_ir:
		mov al, es:[bx][si]		; al <- accNumber[si]
		sub al, 48				; al <- int(cx)
		mul MULT_ARRAY[si]		; ax <- accNumber[si] * mult_array[si]
		add dx, ax				; we add the result to the sum
		inc si
		cmp si, 10
		jne calculate_second_dc_ir

		mov ax, dx				; ax <- sum
		; the modulus is a number between 0 and 10, so it fits in an 8 bit register
		mov ch, 11
		div ch					; al <- sum/11; ah <- sum%11

		mov al, ah
		mov ah, 0
		mov dx, 11
		sub dx, ax				; dx <- 11 - sum%11
		mov ax, dx				; ax <- dx
		
		; the initial values of the registers are restored
		pop cx
		pop dx
		pop si
		pop bx
		pop es
		pop bp
		cmp ax, 10				; if the result is 10, we return 1
		je calculate_second_dc_10
		ret

	calculate_second_dc_10:
		mov ax, 1
		ret

	_calculateSecondDC endp
	
_TEXT ENDS 
END