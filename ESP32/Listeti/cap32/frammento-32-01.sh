# ESP32 — La guida completa alla famiglia · capitolo 32 (Sicurezza)
# Frammento — Secure Boot v2
# Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
# e non definite qui sono indicate nella didascalia o nel capitolo.

espsecure.py generate_signing_key --version 2 \
    --scheme ecdsa256 chiave_sb.pem
