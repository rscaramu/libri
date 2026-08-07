# Capitolo 7 — I cicli: while, repeat, for

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 6](capitolo-06.md) · [Indice](README.md) · [Capitolo 8 →](capitolo-08.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap07/`](../codice/cap07/).

---

**ES 7.4 — Fattoriale e traboccamento**

*Scrivi un programma che calcoli il fattoriale di un numero letto da
tastiera usando un ciclo, e stampi un avvertimento quando il
risultato supera il massimo intero rappresentabile. Verifica a
partire da quale valore accade.*

```lua
local function fattoriale(n)
  if math.type(n) ~= "integer" or n < 0 then
    return nil, "serve un intero non negativo"
  end
  local r = 1
  for i = 2, n do
    r = r * i
  end
  return r
end

local function fattorialeSicuro(n)
  if math.type(n) ~= "integer" or n < 0 then
    return nil, "serve un intero non negativo"
  end
  local r = 1
  for i = 2, n do
    if r > math.maxinteger // i then
      return nil, "traboccamento a n = " .. i
    end
    r = r * i
  end
  return r
end

for n = 18, 22 do
  local grezzo = fattoriale(n)
  local sicuro, errore = fattorialeSicuro(n)
  print(string.format("%2d!  %22d  %s", n, grezzo,
    sicuro and "ok" or errore))
end
```

produce:

```text
18!        6402373705728000  ok
19!      121645100408832000  ok
20!     2432902008176640000  ok
21!    -4249290049419214848  traboccamento a n = 21
22!    -1250660718674968576  traboccamento a n = 21
```

Il fattoriale trabocca a **ventuno**: venti fattoriale è il più grande
rappresentabile con un intero a sessantaquattro bit.

Il fatto che il risultato diventi **negativo** è il segnale visibile
dell’avvolgimento descritto nel paragrafo 4.5: gli interi di Lua non
segnalano il traboccamento, ripartono dall’altro estremo.

Il controllo `r > math.maxinteger // i` verifica **prima** di
moltiplicare, ed è il modo corretto: controllare dopo sarebbe inutile,
perché il valore è già corrotto.

**ES 7.5 — Fibonacci con `for` e con `while`**

*Scrivi un programma che stampi i primi trenta numeri della
successione di Fibonacci usando un `for` numerico e senza
ricorsione. Poi modificalo perché si fermi al primo numero maggiore
di un milione, usando un `while`.*

```lua
local a, b = 0, 1
io.write("Primi 30: ")
for i = 1, 30 do
  io.write(a, " ")
  a, b = b, a + b
end
io.write("\n")

local x, y = 0, 1
local quanti = 0
while x <= 1000000 do
  x, y = y, x + y
  quanti = quanti + 1
end
print(string.format(
  "Primo termine oltre un milione: %d (indice %d)",
  x, quanti))
```

Le due versioni rispondono a domande diverse e i costrutti riflettono la
differenza.

Il `for` numerico serve quando il **numero di iterazioni è noto in
anticipo**: trenta termini, trenta giri.

Il `while` serve quando la fine dipende da una **condizione sui dati**:
non sappiamo quanti termini servano per superare un milione finché non ci
arriviamo.

Scambiare i due costrutti è possibile ma innaturale: un `for` con
`break` per il secondo caso, o un contatore manuale con `while` per il
primo, funzionerebbero e sarebbero meno leggibili.

Notate l’aggiornamento simultaneo `a, b = b, a + b`, che sfrutta la
valutazione anticipata dell’assegnazione multipla vista nell’ES 3.6.
Scriverlo in due righe richiederebbe una variabile temporanea.

**ES 7.6 — Figure di testo**

*Scrivi un programma che disegni con caratteri di testo un triangolo,
un rombo e una clessidra di altezza data dall’utente. Usa
`string.rep` invece di cicli interni dove possibile e confronta la
leggibilità delle due soluzioni.*

```lua
local function triangolo(altezza)
  local righe = {}
  for i = 1, altezza do
    righe[#righe + 1] = string.rep(" ", altezza - i)
      .. string.rep("*", 2 * i - 1)
  end
  return table.concat(righe, "\n")
end

local function rombo(mezzaAltezza)
  local righe = {}
  for i = 1, mezzaAltezza do
    righe[#righe + 1] = string.rep(" ", mezzaAltezza - i)
      .. string.rep("*", 2 * i - 1)
  end
  for i = mezzaAltezza - 1, 1, -1 do
    righe[#righe + 1] = string.rep(" ", mezzaAltezza - i)
      .. string.rep("*", 2 * i - 1)
  end
  return table.concat(righe, "\n")
end

local function clessidra(mezzaAltezza)
  local righe = {}
  for i = mezzaAltezza, 1, -1 do
    righe[#righe + 1] = string.rep(" ", mezzaAltezza - i)
      .. string.rep("*", 2 * i - 1)
  end
  for i = 2, mezzaAltezza do
    righe[#righe + 1] = string.rep(" ", mezzaAltezza - i)
      .. string.rep("*", 2 * i - 1)
  end
  return table.concat(righe, "\n")
end

print(triangolo(4)) print()
print(rombo(4))     print()
print(clessidra(4))
```

produce:

```text
   *
  ***
 *****
*******

   *
  ***
 *****
*******
 *****
  ***
   *

*******
 *****
  ***
   *
  ***
 *****
*******
```

Il confronto con la versione a cicli annidati è netto. Con `string.rep`
ogni riga è **una espressione**; con i cicli servirebbero due cicli
interni per riga, uno per gli spazi e uno per gli asterischi, con
altrettante possibilità di sbagliare i limiti.

Le tre figure condividono la stessa formula per la riga: `altezza - i`
spazi seguiti da `2 * i - 1` asterischi. Cambia solo l’ordine in cui si
percorre `i`. Riconoscere che le tre figure sono la stessa espressione
percorsa in modi diversi è la parte interessante dell’esercizio.

**ES 7.7 — Le espressioni del `for` valutate una volta**

*Dimostra sperimentalmente che le tre espressioni del `for` numerico
sono valutate una sola volta. Scrivi un programma che usi come
valore finale una chiamata di funzione che stampa un messaggio, e
conta quante volte il messaggio compare.*

```lua
local chiamate = 0

local function limite()
  chiamate = chiamate + 1
  print("  limite() chiamata (" .. chiamate .. ")")
  return 3
end

print("for con chiamata come valore finale:")
for i = 1, limite() do
  print("  iterazione " .. i)
end
print("chiamate totali: " .. chiamate)

chiamate = 0
print()
print("while con la stessa chiamata:")
local i = 1
while i <= limite() do
  print("  iterazione " .. i)
  i = i + 1
end
print("chiamate totali: " .. chiamate)
```

produce:

```text
for con chiamata come valore finale:
  limite() chiamata (1)
  iterazione 1
  iterazione 2
  iterazione 3
chiamate totali: 1

while con la stessa chiamata:
  limite() chiamata (1)
  iterazione 1
  limite() chiamata (2)
  iterazione 2
  limite() chiamata (3)
  iterazione 3
  limite() chiamata (4)
chiamate totali: 4
```

Il `for` chiama la funzione **una sola volta**, prima di iniziare. Il
`while` la chiama a ogni verifica della condizione, quindi quattro volte
per tre iterazioni: l’ultima è quella che risulta falsa.

La conseguenza pratica va oltre la curiosità. Se il valore finale è
`#tabella` e la tabella cresce dentro il ciclo, il `for` non se ne
accorge; il `while` sì. E se il calcolo del limite è costoso, il `for`
lo paga una volta e il `while` a ogni giro: sostituire
`while i <= #t do` con `for i = 1, #t do` è talvolta un’ottimizzazione
significativa.

**ES 7.8 — Tre modi di saltare elementi**

*Scrivi tre versioni dello stesso ciclo che deve saltare alcuni
elementi: una con la condizione invertita, una con `goto`, una con
una funzione estratta. Misura le tre versioni con `os.clock` su un
milione di iterazioni e commenta sia i tempi sia la leggibilità.*

```lua
local N = 1000000

local function conInversione()
  local somma = 0
  for i = 1, N do
    if i % 3 ~= 0 then
      somma = somma + i
    end
  end
  return somma
end

local function conGoto()
  local somma = 0
  for i = 1, N do
    if i % 3 == 0 then goto continua end
    somma = somma + i
    ::continua::
  end
  return somma
end

local function elabora(i, accumulatore)
  if i % 3 == 0 then return accumulatore end
  return accumulatore + i
end

local function conFunzione()
  local somma = 0
  for i = 1, N do
    somma = elabora(i, somma)
  end
  return somma
end

local prove = {
  {"condizione invertita", conInversione},
  {"goto", conGoto},
  {"funzione estratta", conFunzione},
}

local riferimento = nil
for _, p in ipairs(prove) do
  collectgarbage("collect")
  local inizio = os.clock()
  local r = p[2]()
  local durata = os.clock() - inizio
  riferimento = riferimento or r
  print(string.format("%-24s %.4f s  %s", p[1], durata,
    r == riferimento and "ok" or "RISULTATO DIVERSO"))
end
```

I tempi sono confrontabili fra la condizione invertita e il `goto`, che
generano bytecode quasi identico; la versione con funzione estratta è
sensibilmente più lenta, perché paga una chiamata per iterazione.

Sulla leggibilità il giudizio è netto: la **condizione invertita** è la
più chiara e va preferita quando la logica è semplice. Il `goto` diventa
utile solo quando le condizioni di salto sono più d’una e l’inversione
produrrebbe un annidamento profondo. La funzione estratta è la più lenta
ma è l’unica **testabile separatamente**, e su logiche complesse quel
vantaggio supera il costo.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
