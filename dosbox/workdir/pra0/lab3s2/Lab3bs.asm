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
	; BEGINNING OF THE MAIN PROCEDURE
	_MAIN PROC 
		;THE PROGRAMME STARTS
		PUBLIC _findSubString	
		
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

	
_TEXT ENDS 
END