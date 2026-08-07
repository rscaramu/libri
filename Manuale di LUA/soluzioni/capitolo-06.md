# Capitolo 6 — Valori booleani, condizioni e controllo di flusso

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 5](capitolo-05.md) · [Indice](README.md) · [Capitolo 7 →](capitolo-07.md)

I 6 sorgenti eseguibili di questo capitolo sono in
[`codice/cap06/`](../codice/cap06/).

---

**ES 6.4 — Il mediano di tre numeri**

*Scrivi una funzione che, dati tre numeri, restituisca il mediano,
usando solo confronti e il costrutto `if`. Testala su tutte le
possibili disposizioni di tre valori distinti e sui casi con valori
uguali.*

```lua
local function mediano(a, b, c)
  if a > b then a, b = b, a end
  if b > c then b, c = c, b end
  if a > b then a, b = b, a end
  return b
end

local disposizioni = {
  {1, 2, 3}, {1, 3, 2}, {2, 1, 3},
  {2, 3, 1}, {3, 1, 2}, {3, 2, 1},
}

for _, d in ipairs(disposizioni) do
  local m = mediano(d[1], d[2], d[3])
  print(string.format("(%d,%d,%d) -> %d %s",
    d[1], d[2], d[3], m,
    m == 2 and "ok" or "ERRORE"))
end

local uguali = {
  {5, 5, 5, 5}, {5, 5, 9, 5}, {1, 5, 5, 5},
  {5, 1, 5, 5}, {-3, 0, 3, 0},
}

for _, u in ipairs(uguali) do
  local m = mediano(u[1], u[2], u[3])
  print(string.format("(%d,%d,%d) -> %d atteso %d %s",
    u[1], u[2], u[3], m, u[4],
    m == u[4] and "ok" or "ERRORE"))
end
```

La soluzione è una **rete di ordinamento** a tre confronti: dopo i tre
scambi condizionali, `a`, `b` e `c` sono ordinati e `b` è il mediano.

L’alternativa con condizioni annidate richiede più rami ed è più facile
da sbagliare:

```lua
local function medianoAlternativo(a, b, c)
  if (a <= b and b <= c) or (c <= b and b <= a) then
    return b
  elseif (b <= a and a <= c) or (c <= a and a <= b) then
    return a
  end
  return c
end
```

I casi con valori uguali funzionano in entrambe perché i confronti usano
`<=` e non `<`: con la disuguaglianza stretta, tre valori uguali non
soddisferebbero alcuna condizione nella seconda versione.

**ES 6.5 — Cinque condizioni diverse in Python**

*Scrivi cinque condizioni Lua che darebbero un risultato diverso in
Python. Per ciascuna scrivi il valore in Lua, il valore che avrebbe
in Python, e spiega la differenza in una riga.*

```lua
local casi = {
  {"0", 0},
  {"stringa vuota", ""},
  {"tabella vuota", {}},
  {"stringa '0'", "0"},
  {"0.0", 0.0},
}

for _, c in ipairs(casi) do
  local vero = c[2] and "vero" or "falso"
  print(string.format("%-16s in Lua: %s", c[1], vero))
end
```

Le cinque differenze, con il valore in Lua e quello in Python:

**Lo zero.** In Lua è **vero**, in Python è falso. È la differenza più
costosa: `if contatore then` in Lua non distingue mai zero da un valore
positivo.

**La stringa vuota.** In Lua è **vera**, in Python falsa. `if nome then`
non verifica che il nome sia stato inserito: verifica solo che la
variabile esista.

**La tabella vuota.** In Lua è **vera**, e la lista vuota in Python è
falsa. `if elementi then` è sempre vero; serve `if #elementi > 0 then`.

**La stringa `"0"`.** In Lua è vera, in Python anche: qui non c’è
differenza. È inclusa perché in PHP e in Perl è **falsa**, ed è una delle
trappole più famose di PHP.

**Il float zero.** In Lua è **vero**, in Python falso, esattamente come
l’intero zero.

La regola da ricordare: in Lua le uniche cose false sono `nil` e
`false`. Ogni verifica su un contenuto va scritta esplicitamente.

**ES 6.6 — Configurazione con tabella di opzioni**

