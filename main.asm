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

.code
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
	call WriteString

    call WaitMsg
	invoke ExitProcess,0
main endp
end main