# Algoritmi - Roberto Scaramuzzino
# Capitolo 45
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def luhn_valido(numero):
    somma = 0
    for p, c in enumerate(reversed(numero.replace(' ', ''))):
        c = int(c)
        if p % 2 == 1:
            c *= 2
            if c > 9:
                c -= 9
        somma += c
    return somma % 10 == 0

def cifra_di_controllo(parziale):
    for c in '0123456789':
        if luhn_valido(parziale + c):
            return c

print(luhn_valido('4539 1488 0343 6467'))
print(luhn_valido('4539 1488 0343 6476'))      # scambio
print(luhn_valido('4539 1488 0343 6468'))      # cifra errata
print(cifra_di_controllo('453914880343646'))

def parita(byte):
    return bin(byte).count('1') % 2

print(parita(0b1011001), parita(0b1011000))


import zlib

def crc32_semplice(dati):
    crc = 0xFFFFFFFF
    for b in dati:
        crc ^= b
        for _ in range(8):
            if crc & 1:
                crc = (crc >> 1) ^ 0xEDB88320
            else:
                crc >>= 1
    return crc ^ 0xFFFFFFFF

TABELLA = []
for n in range(256):
    c = n
    for _ in range(8):
        c = (c >> 1) ^ 0xEDB88320 if c & 1 else c >> 1
    TABELLA.append(c)

def crc32(dati):
    crc = 0xFFFFFFFF
    for b in dati:
        crc = (crc >> 8) ^ TABELLA[(crc ^ b) & 0xFF]
    return crc ^ 0xFFFFFFFF

messaggio = b'Algoritmi'
print(hex(crc32_semplice(messaggio)), hex(crc32(messaggio)),
      hex(zlib.crc32(messaggio)))
print(hex(crc32(b'Algoritni')), hex(crc32(b'lAgoritmi')))


def fnv1a(dati):
    h = 2166136261
    for b in dati:
        h ^= b
        h = h * 16777619 % 2 ** 32
    return h

def bit_diversi(a, b):
    return bin(a ^ b).count('1')

print(hex(fnv1a(b'algoritmo')), hex(fnv1a(b'algoritmi')))
print(bit_diversi(fnv1a(b'algoritmo'), fnv1a(b'algoritmi')))

conta = [0] * 7
for i in range(8000):
    conta[fnv1a(f'chiave-{i}'.encode()) % 7] += 1
print(conta)


import hashlib
import hmac

print(hashlib.sha256(b'Algoritmi').hexdigest()[:32])
print(hashlib.sha256(b'algoritmi').hexdigest()[:32])

chiave = b'chiave-segreta'
def firma(messaggio):
    return hmac.new(chiave, messaggio, 'sha256').hexdigest()

ricevuta = firma(b'trasferisci 100')
print(len(ricevuta))
uguali = hmac.compare_digest
print(uguali(ricevuta, firma(b'trasferisci 100')))
print(uguali(ricevuta, firma(b'trasferisci 900')))


import base64
import string

ALFABETO = (string.ascii_uppercase + string.ascii_lowercase
            + string.digits + '+/')

def in_base64(dati):
    uscita = []
    for i in range(0, len(dati), 3):
        gruppo = dati[i:i + 3]
        mancanti = 3 - len(gruppo)
        n = int.from_bytes(gruppo + b'\x00' * mancanti, 'big')
        quattro = [ALFABETO[n >> s & 63]
                   for s in (18, 12, 6, 0)]
        if mancanti:
            quattro[-mancanti:] = '=' * mancanti
        uscita.extend(quattro)
    return ''.join(uscita)

def da_base64(testo):
    dati = bytearray()
    testo = testo.rstrip('=')
    for i in range(0, len(testo), 4):
        gruppo = testo[i:i + 4]
        n = 0
        for c in gruppo:
            n = n << 6 | ALFABETO.index(c)
        n <<= 6 * (4 - len(gruppo))
        dati += n.to_bytes(3, 'big')[:len(gruppo) - 1]
    return bytes(dati)

for prova in (b'Man', b'Ma', b'M', b'Algoritmi!'):
    codificato = in_base64(prova)
    assert codificato == base64.b64encode(prova).decode()
    assert da_base64(codificato) == prova
    print(prova, codificato, prova.hex())


def in_utf8(p):
    if p < 0x80:
        return bytes([p])
    if p < 0x800:
        return bytes([0xC0 | p >> 6, 0x80 | p & 0x3F])
    if p < 0x10000:
        return bytes([0xE0 | p >> 12, 0x80 | p >> 6 & 0x3F,
                      0x80 | p & 0x3F])
    return bytes([0xF0 | p >> 18, 0x80 | p >> 12 & 0x3F,
                  0x80 | p >> 6 & 0x3F, 0x80 | p & 0x3F])

def da_utf8(dati):
    punti, i = [], 0
    while i < len(dati):
        b = dati[i]
        if b < 0x80:
            lunghezza, p = 1, b
        elif b >> 5 == 0b110:
            lunghezza, p = 2, b & 0x1F
        elif b >> 4 == 0b1110:
            lunghezza, p = 3, b & 0x0F
        elif b >> 3 == 0b11110:
            lunghezza, p = 4, b & 0x07
        else:
            raise ValueError(f'byte non valido in {i}')
        for k in range(1, lunghezza):
            if i + k >= len(dati) or dati[i + k] >> 6 != 0b10:
                raise ValueError(f'sequenza troncata in {i}')
            p = p << 6 | dati[i + k] & 0x3F
        punti.append(p)
        i += lunghezza
    return punti

for p in (65, 232, 8364, 128512):
    b = in_utf8(p)
    assert b == chr(p).encode('utf-8')
    print(p, b.hex(' '), ' '.join(f'{x:08b}' for x in b))
parola = 'perch\u00e9'             # e con accento acuto
print(da_utf8(parola.encode('utf-8')))
print(len(parola), len(parola.encode('utf-8')))
try:
    da_utf8(b'\xe2\x82')
except ValueError as e:
    print(e)
