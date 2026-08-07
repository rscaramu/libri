# Capitolo 8 — Le funzioni: definirle, chiamarle, restituire valori

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 7](capitolo-07.md) · [Indice](README.md) · [Capitolo 9 →](capitolo-09.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap08/`](../codice/cap08/).

---

**ES 8.4 — Concatenare stringhe con separatore**

*Scrivi una funzione che accetti un numero variabile di stringhe e le
concateni con un separatore, dove il separatore è il primo
argomento. Gestisci il caso di zero stringhe e quello in cui
qualcuna sia `nil`.*

```lua
local function unisci(separatore, ...)
  if type(separatore) ~= "string" then
    return nil, "il separatore deve essere una stringa"
  end

  local argomenti = table.pack(...)
  local pezzi = {}

  for i = 1, argomenti.n do
    local v = argomenti[i]
    if v == nil then
      pezzi[#pezzi + 1] = ""
    elseif type(v) == "string" or type(v) == "number" then
      pezzi[#pezzi + 1] = tostring(v)
    else
      return nil, string.format(
        "argomento %d di tipo %s non ammesso",
        i, type(v))
    end
  end

  return table.concat(pezzi, separatore)
end

print("[" .. unisci(", ", "a", "b", "c") .. "]")
print("[" .. unisci(", ") .. "]")
print("[" .. unisci("-", "solo") .. "]")
print("[" .. unisci("|", "a", nil, "c") .. "]")
print("[" .. unisci("", 1, 2, 3) .. "]")
print(unisci(",", "a", {}, "c"))
print(unisci(42, "a"))
```

produce:

```text
[a, b, c]
[]
[solo]
[a||c]
[123]
nil	argomento 2 di tipo table non ammesso
nil	il separatore deve essere una stringa
```

`table.pack` è obbligatorio e non `{...}`: con un `nil` in mezzo, la
tabella avrebbe un buco e `#` restituirebbe un valore indefinito. Il
campo `n` conta gli argomenti effettivamente passati, ed è l’unico modo
di sapere che il quarto esempio ne ha tre e non due.

La scelta di convertire `nil` in stringa vuota è una decisione: si
sarebbe potuto saltarlo, o rifiutarlo. Va dichiarata, perché il risultato
`"a||c"` non è ovvio.

**ES 8.5 — Composizione di funzioni**

*Scrivi una funzione `componi` che, date due funzioni, restituisca la
funzione che le applica in sequenza. Estendila poi in modo che
accetti un numero qualunque di funzioni. Verifica che l’ordine di
applicazione sia quello che hai documentato.*

```lua
local function componiDue(f, g)
  return function(...)
    return f(g(...))
  end
end

local function componi(...)
  local funzioni = table.pack(...)
  if funzioni.n == 0 then
    return function(...) return ... end
  end
  for i = 1, funzioni.n do
    if type(funzioni[i]) ~= "function" then
      return nil, "argomento " .. i .. " non e' "
        .. "una funzione"
    end
  end

  return function(...)
    local risultati = table.pack(...)
    -- Applicazione da DESTRA a SINISTRA:
    -- componi(f, g, h)(x) == f(g(h(x)))
    for i = funzioni.n, 1, -1 do
      risultati = table.pack(
        funzioni[i](table.unpack(risultati, 1,
          risultati.n)))
    end
    return table.unpack(risultati, 1, risultati.n)
  end
end

local raddoppia = function(x) return x * 2 end
local incrementa = function(x) return x + 1 end
local quadrato = function(x) return x * x end

local a = componiDue(raddoppia, incrementa)
print("componiDue(raddoppia, incrementa)(3) = " .. a(3))

local b = componi(raddoppia, incrementa, quadrato)
print("componi(raddoppia, incrementa, quadrato)(3) = "
  .. b(3))

local identita = componi()
print("componi()(7) = " .. identita(7))

print(componi(raddoppia, "non una funzione"))
```

produce:

```text
componiDue(raddoppia, incrementa)(3) = 8
componi(raddoppia, incrementa, quadrato)(3) = 20
componi()(7) = 7
nil	argomento 2 non e' una funzione
```

L’ordine di applicazione è **da destra a sinistra**, coerente con la
notazione matematica: `componi(f, g)` significa `f` dopo `g`. Con tre
funzioni e argomento tre: si eleva al quadrato ottenendo nove, si
incrementa ottenendo dieci, si raddoppia ottenendo venti.

L’ordine opposto sarebbe altrettanto legittimo — molte librerie lo
chiamano `pipe` — ma va **documentato**, perché sbagliarlo produce
risultati plausibili e sbagliati: con l’altro ordine il risultato sarebbe
quarantanove.

L’uso di `table.pack` e `table.unpack` a ogni passo conserva i valori
multipli lungo tutta la catena, compresi i `nil` intermedi.

Il caso di zero funzioni restituisce l’**identità**, che è la scelta
matematicamente coerente.

**ES 8.6 — Massimo comun divisore in tre forme**

*Scrivi una funzione che calcoli il massimo comun divisore di due
numeri in tre modi: con un ciclo, con la ricorsione ordinaria e con
la ricorsione in coda. Verifica quale delle tre regge il maggior
numero di iterazioni prima di esaurire lo stack.*

```lua
local function mcdCiclo(a, b)
  a, b = math.abs(a), math.abs(b)
  while b ~= 0 do
    a, b = b, a % b
  end
  return a
end

local function mcdRicorsivo(a, b)
  a, b = math.abs(a), math.abs(b)
  if b == 0 then return a end
  -- NON in coda: c'e' una moltiplicazione per 1
  -- che impedisce l'ottimizzazione
  return 1 * mcdRicorsivo(b, a % b)
end

local function mcdCoda(a, b)
  a, b = math.abs(a), math.abs(b)
  if b == 0 then return a end
  return mcdCoda(b, a % b)
end

local prove = {
  {48, 18, 6}, {17, 5, 1}, {0, 5, 5},
  {5, 0, 5}, {-48, 18, 6}, {100, 100, 100},
}

for _, p in ipairs(prove) do
  local r1 = mcdCiclo(p[1], p[2])
  local r2 = mcdRicorsivo(p[1], p[2])
  local r3 = mcdCoda(p[1], p[2])
  print(string.format("mcd(%4d,%4d) = %d %d %d  %s",
    p[1], p[2], r1, r2, r3,
    (r1 == p[3] and r2 == p[3] and r3 == p[3])
      and "ok" or "ERRORE"))
end

-- Profondita' massima
local function profonditaMassima(f)
  local n = 0
  local function prova(k)
    local ok = pcall(f, k)
    return ok
  end
  -- L'algoritmo di Euclide converge in fretta:
  -- per forzare la profondita' usiamo una ricorsione
  -- artificiale.
  local function ricorsivaNonCoda(k)
    if k == 0 then return 0 end
    return 1 + ricorsivaNonCoda(k - 1)
  end
  local function ricorsivaCoda(k, acc)
    acc = acc or 0
    if k == 0 then return acc end
    return ricorsivaCoda(k - 1, acc + 1)
  end

  local limite = 1
  while pcall(ricorsivaNonCoda, limite) do
    limite = limite * 2
    if limite > 100000000 then break end
  end
  print("ricorsione ordinaria: fallisce oltre circa "
    .. limite // 2)

  local ok = pcall(ricorsivaCoda, 10000000)
  print("ricorsione in coda a 10 milioni: "
    .. tostring(ok))
  return n
end

profonditaMassima()
```

L’algoritmo di Euclide converge così rapidamente — la profondità cresce
in modo logaritmico — che nessuna delle tre versioni esaurisce mai lo
stack su valori reali: anche con numeri vicini al massimo intero, le
iterazioni sono qualche decina.

Per rendere visibile la differenza serve una ricorsione artificiale, ed è
ciò che fa la parte finale: la versione ordinaria fallisce dopo alcune
centinaia di migliaia di livelli, quella in coda arriva a dieci milioni
senza problemi.

La versione `mcdRicorsivo` contiene deliberatamente una moltiplicazione
per uno dopo la chiamata: è inutile ma **impedisce l’ottimizzazione della
chiamata in coda**, e serve a dimostrare che basta un’operazione residua
per perdere la garanzia.

**ES 8.7 — Rifiutare le opzioni sconosciute**

*Riscrivi la funzione `creaFinestra` del paragrafo 8.6 in modo che
segnali un errore se la tabella di opzioni contiene una chiave non
riconosciuta. Spiega perché questo controllo è utile e in quale
situazione potrebbe essere invece dannoso.*

```lua
local PREDEFINITI = {
  titolo = "Senza titolo",
  larghezza = 640,
  altezza = 480,
  visibile = true,
  ridimensionabile = false,
}

local function creaFinestra(opzioni)
  opzioni = opzioni or {}

  local ignote = {}
  for chiave in pairs(opzioni) do
    if PREDEFINITI[chiave] == nil then
      ignote[#ignote + 1] = tostring(chiave)
    end
  end

  if #ignote > 0 then
    table.sort(ignote)
    return nil, "opzioni sconosciute: "
      .. table.concat(ignote, ", ")
  end

  local c = {}
  for chiave, predefinito in pairs(PREDEFINITI) do
    if opzioni[chiave] == nil then
      c[chiave] = predefinito
    else
      c[chiave] = opzioni[chiave]
    end
  end

  return string.format("%s: %dx%d visibile=%s "
    .. "ridim=%s", c.titolo, c.larghezza, c.altezza,
    tostring(c.visibile), tostring(c.ridimensionabile))
end

print(creaFinestra())
print(creaFinestra({titolo = "Editor", altezza = 900}))
print(creaFinestra({visibile = false}))
print(creaFinestra({larghezz = 800}))
print(creaFinestra({titolo = "x", colore = "rosso",
  bordo = 1}))
```

Il controllo è utile perché un errore di battitura in un nome di opzione
non produrrebbe altrimenti alcun segnale: la finestra userebbe la
larghezza predefinita e chi ha scritto `larghezz` passerebbe tempo a
cercare il problema altrove.

Ci sono però due situazioni in cui il controllo è **dannoso**.

**Le opzioni sperimentali o specifiche di una versione.** Se un
programma deve funzionare con più versioni di una libreria, passare
un’opzione che la versione più vecchia non conosce diventa un errore
fatale invece di essere ignorato.

**Le opzioni destinate a un altro strato.** Se la tabella di opzioni
viene passata attraverso più livelli, ciascuno dei quali ne consuma
alcune, il controllo va fatto solo al livello che le conosce tutte.

La soluzione intermedia, adottata da molte librerie, è **segnalare senza
fallire**: scrivere un avviso su `io.stderr` e proseguire.

**ES 8.8 — Le quattro regole dei valori multipli**

*Scrivi una funzione che restituisca cinque valori e dimostra, con
almeno quattro chiamate diverse, tutte le regole di aggiustamento
dei valori multipli viste nel paragrafo 8.4: posizione finale,
posizione intermedia, parentesi, e uso dentro un costruttore di
tabella.*

```lua
local function cinque()
  return 1, 2, 3, 4, 5
end

print("--- 1. Ultima posizione: tutti i valori ---")
print(cinque())
local a, b, c, d, e, f = cinque()
print(a, b, c, d, e, f)

print("--- 2. Posizione intermedia: uno solo ---")
print(cinque(), "coda")
print("prima", cinque(), "dopo")
local g, h = cinque(), 99
print(g, h)

print("--- 3. Parentesi: uno solo ---")
print((cinque()))
local i, j = (cinque())
print(i, j)

print("--- 4. Costruttore di tabella ---")
local t1 = {cinque()}
print("in coda:      " .. #t1)
local t2 = {cinque(), cinque()}
print("non in coda:  " .. #t2)
local t3 = {0, cinque()}
print("dopo un altro:" .. #t3)
local t4 = {[1] = cinque()}
print("chiave espl.: " .. #t4)

print("--- 5. Come argomento di un'altra funzione ---")
print(select("#", cinque()))
print(select("#", cinque(), 0))
print(math.max(cinque()))
```

produce:

```text
--- 1. Ultima posizione: tutti i valori ---
1	2	3	4	5
1	2	3	4	5	nil
--- 2. Posizione intermedia: uno solo ---
1	coda
prima	1	dopo
1	99
--- 3. Parentesi: uno solo ---
1
1	nil
--- 4. Costruttore di tabella ---
in coda:      5
non in coda:  6
dopo un altro:6
chiave espl.: 1
--- 5. Come argomento di un'altra funzione ---
5
2
5
```

La regola è meccanica e non ammette eccezioni: una chiamata multivalore
si espande **soltanto** se è l’ultima espressione della lista. In
`print("prima", cinque(), "dopo")` non lo è, perché `"dopo"` la segue, e
infatti il risultato mostra un solo valore. In `print(cinque())` lo è, e
si espande. Non conta quanti elementi ci siano prima: conta solo che cosa
venga dopo.

Il gruppo quattro è il più utile nella pratica: `{cinque()}` produce una
tabella di cinque elementi, `{cinque(), cinque()}` ne produce sei, perché
la prima chiamata è troncata a uno e la seconda espansa.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