*Riscrivi la funzione `configura` dell’esercizio ES 6.2 in modo che
accetti un unico argomento, una tabella di opzioni, e applichi i
valori predefiniti per tutti i campi mancanti, distinguendo
correttamente il campo assente dal campo impostato a `false`.*

```lua
local PREDEFINITI = {
  nome = "senza nome",
  dimensione = 10,
  visibile = true,
  colore = "nero",
  bordo = false,
}

local function configura(opzioni)
  opzioni = opzioni or {}

  for chiave in pairs(opzioni) do
    if PREDEFINITI[chiave] == nil then
      return nil, "opzione sconosciuta: "
        .. tostring(chiave)
    end
  end

  local finale = {}
  for chiave, predefinito in pairs(PREDEFINITI) do
    local fornito = opzioni[chiave]
    -- Il confronto con nil e' l'unico modo di
    -- distinguere "assente" da "impostato a false"
    if fornito == nil then
      finale[chiave] = predefinito
    else
      finale[chiave] = fornito
    end
  end

  return finale
end

local function mostra(etichetta, c)
  if c == nil then
    print(etichetta .. ": " .. "errore")
    return
  end
  local chiavi = {}
  for k in pairs(c) do chiavi[#chiavi + 1] = k end
  table.sort(chiavi)
  local pezzi = {}
  for _, k in ipairs(chiavi) do
    pezzi[#pezzi + 1] = k .. "=" .. tostring(c[k])
  end
  print(etichetta .. ": " .. table.concat(pezzi, " "))
end

mostra("vuota   ", configura())
mostra("parziale", configura({nome = "box"}))
mostra("false   ", configura({visibile = false,
  bordo = true}))
mostra("tutti   ", configura({
  nome = "x", dimensione = 1, visibile = false,
  colore = "rosso", bordo = true}))

local r, e = configura({dimensioe = 5})
print("errore di battitura: " .. tostring(e))
```

produce:

```text
vuota   : bordo=false colore=nero dimensione=10
          nome=senza nome visibile=true
parziale: bordo=false colore=nero dimensione=10
          nome=box visibile=true
false   : bordo=true colore=nero dimensione=10
          nome=senza nome visibile=false
tutti   : bordo=true colore=rosso dimensione=1
          nome=x visibile=false
errore di battitura: opzione sconosciuta: dimensioe
```

La terza riga è quella che conta: `visibile = false` viene **rispettato**
invece di essere sostituito dal predefinito `true`. Con l’idioma
`opzioni[k] or PREDEFINITI[k]` sarebbe stato ignorato.

Il rifiuto delle opzioni sconosciute intercetta gli errori di battitura,
che altrimenti verrebbero silenziosamente ignorati.

**ES 6.7 — Albero decisionale, due versioni**

*Scrivi un programma che simuli un semplice albero decisionale: fa
all’utente tre domande a risposta sì o no e, in base alle risposte,
stampa uno di otto esiti possibili. Implementalo prima con `if`
annidati e poi con una tabella indicizzata da una stringa costruita
dalle tre risposte, e confronta le due versioni.*

```lua
local RISPOSTE = {"si", "no"}

local ESITI = {
  ["si-si-si"]  = "profilo A: esperto entusiasta",
  ["si-si-no"]  = "profilo B: esperto prudente",
  ["si-no-si"]  = "profilo C: pratico curioso",
  ["si-no-no"]  = "profilo D: pratico conservatore",
  ["no-si-si"]  = "profilo E: novizio motivato",
  ["no-si-no"]  = "profilo F: novizio cauto",
  ["no-no-si"]  = "profilo G: osservatore",
  ["no-no-no"]  = "profilo H: non interessato",
}

local function conIf(a, b, c)
  if a == "si" then
    if b == "si" then
      if c == "si" then return "profilo A: esperto "
        .. "entusiasta" end
      return "profilo B: esperto prudente"
    end
    if c == "si" then return "profilo C: pratico "
      .. "curioso" end
    return "profilo D: pratico conservatore"
  end
  if b == "si" then
    if c == "si" then return "profilo E: novizio "
      .. "motivato" end
    return "profilo F: novizio cauto"
  end
  if c == "si" then return "profilo G: osservatore" end
  return "profilo H: non interessato"
end

local function conTabella(a, b, c)
  return ESITI[a .. "-" .. b .. "-" .. c]
    or "risposte non valide"
end

for _, a in ipairs(RISPOSTE) do
  for _, b in ipairs(RISPOSTE) do
    for _, c in ipairs(RISPOSTE) do
      local x = conIf(a, b, c)
      local y = conTabella(a, b, c)
      print(string.format("%s %s %s -> %-32s %s",
        a, b, c, y, x == y and "ok" or "DIVERSI"))
    end
  end
end

print(conTabella("forse", "si", "no"))
```

