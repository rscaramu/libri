# Capitolo 5 — Stringhe: il primo tipo davvero interessante

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 4](capitolo-04.md) · [Indice](README.md) · [Capitolo 6 →](capitolo-06.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap05/`](../codice/cap05/).

---

**ES 5.4 — Prefisso e suffisso senza pattern**

*Scrivi una funzione che verifichi se una stringa comincia con un
prefisso dato e un’altra che verifichi se termina con un suffisso
dato, senza usare i pattern. Gestisci il caso in cui il prefisso sia
più lungo della stringa.*

```lua
local function iniziaCon(s, prefisso)
  if type(s) ~= "string" or type(prefisso) ~= "string" then
    return nil, "attese due stringhe"
  end
  if #prefisso > #s then return false end
  if #prefisso == 0 then return true end
  return s:sub(1, #prefisso) == prefisso
end

local function finisceCon(s, suffisso)
  if type(s) ~= "string" or type(suffisso) ~= "string" then
    return nil, "attese due stringhe"
  end
  if #suffisso > #s then return false end
  if #suffisso == 0 then return true end
  return s:sub(-#suffisso) == suffisso
end

local prove = {
  {"programmazione", "pro", true, false},
  {"programmazione", "one", false, true},
  {"pro", "programmazione", false, false},
  {"abc", "", true, true},
  {"", "", true, true},
  {"", "x", false, false},
  {"abc", "abc", true, true},
}

for _, p in ipairs(prove) do
  local i = iniziaCon(p[1], p[2])
  local f = finisceCon(p[1], p[2])
  print(string.format("%-16s %-16s inizia=%-5s "
    .. "finisce=%-5s %s",
    "[" .. p[1] .. "]", "[" .. p[2] .. "]",
    tostring(i), tostring(f),
    (i == p[3] and f == p[4]) and "ok" or "ERRORE"))
end
```

Tre casi limite vanno gestiti esplicitamente.

**Il prefisso più lungo della stringa**: senza il controllo, la chiamata
`s:sub(1, 20)` su una stringa di tre caratteri restituirebbe la stringa
intera, che non coincide con il prefisso, quindi il risultato sarebbe
comunque corretto. Ma il controllo esplicito evita una sottostringa
inutile ed è più chiaro.

**Il prefisso vuoto**: per convenzione ogni stringa inizia con la stringa
vuota. Senza il controllo, `s:sub(1, 0)` restituisce la stringa vuota e
il confronto darebbe comunque `true`, quindi qui il controllo è
ridondante ma documenta la decisione.

**`s:sub(-#suffisso)` con suffisso vuoto** darebbe `s:sub(0)`, cioè
l’intera stringa: **questo caso il controllo lo salva davvero**, ed è il
motivo per cui la simmetria con `iniziaCon` non è perfetta.

**ES 5.5 — Importo all’italiana**

*Scrivi una funzione che formatti un numero intero di centesimi come
importo in euro all’italiana, con il punto come separatore delle
migliaia e la virgola come separatore decimale. Verifica il
risultato su zero, su valori negativi e su un miliardo di centesimi.*

```lua
local function formattaEuro(centesimi)
  if math.type(centesimi) ~= "integer" then
    return nil, "servono centesimi come intero"
  end

  local negativo = centesimi < 0
  local assoluto = math.abs(centesimi)

  local euro = assoluto // 100
  local resto = assoluto % 100

  -- Separatore delle migliaia, dal fondo
  local cifre = tostring(euro)
  local gruppi = {}
  local fine = #cifre

  while fine > 3 do
    table.insert(gruppi, 1, cifre:sub(fine - 2, fine))
    fine = fine - 3
  end
  table.insert(gruppi, 1, cifre:sub(1, fine))

  local intero = table.concat(gruppi, ".")

  local risultato = string.format("%s,%02d", intero, resto)
  if negativo then risultato = "-" .. risultato end

  return risultato .. " EUR"
end

local prove = {0, 1, 99, 100, 150, 1000, 99999,
               100000000, -250, -1, 123456789}

for _, c in ipairs(prove) do
  print(string.format("%12d  %s", c, formattaEuro(c)))
end
```

produce:

```text
           0  0,00 EUR
           1  0,01 EUR
          99  0,99 EUR
         100  1,00 EUR
         150  1,50 EUR
        1000  10,00 EUR
       99999  999,99 EUR
   100000000  1.000.000,00 EUR
        -250  -2,50 EUR
          -1  -0,01 EUR
   123456789  1.234.567,89 EUR
```

Il `%02d` sui centesimi è essenziale: senza, un centesimo produrrebbe
`0,1` invece di `0,01`.

Il segno va applicato **alla fine**, sul risultato completo, e non
lasciando che `//` e `%` lavorino su un valore negativo: con la semantica
del *floor* di Lua, `-250 // 100` vale meno tre e `-250 % 100` vale
cinquanta, che non è affatto ciò che vogliamo. Lavorare sul valore
assoluto e riapplicare il segno evita il problema.

Il raggruppamento delle migliaia si fa dal fondo perché il primo gruppo
può avere una, due o tre cifre.

**ES 5.6 — Concatenazione contro table.concat**

*Misura empiricamente la differenza di prestazioni fra la
concatenazione in ciclo e `table.concat`. Scrivi un programma che
esegua entrambe su mille, diecimila e centomila iterazioni,
misurando con `os.clock`, e commenta l’andamento dei tempi.*

```lua
local function conConcatenazione(n)
  local s = ""
  for i = 1, n do
    s = s .. i .. ","
  end
  return #s
end

local function conTabella(n)
  local pezzi = {}
  for i = 1, n do
    pezzi[#pezzi + 1] = i
  end
  return #table.concat(pezzi, ",") + n
end

local function misura(f, n)
  collectgarbage("collect")
  local inizio = os.clock()
  local r = f(n)
  return os.clock() - inizio, r
end

print(string.format("%9s %12s %12s %10s",
  "N", "CONCAT", "TABLE", "RAPPORTO"))

for _, n in ipairs({1000, 10000, 100000}) do
  local t1 = misura(conConcatenazione, n)
  local t2 = misura(conTabella, n)
  print(string.format("%9d %12.4f %12.4f %9.1fx",
    n, t1, t2, t2 > 0 and t1 / t2 or 0))
end
```

Sulla macchina di prova i tempi crescono così: la concatenazione
quadruplica passando da mille a diecimila e da diecimila a centomila
cresce di un fattore molto maggiore, mentre `table.concat` cresce
**linearmente**, cioè decuplicando a ogni decuplicazione di `n`.

Il motivo è nell’immutabilità delle stringhe, spiegata nel paragrafo 5.2:
ogni concatenazione crea una stringa nuova copiando tutto il contenuto
precedente. Sommando le copie si ottiene un costo proporzionale al
**quadrato** del numero di iterazioni.

Il rapporto fra i due tempi cresce quindi con `n`: su mille elementi la
differenza è modesta, su centomila è di ordini di grandezza. È
esattamente il motivo per cui l’errore passa i test e si manifesta in
produzione.

**ES 5.7 — Parole in ordine inverso**

*Scrivi una funzione che, data una stringa, restituisca la stessa
stringa con le parole in ordine inverso, mantenendo la punteggiatura
attaccata alla parola che la precede. Usa solo le funzioni di questo
capitolo.*

```lua
local function invertiParole(frase)
  if type(frase) ~= "string" then
    return nil, "attesa una stringa"
  end

  local parole = {}
  local corrente = {}

  for i = 1, #frase do
    local c = frase:sub(i, i)
    if c == " " or c == "\t" or c == "\n" then
      if #corrente > 0 then
        parole[#parole + 1] = table.concat(corrente)
        corrente = {}
      end
    else
      corrente[#corrente + 1] = c
    end
  end
  if #corrente > 0 then
    parole[#parole + 1] = table.concat(corrente)
  end

  local invertite = {}
  for i = #parole, 1, -1 do
    invertite[#invertite + 1] = parole[i]
  end

  return table.concat(invertite, " ")
end

local prove = {
  "il gatto sul tetto",
  "Ciao, mondo! Come va?",
  "   spazi    multipli   ",
  "unaSolaParola",
  "",
}

for _, p in ipairs(prove) do
  print("[" .. p .. "]")
  print("  -> [" .. invertiParole(p) .. "]")
end
```

produce:

```text
[il gatto sul tetto]
  -> [tetto sul gatto il]
[Ciao, mondo! Come va?]
  -> [va? Come mondo! Ciao,]
[   spazi    multipli   ]
  -> [multipli spazi]
[unaSolaParola]
  -> [unaSolaParola]
[]
  -> []
```

La punteggiatura resta attaccata alla parola che la precede, come
richiesto: «Ciao,» resta un blocco unico, perché la divisione avviene
solo sugli spazi.

Gli spazi multipli vengono **normalizzati** a uno solo. È una
conseguenza dell’algoritmo, non una scelta esplicita, e va notata:
preservarli richiederebbe di conservare anche i separatori.

Il caso della stringa vuota e quello della parola singola funzionano
senza codice speciale, perché i cicli semplicemente non entrano o entrano
una volta sola.

Con i pattern del Capitolo 17 la divisione si riduce a una riga:
`for parola in frase:gmatch("%S+") do`.

**ES 5.8 — ASCII contro UTF-8**

*Scrivi un programma che dimostri con almeno quattro esempi distinti
come le operazioni sulle stringhe si comportino diversamente su
testo ASCII e su testo UTF-8. Per ogni caso proponi la versione
corretta usando la libreria `utf8` e spiega perché quella ingenua
sbaglia.*

```lua
local A = utf8.char(0xE0)      -- a con accento grave
local E = utf8.char(0xE8)      -- e con accento grave
local EU = utf8.char(0x20AC)   -- simbolo dell'euro

local ASCII = "citta e perche"
local UTF8 = "citt" .. A .. " e perch" .. E

print("=== 1. Lunghezza ===")
print(string.format("ASCII: #=%d  utf8.len=%d",
  #ASCII, utf8.len(ASCII)))
print(string.format("UTF-8: #=%d  utf8.len=%d",
  #UTF8, utf8.len(UTF8)))
print("Corretto: usare utf8.len per i caratteri.")
print()

print("=== 2. Sottostringa ===")
print("ASCII sub(1,5):  [" .. ASCII:sub(1, 5) .. "]")
local grezzo = UTF8:sub(1, 5)
print("UTF-8 sub(1,5) e' valido? "
  .. tostring(utf8.len(grezzo) ~= nil))
local fine = utf8.offset(UTF8, 6) - 1
print("UTF-8 corretto:  [" .. UTF8:sub(1, fine) .. "]")
print()

print("=== 3. Inversione ===")
print("ASCII reverse valido? "
  .. tostring(utf8.len(ASCII:reverse()) ~= nil))
print("UTF-8 reverse valido? "
  .. tostring(utf8.len(UTF8:reverse()) ~= nil))
local caratteri = {}
for _, codice in utf8.codes(UTF8) do
  table.insert(caratteri, 1, utf8.char(codice))
end
print("UTF-8 corretto:  [" .. table.concat(caratteri)
  .. "]")
print()

print("=== 4. Maiuscolo ===")
print("ASCII upper: [" .. ASCII:upper() .. "]")
print("UTF-8 upper: le lettere accentate NON cambiano,")
print("perche' string.upper opera su singoli byte")
print("usando le funzioni del C.")
print()

print("=== 5. Allineamento in colonna ===")
local nomi = {"citta", "citt" .. A, "euro " .. EU}
print("Con %-12s (byte):")
for _, n in ipairs(nomi) do
  print(string.format("  [%-12s]", n))
end
print("Con riempimento in caratteri:")
for _, n in ipairs(nomi) do
  local mancanti = 12 - utf8.len(n)
  print("  [" .. n .. string.rep(" ", mancanti) .. "]")
end
```

I cinque casi coprono le operazioni che si sbagliano più spesso.

Il **quinto è il più insidioso nella pratica**, perché non produce dati
corrotti ma output visivamente storto: una tabella incolonnata con
`string.format` risulta disallineata su ogni riga che contenga un accento
o un simbolo di valuta, e il difetto si nota solo guardando il risultato.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
