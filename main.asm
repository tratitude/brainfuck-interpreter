INCLUDE Irvine32.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode: DWORD

.data
MAX = 4096
inputHandle HANDLE ?
fileName BYTE 80 DUP(?)
buffer BYTE MAX DUP(?)	
bytesRead DWORD ?
AfterSyntaxCheck BYTE Max DUP(?)
ValidCharacter BYTE '[' ,']' ,'+' ,'-' ,'<' ,'>' ,',' ,'.'
ErrMsg BYTE "括號數量不對稱",0ah,0dh,0

;------------------------------
; ExecuteCode proceduce used variable
executeMemory BYTE MAX DUP(0)
executeMemoryLocation DWORD ?
codeLocation DWORD ?
whileCheck SBYTE ?
whileError BYTE "Syntax Error: while",0
;-------------------------------

.code

SyntaxCheck proc 
	; []+-.<>,
	mov ecx,SIZEOF buffer
	mov esi,OFFSET buffer
	mov edi,OFFSET AfterSyntaxCheck
	mov edx,0
	L1:
		mov al,[esi]
		.IF al=='['
				inc dh
		.ELSEIF al==']'
				inc dl
		.ENDIF
		.IF dl>dh
			jmp Err	
		.ENDIF
		
		inc esi
		push esi
		push ecx
		mov ecx,8
		mov esi,OFFSET ValidCharacter
		L2:
			mov bl,[esi]
			inc esi
			cmp	al,bl
			jne InValid

			push esi
			mov [edi],bl
			inc edi
			pop esi
			;call WaitMsg
			InValid:
		loop L2
		pop ecx
		pop esi
	loop L1
	mov bl,0
	mov [edi],bl
	.IF dl!=dh
		Err:
		mov edx,OFFSET ErrMsg
		call WriteString
	.ENDIF
	ret
SyntaxCheck endp



;-------------------------------------------------------------
ReadFileName proc uses eax ecx edx
;
; Read a file content into buffer string.
;-------------------------------------------------------------
	mov edx, OFFSET fileName
	mov ecx, SIZEOF fileName
	call ReadString

	mov edx, OFFSET fileName
	call OpenInputFile

	mov edx, OFFSET buffer
	mov ecx, SIZEOF buffer
	call ReadFromFile
	mov bytesRead, eax
	ret
ReadFileName endp

;-------------------
; BFInterpret proceduce
; Receive: edx(buffer offset with just bf code)
; Return: Nothing
; -------------------
BFInterpret proc
	mov codeLocation, edx
	mov eax, OFFSET executeMemory
	mov executeMemoryLocation, eax

Loop1:
     mov eax, codeLocation
	mov al, [eax]
	.IF al == 0
		jmp Return
	.ELSEIF al == '>'
		mov ebx, [executeMemoryLocation]
		inc ebx
		mov [executeMemoryLocation], ebx
		jmp CodeLoop
	.ELSEIF al == '<'
		mov ebx, [executeMemoryLocation]
		dec ebx
		mov [executeMemoryLocation], ebx
		jmp CodeLoop
	.ELSEIF al == '+'
		mov eax, [executeMemoryLocation]
          mov bl, [eax]
		inc bl
		mov [eax], bl
		jmp CodeLoop
	.ELSEIF al == '-'
          mov eax, [executeMemoryLocation]
          mov bl, [eax]
          dec bl
          mov[eax], bl
          jmp CodeLoop
	.ELSEIF al == '.'
          mov ebx, executeMemoryLocation
		mov al, [ebx]
		call WriteChar
		jmp CodeLoop
     .ELSEIF al == ','
          call ReadChar
		  call writechar
		  call crlf
          mov ebx, executeMemoryLocation
          mov[ebx], al
          jmp CodeLoop
	.ELSEIF al == '['
		mov ebx, [codeLocation]
		inc ebx
          mov [codeLocation], ebx
          mov al, [ebx]
		cmp al, ']'      ; nothing in while loop
		je CodeLoop
		
          mov eax, [executeMemoryLocation]
          mov bl, [eax]
          cmp bl, 0        ; jump out of while loop
          je FindEndWhile

          mov ebx, [codeLocation]
          dec ebx          ; decrease the addtional increasement
          push ebx         ; push while loop instruction
          mov [codeLocation], ebx
		jmp CodeLoop
	.ELSEIF al == ']'
		mov ebx, [executeMemoryLocation]
          mov al, [ebx]
		cmp al, 0        ; jump out while loop
		je PopCode
		
		pop ebx
		mov codeLocation, ebx
		push ebx
		jmp CodeLoop
	.ENDIF

FindEndWhile:           ; find end of while loop character ']'
	mov [whileCheck], 1 ; initialize whileCheck=1
	
	Loop2:
		mov ebx, [codeLocation]
          mov al, [ebx]
		.IF al == 0         ; if codeLocation = end of file(which initialized = 0)
			mov edx, OFFSET whileError
			call WriteString
			call Crlf
               jmp Return
		.ELSEIF al == '['   ; if codeLocation = '[', whileCheck = whileCheck +1
               mov bl, [whileCheck]
               inc bl
               mov [whileCheck], bl
		.ELSEIF al == ']'
			mov bl, [whileCheck]
			cmp bl, 1       ; if codeLocation = ']' and whileCheck = 1, find the right ']'
			je CodeLoop
			dec bl          ; if codeLocation = ']' and whileCheck = 1, find the wrong ']', whileCheck = whileCheck -1
			mov [whileCheck], bl
		.ENDIF
	Loop2EndIf:
		mov ebx, [codeLocation]
		inc ebx
		mov [codeLocation], ebx
		jmp Loop2
		
PopCode:
	pop ebx
	jmp CodeLoop
CodeLoop:
	mov ebx, [codeLocation]
     inc ebx
	mov [codeLocation], ebx
	jmp Loop1
Return:
	ret
BFInterpret endp


main proc
	
	call ReadFileName
	mov edx, OFFSET buffer
	call SyntaxCheck
	mov edx, OFFSET AfterSyntaxCheck
	call BFInterpret
	call crlf
    call WaitMsg
	invoke ExitProcess,0
main endp
end main
