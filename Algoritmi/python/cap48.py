# Algoritmi - Roberto Scaramuzzino
# Capitolo 48
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

import datetime

def bisestile(anno):
    if anno % 400 == 0:
        return True
    if anno % 100 == 0:
        return False
    return anno % 4 == 0

def giorni_da_data(anno, mese, giorno):
    if mese <= 2:
        anno -= 1
        mese += 12
    m = mese - 3
    nell_anno = (153 * m + 2) // 5 + giorno - 1
    return (365 * anno + anno // 4 - anno // 100
            + anno // 400 + nell_anno - 719468)

def data_da_giorni(n):
    n += 719468
    era, g = divmod(n, 146097)
    a = (g - g // 1460 + g // 36524 - g // 146096) // 365
    anno = a + era * 400
    nell_anno = g - (365 * a + a // 4 - a // 100)
    m = (5 * nell_anno + 2) // 153
    giorno = nell_anno - (153 * m + 2) // 5 + 1
    mese = m + 3
    if mese > 12:
        mese -= 12
        anno += 1
    return anno, mese, giorno

print([a for a in (1900, 2000, 2024, 2025, 2100)
       if bisestile(a)])
print(giorni_da_data(1970, 1, 1), giorni_da_data(2000, 3, 1))
print(data_da_giorni(0), data_da_giorni(19999))

origine = datetime.date(1970, 1, 1).toordinal()
for n in range(-719000, 2900000, 37):
    d = datetime.date.fromordinal(n + origine)
    assert data_da_giorni(n) == (d.year, d.month, d.day)
    assert giorni_da_data(d.year, d.month, d.day) == n
print('verificato')


NOMI = ('lunedi', 'martedi', 'mercoledi', 'giovedi',
        'venerdi', 'sabato', 'domenica')

def giorno_settimana(anno, mese, giorno):
    return (giorni_da_data(anno, mese, giorno) + 3) % 7

def giorni_del_mese(anno, mese):
    dopo = (anno + 1, 1) if mese == 12 else (anno, mese + 1)
    return (giorni_da_data(dopo[0], dopo[1], 1)
            - giorni_da_data(anno, mese, 1))

def aggiungi_mesi(anno, mese, giorno, mesi):
    totale = anno * 12 + (mese - 1) + mesi
    anno, mese = totale // 12, totale % 12 + 1
    ultimo_giorno = giorni_del_mese(anno, mese)
    return anno, mese, min(giorno, ultimo_giorno)

def ennesimo(anno, mese, settimana, n):
    # n-esimo giorno della settimana (0 = lunedi) del mese
    primo = giorno_settimana(anno, mese, 1)
    return 1 + (settimana - primo) % 7 + 7 * (n - 1)

def ultimo(anno, mese, settimana):
    fine = giorni_del_mese(anno, mese)
    w = giorno_settimana(anno, mese, fine)
    return fine - (w - settimana) % 7

print(NOMI[giorno_settimana(1582, 10, 15)],
      NOMI[giorno_settimana(1969, 7, 20)])
natale = giorni_da_data(2025, 12, 25)
print(natale - giorni_da_data(2025, 1, 1))
print(data_da_giorni(giorni_da_data(2024, 2, 20) + 10))
print([giorni_del_mese(2024, m) for m in range(1, 13)])
print(aggiungi_mesi(2025, 1, 31, 1),
      aggiungi_mesi(2024, 1, 31, 1),
      aggiungi_mesi(2025, 11, 15, 3))
print(ennesimo(2025, 11, 3, 3), ultimo(2025, 3, 6),
      ultimo(2025, 10, 6))


def pasqua(anno):
    a = anno % 19
    b, c = divmod(anno, 100)
    d, e = divmod(b, 4)
    f = (b + 8) // 25
    g = (b - f + 1) // 3
    h = (19 * a + b - d - g + 15) % 30
    i, k = divmod(c, 4)
    l = (32 + 2 * e + 2 * i - h - k) % 7
    m = (a + 11 * h + 22 * l) // 451
    mese, giorno = divmod(h + l - 7 * m + 114, 31)
    return mese, giorno + 1

print([pasqua(a) for a in (2024, 2025, 2026, 2027)])
tutte = [pasqua(a) for a in range(1900, 2100)]
print(min(tutte), max(tutte))
print(all(giorno_settimana(a, *pasqua(a)) == 6
          for a in range(1583, 3000)))


from datetime import datetime, timedelta, timezone
from zoneinfo import ZoneInfo

roma = ZoneInfo('Europe/Rome')
prima = datetime(2025, 3, 29, 12, 0, tzinfo=roma)
dopo = datetime(2025, 3, 30, 12, 0, tzinfo=roma)
print(prima.utcoffset(), dopo.utcoffset())
utc = timezone.utc
print(dopo.astimezone(utc) - prima.astimezone(utc))

ambigua = datetime(2025, 10, 26, 2, 30, tzinfo=roma)
seconda = ambigua.replace(fold=1)
print(ambigua.utcoffset(), seconda.utcoffset())

origine_unix = datetime(1970, 1, 1, tzinfo=timezone.utc)
limite = origine_unix + timedelta(seconds=2 ** 31 - 1)
print(limite.isoformat())