Il confronto fra le due versioni.

La versione con `if` annidati ha **otto percorsi distinti** e tre livelli
di profondità. Aggiungere una quarta domanda raddoppia i rami e aggiunge
un livello: diventa rapidamente illeggibile.

La versione a tabella ha **una riga di codice** e una tabella di dati.
Aggiungere una domanda significa aggiungere otto righe alla tabella,
senza toccare la logica. E la tabella si può leggere da un file, generare
da un foglio di calcolo, modificare senza ricompilare.

Il vantaggio ulteriore è che la versione a tabella gestisce
naturalmente le risposte non valide, restituendo il valore di riserva,
mentre quella con `if` le tratta come «no» silenziosamente: `"forse"` non
è `"si"`, quindi cade nel ramo negativo senza segnalazione.

**ES 6.8 — Quando `cond and a or b` fallisce**

*L’idioma `cond and a or b` fallisce quando `a` è falso o `nil`.
Costruisci tre esempi concreti in cui il fallimento produce un bug
realistico, e per ciascuno scrivi la versione corretta con un `if`
completo.*

```lua
-- Caso 1: il valore vero e' false
local function haPermesso(utente)
  -- SBAGLIATO: restituisce sempre true
  return utente.attivo and utente.permessoScrittura
    or true
end

local function haPermessoCorretto(utente)
  if utente.attivo then
    return utente.permessoScrittura
  end
  return true
end

local u = {attivo = true, permessoScrittura = false}
print("1 sbagliato:", haPermesso(u))
print("1 corretto: ", haPermessoCorretto(u))

-- Caso 2: il valore memorizzato e' false
local CONFIGURAZIONE = {
  timeout = 30,
  verbose = false,
}

local function leggi(chiave)
  -- SBAGLIATO: il valore false viene scartato
  return CONFIGURAZIONE[chiave] ~= nil
    and CONFIGURAZIONE[chiave] or "NON IMPOSTATO"
end

local function leggiCorretto(chiave)
  local v = CONFIGURAZIONE[chiave]
  if v == nil then return "NON IMPOSTATO" end
  return v
end

for _, k in ipairs({"timeout", "verbose", "proxy"}) do
  print(string.format("2 %-8s sbagliato=%-14s "
    .. "corretto=%s", k,
    tostring(leggi(k)), tostring(leggiCorretto(k))))
end

-- Caso 3: il valore vero e' il risultato di un
-- confronto che puo' essere false
local function segno(n)
  -- SBAGLIATO su n == 0
  return n ~= 0 and (n > 0) or "zero"
end

local function segnoCorretto(n)
  if n == 0 then return "zero" end
  return n > 0
end

for _, n in ipairs({5, -5, 0}) do
  print(string.format("3 n=%2d sbagliato=%-6s "
    .. "corretto=%s", n,
    tostring(segno(n)), tostring(segnoCorretto(n))))
end
```

I tre casi hanno la stessa causa: **il valore del ramo vero è a sua volta
falso**, quindi `and` lo restituisce, `or` lo scarta e prende il ramo
falso.

Il primo è il più realistico: una funzione di autorizzazione che
restituisce sempre `true` è un bug di sicurezza, e nessun test che
verifichi solo il caso permesso lo scoprirebbe.

Il secondo mostra che il difetto non riguarda solo `nil`: la chiave
`verbose` esiste e vale `false`, e la formula la riporta come «non
impostata», confondendo un’opzione disattivata con un’opzione assente.

Il terzo mostra che il problema si presenta anche quando il valore
proviene da un confronto: `n > 0` con `n` uguale a meno cinque vale
`false`, e la formula restituisce `"zero"` per un numero negativo.

La regola operativa: usate `cond and a or b` **solo** quando siete certi
che `a` non possa mai essere `false` né `nil`. In pratica: quando `a` è
un letterale non falso, una stringa non vuota o un numero. In tutti gli
altri casi, scrivete l’`if`.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
