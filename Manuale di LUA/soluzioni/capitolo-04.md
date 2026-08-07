# Capitolo 4 — Numeri e operatori aritmetici

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 3](capitolo-03.md) · [Indice](README.md) · [Capitolo 5 →](capitolo-05.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap04/`](../codice/cap04/).

---

**ES 4.4 — Le sette operazioni con il tipo del risultato**

*Scrivi un programma che, dati due interi, stampi il risultato di
tutte e sette le operazioni aritmetiche indicando per ciascuna se il
risultato è un intero o un float. Prova con valori negativi e
commenta i risultati che ti hanno sorpreso.*

```lua
local function analizza(a, b)
  local operazioni = {
    {"a + b",  a + b},
    {"a - b",  a - b},
    {"a * b",  a * b},
    {"a / b",  a / b},
    {"a // b", a // b},
    {"a % b",  a % b},
    {"a ^ b",  a ^ b},
  }

  print(string.format("--- a = %s, b = %s ---",
    tostring(a), tostring(b)))
  for _, op in ipairs(operazioni) do
    print(string.format("  %-6s = %-22s %s",
      op[1], tostring(op[2]), math.type(op[2])))
  end
end

analizza(7, 3)
analizza(-7, 3)
analizza(7, -3)
analizza(7.0, 3)
```

Con `a = 7` e `b = 3` si ottengono interi per addizione, sottrazione,
moltiplicazione, divisione intera e modulo; float per la divisione e per
l’elevamento a potenza.

Le sorprese sono due. La **divisione restituisce sempre un float**, anche
quando il risultato è matematicamente intero: `6 / 3` vale `3.0`.
L’**elevamento a potenza restituisce sempre un float**, anche `2 ^ 2`.

Con operandi negativi la sorpresa è il segno del modulo: `-7 % 3` vale
due, non meno uno. E la divisione intera arrotonda verso il basso: `-7 //
3` vale meno tre, non meno due.

Basta che **uno** dei due operandi sia float perché tutti i risultati
diventino float: è la coercizione descritta nel paragrafo 4.4.

**ES 4.5 — Da euro a centesimi**

*Scrivi una funzione che converta un importo in euro, espresso come
numero in virgola mobile, in un intero di centesimi, gestendo
correttamente l’arrotondamento. Dimostra con almeno tre casi perché
fare la conversione con `x * 100` e basta è sbagliato.*

```lua
local function aCentesimi(euro)
  if type(euro) ~= "number" then
    return nil, "atteso un numero"
  end
  -- Arrotondamento simmetrico, non troncamento
  if euro >= 0 then
    return math.floor(euro * 100 + 0.5)
  end
  return math.ceil(euro * 100 - 0.5)
end

local prove = {0.1, 0.29, 1.15, 8.35, 19.99,
               -2.675, 0.005}

for _, e in ipairs(prove) do
  local ingenuo = math.floor(e * 100)
  local corretto = aCentesimi(e)
  print(string.format(
    "%8.3f  ingenuo=%5d  corretto=%5d  %s",
    e, ingenuo, corretto,
    ingenuo == corretto and "" or "<-- DIVERSI"))
end

print(string.format("%.20f", 0.29 * 100))
print(string.format("%.20f", 1.15 * 100))
print(string.format("%.20f", 8.35 * 100))
```

produce:

```text
   0.100  ingenuo=   10  corretto=   10
   0.290  ingenuo=   28  corretto=   29  <-- DIVERSI
   1.150  ingenuo=  114  corretto=  115  <-- DIVERSI
   8.350  ingenuo=  835  corretto=  835
  19.990  ingenuo= 1998  corretto= 1999  <-- DIVERSI
  -2.675  ingenuo= -268  corretto= -268
   0.005  ingenuo=    0  corretto=    1  <-- DIVERSI
28.99999999999999644729
114.99999999999998578915
835.00000000000000000000
```

I casi che dimostrano perché `x * 100` non basta:

**`0.29 * 100`** non vale esattamente ventinove ma un valore
lievemente inferiore, come le venti cifre decimali mostrano.
`math.floor` tronca a ventotto: **un centesimo sparito**.

**`1.15 * 100`** ha lo stesso problema e produce centoquattordici
invece di centoquindici; `19.99` produce millenovecentonovantotto.

**`8.35 * 100`** invece è esatto: e questo è il punto peggiore. Il
difetto non colpisce tutti i valori, ma solo alcuni, in modo che non si
può prevedere senza controllare. Un programma che gestisce importi con
`math.floor(euro * 100)` funziona sulla maggior parte dei casi di prova e
sbaglia su una frazione delle transazioni reali.

**`0.005`** è il caso a metà fra due centesimi: qualunque convenzione si
adotti, va dichiarata.

La lezione del Capitolo 4 vale integralmente: la conversione da float a
centesimi è già di per sé un ripiego. In un sistema che tratta denaro
sul serio, gli importi non dovrebbero mai essere float **in nessun
punto**: si leggono come stringhe e si convertono in interi analizzando
le cifre, senza passare dalla virgola mobile.

**ES 4.6 — Numeri primi**

*Scrivi una funzione che verifichi se un numero è primo, usando solo
gli operatori di questo capitolo e la funzione `math.sqrt`. Testala
sui primi trenta numeri naturali e su almeno un numero primo grande.*

```lua
local function ePrimo(n)
  if type(n) ~= "number" or n ~= math.floor(n) then
    return false
  end
  if n < 2 then return false end
  if n < 4 then return true end
  if n % 2 == 0 then return false end

  local limite = math.floor(math.sqrt(n))
  local i = 3
  while i <= limite do
    if n % i == 0 then return false end
    i = i + 2
  end
  return true
end

io.write("Primi fino a 30: ")
for n = 1, 30 do
  if ePrimo(n) then io.write(n, " ") end
end
io.write("\n")

local grandi = {97, 100, 7919, 7920,
                104729, 1000003, 1000005}
for _, n in ipairs(grandi) do
  print(string.format("%8d  %s", n,
    ePrimo(n) and "primo" or "composto"))
end
```

Tre ottimizzazioni rispetto alla versione ingenua.

**Si prova solo fino alla radice quadrata.** Se `n` ha un divisore
maggiore della radice, ne ha necessariamente uno minore.

**Si scartano subito i pari.** Dopo il due, nessun pari è primo.

**Si prova solo con i dispari**, avanzando di due.

L’uso di `math.floor(math.sqrt(n))` invece di confrontare `i * i <= n` è
una scelta: calcola la radice una volta sola invece di moltiplicare a
ogni iterazione. Su numeri molto grandi, però, `math.sqrt` passa dai
float e può perdere precisione: la forma `i * i <= n` con `i` intero è
più sicura, ed è quella usata nel Capitolo 22.

**ES 4.7 — La tabella dei segni del modulo**

*Il capitolo afferma che il modulo di Lua restituisce sempre un
valore con il segno del divisore. Verificalo scrivendo un programma
che stampi una tabella dei risultati di `a % b` per tutte le
combinazioni di segno, e confronta i risultati con quelli che
otterresti in un linguaggio che segue la convenzione del C.*

```lua
local valori = {7, -7}
local divisori = {3, -3}

print(string.format("%5s %5s %8s %8s %10s",
  "a", "b", "a % b", "a // b", "verifica"))

for _, a in ipairs(valori) do
  for _, b in ipairs(divisori) do
    local resto = a % b
    local quoziente = a // b
    -- La definizione: a == (a // b) * b + (a % b)
    local ricostruito = quoziente * b + resto
    print(string.format("%5d %5d %8d %8d %10s",
      a, b, resto, quoziente,
      ricostruito == a and "ok" or "ERRORE"))
  end
end
```

produce:

```text
    a     b    a % b   a // b   verifica
    7     3        1        2         ok
    7    -3       -2       -3         ok
   -7     3        2       -3         ok
   -7    -3       -1        2         ok
```

Il **resto ha sempre il segno del divisore**. Con divisore positivo il
resto è positivo o nullo; con divisore negativo è negativo o nullo.

Nella convenzione del C, che tronca verso lo zero, i risultati sarebbero
stati: `7 % 3` uguale a uno, `7 % -3` uguale a uno, `-7 % 3` uguale a
meno uno, `-7 % -3` uguale a meno uno. Il resto avrebbe il segno del
**dividendo**.

La colonna di verifica conferma che in entrambe le convenzioni vale
l’identità `a == (a // b) * b + (a % b)`: cambia quale delle due
operazioni si sceglie di definire per prima.

La convenzione di Lua è quella comoda per gli indici circolari, come
dimostrato nell’ES 4.2.

**ES 4.8 — Rappresentazione binaria**

*Scrivi una funzione che converta un numero intero nella sua
rappresentazione binaria come stringa, usando solo gli operatori bit
a bit e la concatenazione. Deve funzionare anche sui numeri
negativi: spiega nel commento che cosa scegli di mostrare in quel
caso e perché.*

```lua
local function binario(n, cifre)
  if type(n) ~= "number" or math.type(n) ~= "integer" then
    return nil, "serve un intero"
  end

  cifre = cifre or 0
  if n == 0 then
    return string.rep("0", math.max(1, cifre))
  end

  local negativo = n < 0
  local bit = {}

  if negativo then
    -- Rappresentazione in complemento a due su 64 bit:
    -- e' quella che Lua usa davvero in memoria.
    for i = 63, 0, -1 do
      bit[#bit + 1] = tostring((n >> i) & 1)
    end
    return table.concat(bit)
  end

  local v = n
  while v > 0 do
    table.insert(bit, 1, tostring(v & 1))
    v = v >> 1
  end

  while #bit < cifre do
    table.insert(bit, 1, "0")
  end

  return table.concat(bit)
end

for _, n in ipairs({0, 1, 2, 5, 10, 255, 256, 1023}) do
  print(string.format("%6d  %s", n, binario(n, 8)))
end

print()
print("  -1  " .. binario(-1))
print("  -2  " .. binario(-2))
print(" -10  " .. binario(-10))
```

Sui negativi si sceglie il **complemento a due su sessantaquattro bit**,
che è la rappresentazione che Lua usa realmente in memoria. Meno uno
diventa una sequenza di sessantaquattro uni, meno due termina con uno
zero.

L’alternativa sarebbe stampare il segno seguito dal binario del valore
assoluto, cioè `-1010` per meno dieci. È più leggibile per un essere
umano ma **non corrisponde a nulla**: nessun bit in memoria ha quella
forma, e uno scorrimento a destra su meno dieci non produrrebbe il
risultato che quella notazione suggerisce.

La scelta va dichiarata perché entrambe sono difendibili: dipende se
volete mostrare il numero o la sua rappresentazione.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
