/*
 * This shellcode will do a mkdir() of 'hacked' and then an exit()
 * Original shellcode by zillion@safemode.org with 36 bytes
 * Modified version by davidlebr1 with xx bytes
 *
 */

#include <stdio.h>
#include <string.h>


unsigned char code[] = "\x31\xc0\x50\xb0\x27\x68\x63\x6b\x65\x64\x68\x2e\x2f\x68\x61\x89\xe3\x66\xb9\xff\x01\xcd\x80\x6a\x01\x58\xcd\x80";
        

int main() {
  printf("Shellcode Length:  %d\n", (int)strlen(code));
  int (*ret)() = (int(*)())code;
  ret();
  return 0;
}