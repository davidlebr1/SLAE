import sys
import os
import commands

#pass the nasm file to compile it.
#generate the shellcode of the compiled file
#copy the shellcode in the compiler
#test the shellcode

print "[*] Compiling nasm file"
os.system("nasm -f elf32 -o {}.o {}.nasm".format(sys.argv[1], sys.argv[1]))
os.system("ld -m elf_i386 -s -o {} {}.o".format(sys.argv[1], sys.argv[1]))

print "[*] Generating Shellcode"
#objdump -d ./xor_decoder_marker|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g'
status, shellcode = commands.getstatusoutput("objdump -d ./{}|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\\\x/g'|paste -d '' -s |sed 's/^/\"/'|sed 's/$/\"/g'".format(sys.argv[1]))
print "[*] Shellcode : \n"
print shellcode+"\n"

print "[*] Testing the Shellcode"
f = open("shellcode.c", "w")
f.write("#include<stdio.h>\n\
#include<string.h>\n\
unsigned char code[] = \\\n\
"+ shellcode + ";\n\
main(){\n\
\tprintf(\"Shellcode Length:  %d\\n\", strlen(code));\n\
\tint (*ret)() = (int(*)())code;\n\
\tret();\n\
}")
f.close()

commands.getstatusoutput("gcc -m32 -fno-stack-protector -z execstack shellcode.c -o shellcode")
os.system("./shellcode")
