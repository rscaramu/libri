# Capitolo 19 — Le librerie math, os e utf8

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 18](capitolo-18.md) · [Indice](README.md) · [Capitolo 20 →](capitolo-20.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap19/`](../codice/cap19/).

---

**ES 19.4 — Numero di settimana ISO 8601**

*Scrivi una funzione che, data una data, restituisca il numero della
settimana secondo la norma ISO 8601, dove la settimana comincia di
lunedì e la prima settimana dell’anno è quella che contiene il primo
giovedì. Verificala sui casi limite di fine e inizio anno.*

```lua
local function aTempo(anno, mese, giorno)
  return os.time({year = anno, month = mese,
    day = giorno, hour = 12})
end

local function giornoSettimanaIso(t)
  -- os.date restituisce 1 per domenica; ISO vuole
  -- 1 per lunedi' e 7 per domenica
  local w = tonumber(os.date("%w", t))
  if w == 0 then return 7 end
  return w
end

local function settimanaIso(anno, mese, giorno)
  local t = aTempo(anno, mese, giorno)
  local giornoIso = giornoSettimanaIso(t)

  -- Il giovedi' della stessa settimana determina
  -- l'anno ISO
  local giovedi = t + (4 - giornoIso) * 86400
  local annoIso = tonumber(os.date("%Y", giovedi))

  -- Il 4 gennaio appartiene sempre alla settimana 1
  local quattro = aTempo(annoIso, 1, 4)
  local giornoIsoQuattro = giornoSettimanaIso(quattro)
  local lunediSettimana1 =
    quattro - (giornoIsoQuattro - 1) * 86400

  local lunediCorrente = t - (giornoIso - 1) * 86400
  local settimane = math.floor(
    (lunediCorrente - lunediSettimana1) / (7 * 86400))

  return settimane + 1, annoIso, giornoIso
end

local casi = {
  {2026, 1, 1},   {2026, 1, 4},   {2026, 1, 5},
  {2026, 8, 7},   {2026, 12, 31},
  {2025, 12, 29}, {2025, 1, 1},
  {2024, 12, 30}, {2027, 1, 3},
  {2021, 1, 1},   {2020, 12, 31},
}

for _, c in ipairs(casi) do
  local settimana, annoIso, giorno =
    settimanaIso(c[1], c[2], c[3])
  print(string.format("%04d-%02d-%02d -> %04d-W%02d-%d",
    c[1], c[2], c[3], annoIso, settimana, giorno))
end
```

produce:

```text
2026-01-01 -> 2026-W01-4
2026-01-04 -> 2026-W01-7
2026-01-05 -> 2026-W02-1
2026-08-07 -> 2026-W32-5
2026-12-31 -> 2026-W53-4
2025-12-29 -> 2026-W01-1
2025-01-01 -> 2025-W01-3
2024-12-30 -> 2025-W01-1
2027-01-03 -> 2026-W53-7
2021-01-01 -> 2020-W53-5
2020-12-31 -> 2020-W53-4
```

I casi limite sono quelli interessanti e sono tutti corretti.

Il **29 dicembre 2025** appartiene alla settimana 1 del **2026**, perché
il giovedì di quella settimana cade nel 2026. L’anno ISO differisce
dall’anno di calendario.

Il **3 gennaio 2027** appartiene alla settimana 53 del 2026, per la
ragione simmetrica.

Il **primo gennaio 2021** appartiene alla settimana 53 del 2020.

La regola che governa tutto è che il **giovedì determina l’anno**: una
settimana appartiene all’anno in cui cade il suo giovedì. Da questa
regola discende che il 4 gennaio è sempre nella settimana 1, che è il
punto di ancoraggio del calcolo.

**ES 19.5 — Uniformità del generatore casuale**

*Scrivi un programma che misuri sperimentalmente l’uniformità di
`math.random(1, 6)` su un milione di lanci, calcolando frequenza
attesa e scarto. Poi fai lo stesso con la forma sbagliata basata su
`math.floor(math.random() * 6) + 1` e confronta.*

```lua
local N = 1000000
local FACCE = 6

local function misura(nome, generatore)
  local conteggi = {}
  for i = 1, FACCE do conteggi[i] = 0 end

  math.randomseed(42)
  local inizio = os.clock()
  for _ = 1, N do
    local v = generatore()
    conteggi[v] = (conteggi[v] or 0) + 1
  end
  local durata = os.clock() - inizio

  local atteso = N / FACCE
  local chiQuadro = 0
  local massimoScarto = 0

  print("=== " .. nome .. " ===")
  for i = 1, FACCE do
    local scarto = conteggi[i] - atteso
    local percentuale = scarto / atteso * 100
    chiQuadro = chiQuadro + scarto * scarto / atteso
    if math.abs(percentuale) > massimoScarto then
      massimoScarto = math.abs(percentuale)
    end
    print(string.format("  %d: %8d  scarto %+7.0f "
      .. "(%+.3f%%)", i, conteggi[i], scarto,
      percentuale))
  end

  local fuoriIntervallo = 0
  for chiave in pairs(conteggi) do
    if chiave < 1 or chiave > FACCE then
      fuoriIntervallo = fuoriIntervallo + 1
    end
  end

  print(string.format("  chi quadro: %.3f "
    .. "(soglia 5%% con 5 gradi: 11.07)", chiQuadro))
  print(string.format("  scarto massimo: %.3f%%",
    massimoScarto))
  print(string.format("  valori fuori intervallo: %d",
    fuoriIntervallo))
  print(string.format("  tempo: %.3f s", durata))
  print()
end

misura("math.random(1, 6)", function()
  return math.random(1, FACCE)
end)

misura("floor(random() * 6) + 1", function()
  return math.floor(math.random() * FACCE) + 1
end)

misura("floor(random() * 6 + 1) SBAGLIATO", function()
  return math.floor(math.random() * FACCE + 1)
end)
```

Con il seme quarantadue si ottiene un risultato che vale la pena
guardare con attenzione:

```text
=== math.random(1, 6) ===
  chi quadro: 12.219 (soglia 5% con 5 gradi: 11.07)
  scarto massimo: 0.527%
  valori fuori intervallo: 0

=== floor(random() * 6) + 1 ===
  chi quadro: 2.665 (soglia 5% con 5 gradi: 11.07)
  scarto massimo: 0.299%
  valori fuori intervallo: 0
```

Il generatore **corretto** supera la soglia del chi quadro, quello
teoricamente meno pulito no. Chi si fermasse qui concluderebbe l’opposto
di ciò che è vero.

È esattamente la lezione che l’esercizio doveva insegnare: **una singola
esecuzione non dimostra nulla**. Un valore del chi quadro sopra la soglia
del cinque per cento si verifica, per definizione, in un caso su venti
anche con un generatore perfetto. Provate a cambiare il seme e i due
valori si scambiano di posto.

Per una conclusione statisticamente sensata occorrerebbe ripetere il
test con molti semi diversi e osservare la **distribuzione** dei valori
del chi quadro, non un singolo campione.

La ragione per preferire `math.random(1, 6)` non è quindi empirica ma di
**principio**: usa aritmetica intera ed è esatto per costruzione, mentre
la versione con il float dipende dal fatto che `math.random()` non
restituisca mai esattamente uno. Se lo facesse, produrrebbe un sette,
e nessun test di uniformità lo rivelerebbe finché non capita.

**ES 19.6 — Formattare una durata**

*Scrivi una funzione che formatti una durata in secondi nella forma
leggibile «2 giorni, 3 ore, 15 minuti», omettendo le unità nulle e
gestendo correttamente il singolare e il plurale.*

```lua
local UNITA = {
  {nome = "giorno", plurale = "giorni",
   secondi = 86400},
  {nome = "ora", plurale = "ore", secondi = 3600},
  {nome = "minuto", plurale = "minuti", secondi = 60},
  {nome = "secondo", plurale = "secondi", secondi = 1},
}

local function formattaDurata(secondi, opzioni)
  opzioni = opzioni or {}
  if type(secondi) ~= "number" then
    return nil, "atteso un numero"
  end

  local negativa = secondi < 0
  secondi = math.floor(math.abs(secondi))

  if secondi == 0 then
    return "0 secondi"
  end

  local massimo = opzioni.massimoUnita or #UNITA
  local pezzi = {}
  local resto = secondi

  for _, u in ipairs(UNITA) do
    if #pezzi >= massimo then break end
    local quante = resto // u.secondi
    if quante > 0 then
      resto = resto % u.secondi
      pezzi[#pezzi + 1] = quante .. " "
        .. (quante == 1 and u.nome or u.plurale)
    end
  end

  local testo
  if #pezzi == 1 then
    testo = pezzi[1]
  else
    local ultimo = table.remove(pezzi)
    testo = table.concat(pezzi, ", ") .. " e " .. ultimo
  end

  if negativa then testo = testo .. " fa" end
  return testo
end

local casi = {0, 1, 2, 59, 60, 61, 90, 3600, 3601,
  3660, 86400, 90061, 172800, 200000, -3661}

for _, s in ipairs(casi) do
  print(string.format("%8d -> %s", s,
    formattaDurata(s)))
end

print()
print("con al massimo due unita':")
for _, s in ipairs({90061, 200000, 3661}) do
  print(string.format("%8d -> %s", s,
    formattaDurata(s, {massimoUnita = 2})))
end
```

produce:

```text
       0 -> 0 secondi
       1 -> 1 secondo
       2 -> 2 secondi
      59 -> 59 secondi
      60 -> 1 minuto
      61 -> 1 minuto e 1 secondo
      90 -> 1 minuto e 30 secondi
    3600 -> 1 ora
    3601 -> 1 ora e 1 secondo
    3660 -> 1 ora e 1 minuto
   86400 -> 1 giorno
   90061 -> 1 giorno, 1 ora, 1 minuto e 1 secondo
  172800 -> 2 giorni
  200000 -> 2 giorni, 7 ore, 33 minuti e 20 secondi
   -3661 -> 1 ora, 1 minuto e 1 secondo fa
```

Le unità nulle vengono **omesse**: mille ottocento secondi danno «30
minuti» e non «0 giorni, 0 ore, 30 minuti».

Il singolare e il plurale sono gestiti da una tabella con entrambe le
forme, perché in italiano non si ricavano l’una dall’altra in modo
regolare per tutte le parole.

La congiunzione «e» prima dell’ultimo elemento è la convenzione
italiana, e richiede di trattare separatamente il caso di un solo
elemento.

Il limite sul numero di unità è utile nell’interfaccia: «2 giorni e 7
ore» è più leggibile della forma completa quando la precisione al secondo
non serve.

**ES 19.7 — Allineamento in caratteri e non in byte**

*Scrivi una funzione che allinei in colonne una tabella di stringhe
potenzialmente accentate, calcolando la larghezza in caratteri e non
in byte. Confrontala con `string.format` e mostra il disallineamento
che quest’ultimo produce.*

```lua
local function larghezza(s)
  local n = utf8.len(s)
  if n == nil then return #s end
  return n
end

local function riempi(s, colonne, aSinistra)
  local mancanti = colonne - larghezza(s)
  if mancanti <= 0 then return s end
  local spazi = string.rep(" ", mancanti)
  if aSinistra then return spazi .. s end
  return s .. spazi
end

local A = utf8.char(0xE0)
local E = utf8.char(0xE9)
local EU = utf8.char(0x20AC)

local RIGHE = {
  {"citta", 100},
  {"citt" .. A, 200},
  {"perche", 300},
  {"perch" .. E, 400},
  {"euro " .. EU, 500},
  {"normale", 600},
}

print("=== con string.format (conta i byte) ===")
print(string.format("%-14s %8s", "NOME", "VALORE"))
for _, r in ipairs(RIGHE) do
  print(string.format("%-14s %8d", r[1], r[2]))
end

print()
print("=== con riempimento in caratteri ===")
print(riempi("NOME", 14) .. riempi("VALORE", 8, true))
for _, r in ipairs(RIGHE) do
  print(riempi(r[1], 14)
    .. riempi(tostring(r[2]), 8, true))
end

print()
print("=== larghezze a confronto ===")
for _, r in ipairs(RIGHE) do
  print(string.format("  %-16s byte=%d caratteri=%d",
    "[" .. r[1] .. "]", #r[1], larghezza(r[1])))
end
```

Nella prima tabella le righe che contengono caratteri accentati o il
simbolo dell’euro risultano **disallineate**: `string.format` con `%-14s`
riempie fino a quattordici **byte**, e una «à» ne occupa due, un simbolo
di euro tre.

Nella seconda tabella l’allineamento è corretto, perché il riempimento è
calcolato in caratteri con `utf8.len`.

La terza sezione mostra i numeri: `città` occupa sei byte e cinque
caratteri, `euro €` nove byte e sei caratteri.

Va segnalato un limite ulteriore: nemmeno il conteggio dei caratteri è
sufficiente per un allineamento perfetto in un terminale, perché alcuni
caratteri — gli ideogrammi, molte emoji — occupano **due colonne** pur
essendo un carattere solo. Un allineamento veramente corretto richiede
una tabella delle larghezze di visualizzazione, che Lua non fornisce.

**ES 19.8 — Validare UTF-8**

*Scrivi una funzione che verifichi se una stringa è UTF-8 valida e,
in caso negativo, restituisca la posizione e una descrizione del
primo errore. Testala su stringhe con byte troncati, sequenze
sovralunghe e byte di continuazione isolati.*

```lua
local function analizzaUtf8(s)
  if type(s) ~= "string" then
    return nil, "atteso una stringa"
  end

  local n, posizione = utf8.len(s)
  if n ~= nil then
    return true, n
  end

  local b = s:byte(posizione)
  local descrizione

  if b >= 0x80 and b <= 0xBF then
    descrizione = "byte di continuazione isolato"
  elseif b >= 0xC0 and b <= 0xC1 then
    descrizione = "sequenza sovralunga (C0 o C1)"
  elseif b >= 0xF5 then
    descrizione = "byte oltre l'intervallo valido"
  elseif b >= 0xC2 and b <= 0xDF then
    descrizione = "sequenza a 2 byte troncata o "
      .. "malformata"
  elseif b >= 0xE0 and b <= 0xEF then
    descrizione = "sequenza a 3 byte troncata o "
      .. "malformata"
  elseif b >= 0xF0 and b <= 0xF4 then
    descrizione = "sequenza a 4 byte troncata o "
      .. "malformata"
  else
    descrizione = "byte inatteso"
  end

  return false, posizione, string.format(
    "byte 0x%02X alla posizione %d: %s",
    b, posizione, descrizione)
end

local casi = {
  {"testo ASCII", "abc"},
  {"UTF-8 valido", "citt" .. utf8.char(0xE0)},
  {"stringa vuota", ""},
  {"continuazione isolata", "abc\x80def"},
  {"sequenza troncata", "abc\xC3"},
  {"tre byte troncata", "abc\xE2\x82"},
  {"sovralunga C0", "abc\xC0\x80"},
  {"oltre F4", "abc\xF8\x88\x80\x80"},
  {"quattro byte valida", utf8.char(0x1F600)},
}

for _, c in ipairs(casi) do
  local ok, a, b = analizzaUtf8(c[2])
  if ok then
    print(string.format("%-24s VALIDA, %d caratteri",
      c[1], a))
  else
    print(string.format("%-24s NON VALIDA: %s",
      c[1], b))
  end
end
```

produce:

```text
testo ASCII              VALIDA, 3 caratteri
UTF-8 valido             VALIDA, 5 caratteri
stringa vuota            VALIDA, 0 caratteri
continuazione isolata    NON VALIDA: byte 0x80 alla
                         posizione 4: byte di
                         continuazione isolato
sequenza troncata        NON VALIDA: byte 0xC3 alla
                         posizione 4: sequenza a 2 byte
                         troncata o malformata
tre byte troncata        NON VALIDA: byte 0xE2 alla
                         posizione 4: sequenza a 3 byte
                         troncata o malformata
sovralunga C0            NON VALIDA: byte 0xC0 alla
                         posizione 4: sequenza
                         sovralunga (C0 o C1)
oltre F4                 NON VALIDA: byte 0xF8 alla
                         posizione 4: byte oltre
                         l'intervallo valido
quattro byte valida      VALIDA, 1 caratteri
```

`utf8.len` fa già il lavoro di validazione: restituisce `nil` più la
posizione del primo byte problematico. Il valore aggiunto della funzione
è la **diagnosi**, ottenuta classificando il byte in base al suo valore.

Le tre categorie che il codice riconosce sono quelle reali della
codifica: i byte da `0x80` a `0xBF` sono continuazioni e non possono
iniziare una sequenza; `0xC0` e `0xC1` produrrebbero sequenze
sovralunghe, cioè codifiche non canoniche di caratteri rappresentabili
con meno byte, che sono state vietate perché costituivano un vettore di
attacco; i byte da `0xF5` in su codificherebbero punti di codice oltre il
massimo Unicode.

Un messaggio d’errore che dice **quale** byte, **dove** e **perché** è
la differenza fra una diagnosi e una constatazione.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
