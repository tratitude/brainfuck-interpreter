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
.code

SyntaxCheck proc 
	; []+-.<>,
	mov ecx,SIZEOF buffer
	mov esi,OFFSET buffer
	mov edi,OFFSET AfterSyntaxCheck
	L1:
		mov al,[esi]
		;call WriteChar
		inc esi
		push esi
		push ecx
		mov ecx,8
		mov esi,OFFSET ValidCharacter
		L2:
			mov bl,[esi]
			;mov al,
			;call WriteChar
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



main proc
	
	call ReadFileName
	mov edx, OFFSET buffer
	call SyntaxCheck
	mov edx, OFFSET AfterSyntaxCheck
	mov ecx, SIZEOF AfterSyntaxCheck
	call WriteString
	call crlf
    call WaitMsg
	invoke ExitProcess,0
main endp
end main