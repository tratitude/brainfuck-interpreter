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
	L1:
		push ecx
		mov ecx,8
		mov esi,OFFSET ValidCharacter
		L2:
			cmp buffer,[esi]
			inc esi
			je Valid
			
			
		loop L2
		pop ecx
	loop L1
SyntaxCheck endp

main proc
	mov edx, OFFSET fileName
	mov ecx, SIZEOF fileName
	call ReadString

	mov edx, OFFSET fileName
	call OpenInputFile
	mov inputHandle, eax
	
	mov eax, inputHandle
	mov edx, OFFSET buffer
	mov ecx, SIZEOF buffer
	call ReadFromFile
	mov bytesRead, eax

	mov edx, OFFSET buffer
	call SyntaxCheck
	call WriteString
	call crlf
    call WaitMsg
	invoke ExitProcess,0
main endp
end main