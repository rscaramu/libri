# Capitolo 9 — Ambito, closure e ricorsione

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 8](capitolo-08.md) · [Indice](README.md) · [Capitolo 10 →](capitolo-10.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap09/`](../codice/cap09/).

---

**ES 9.4 — Lista privata con copia**

*Scrivi una funzione che restituisca due closure, una che aggiunge un
elemento a una lista privata e una che restituisce una copia della
lista. Verifica che chi riceve la copia non possa modificare
l’originale.*

```lua
local function creaLista()
  local elementi = {}

  local function aggiungi(v)
    if v == nil then
      return nil, "non si puo' aggiungere nil"
    end
    elementi[#elementi + 1] = v
    return #elementi
  end

  local function copia()
    local c = {}
    table.move(elementi, 1, #elementi, 1, c)
    return c
  end

  local function quanti()
    return #elementi
  end

  return aggiungi, copia, quanti
end

local aggiungi, copia, quanti = creaLista()

aggiungi("a")
aggiungi("b")
aggiungi("c")

local istantanea = copia()
print("copia: " .. table.concat(istantanea, " "))

-- Modifichiamo la copia
istantanea[1] = "MODIFICATO"
istantanea[#istantanea + 1] = "AGGIUNTO"

print("copia modificata: "
  .. table.concat(istantanea, " "))
print("originale:        "
  .. table.concat(copia(), " "))
print("elementi: " .. quanti())

-- Non c'e' alcun modo di raggiungere `elementi`
print(aggiungi("d"))
print("dopo: " .. table.concat(copia(), " "))
```

produce:

```text
copia: a b c
copia modificata: MODIFICATO b c AGGIUNTO
originale:        a b c
elementi: 3
4
dopo: a b c d
```

La copia è **superficiale**, il che qui basta perché gli elementi sono
stringhe. Se contenessero tabelle, modificarle attraverso la copia
toccherebbe anche gli originali: servirebbe la copia profonda del
Capitolo 10.

La variabile `elementi` non è raggiungibile in alcun modo dall’esterno:
non è un campo di una tabella restituita, è un upvalue condiviso dalle
tre funzioni. È incapsulamento reale, con l’unica eccezione della
libreria `debug`, come mostrato nel paragrafo 24.5.

**ES 9.5 — Variabile dentro e fuori dal ciclo**

*Dimostra con un programma la differenza fra una variabile dichiarata
dentro il corpo di un ciclo e una dichiarata fuori, quando entrambe
vengono catturate da closure memorizzate in una tabella. Spiega nel
commento perché i risultati differiscono.*

```lua
local dentro = {}
for i = 1, 3 do
  local valore = i * 10
  dentro[i] = function() return valore end
end

local fuori = {}
local valoreEsterno
for i = 1, 3 do
  valoreEsterno = i * 10
  fuori[i] = function() return valoreEsterno end
end

print("dentro il ciclo: " .. dentro[1]() .. " "
  .. dentro[2]() .. " " .. dentro[3]())
print("fuori dal ciclo: " .. fuori[1]() .. " "
  .. fuori[2]() .. " " .. fuori[3]())
```

produce:

```text
dentro il ciclo: 10 20 30
fuori dal ciclo: 30 30 30
```

Il motivo è nel numero di **variabili** create.

Nel primo caso, `local valore` è dichiarata **dentro** il corpo del
ciclo: a ogni iterazione ne nasce una nuova, distinta dalle precedenti.
Le tre closure catturano quindi tre variabili diverse, ciascuna con il
proprio valore.

Nel secondo caso, `valoreEsterno` è dichiarata **prima** del ciclo:
esiste una sola variabile, che viene riassegnata a ogni giro. Le tre
closure catturano tutte la stessa, e ne leggono il valore finale.

Non è un difetto del linguaggio: è la conseguenza diretta della regola
del Capitolo 9 secondo cui l’ambito di una locale è il blocco in cui è
dichiarata. Il corpo del ciclo è un blocco nuovo a ogni iterazione.

**ES 9.6 — Fibonacci come iteratore**

*Scrivi una funzione che generi la successione di Fibonacci come
iteratore utilizzabile con il `for` generico, senza memorizzare
tutta la successione. Falla terminare quando il valore supera un
limite dato alla creazione.*

```lua
local function fibonacci(limite)
  local a, b = 0, 1
  return function()
    if limite and a > limite then
      return nil
    end
    local corrente = a
    a, b = b, a + b
    return corrente
  end
end

io.write("fino a 100: ")
for v in fibonacci(100) do
  io.write(v, " ")
end
io.write("\n")

io.write("primi 10 senza limite: ")
local quanti = 0
for v in fibonacci() do
  io.write(v, " ")
  quanti = quanti + 1
  if quanti >= 10 then break end
end
io.write("\n")

local somma = 0
for v in fibonacci(4000000) do
  if v % 2 == 0 then somma = somma + v end
end
print("somma dei pari fino a 4 milioni: " .. somma)
```

produce:

```text
fino a 100: 0 1 1 2 3 5 8 13 21 34 55 89
primi 10 senza limite: 0 1 1 2 3 5 8 13 21 34
somma dei pari fino a 4 milioni: 4613732
```

L’iteratore non memorizza la successione: conserva soltanto due numeri
negli upvalue. La memoria occupata è costante indipendentemente da quanti
termini si producono.

Senza limite l’iteratore è **infinito**, e il `break` lo interrompe senza
problemi: la closure resta sospesa e viene raccolta dal garbage
collector.

Il terzo esempio mostra il vantaggio della forma a iteratore rispetto a
una funzione che restituisce una lista: si può filtrare e sommare al volo
senza costruire nulla.

**ES 9.7 — Profondità massima di ricorsione**

*Misura la profondità massima di ricorsione raggiungibile sulla tua
installazione, con una funzione ricorsiva ordinaria e con una in
coda. Scrivi il programma in modo che l’errore di stack venga
intercettato e non interrompa l’esecuzione: dovrai usare `pcall`,
che troverai nel Capitolo 21.*

```lua
local function ordinaria(n)
  if n == 0 then return 0 end
  return 1 + ordinaria(n - 1)
end

local function inCoda(n, acc)
  acc = acc or 0
  if n == 0 then return acc end
  return inCoda(n - 1, acc + 1)
end

local function trovaLimite(f, tetto)
  local basso, alto = 1, tetto
  -- Cerchiamo il primo valore che fallisce,
  -- raddoppiando
  while alto <= tetto and pcall(f, alto) do
    basso = alto
    alto = alto * 2
  end

  -- Poi affiniamo per bisezione
  while alto - basso > 1 do
    local medio = (basso + alto) // 2
    if pcall(f, medio) then
      basso = medio
    else
      alto = medio
    end
  end
  return basso
end

local limite = trovaLimite(ordinaria, 100000000)
print("ricorsione ordinaria: circa " .. limite
  .. " livelli")

local prove = {1000000, 10000000, 50000000}
for _, n in ipairs(prove) do
  local ok, r = pcall(inCoda, n)
  print(string.format("ricorsione in coda a %10d: %s",
    n, ok and ("ok, risultato " .. r) or "fallita"))
end

local ok, messaggio = pcall(ordinaria, 10000000)
print("messaggio d'errore: " .. tostring(messaggio))
```

Sulla macchina di prova la ricorsione ordinaria fallisce attorno alle
cinquecentomila chiamate, con il messaggio *stack overflow*, mentre la
ricorsione in coda arriva a dieci milioni senza problemi, perché ogni chiamata
**sostituisce** la precedente invece di impilarsi.

Il `pcall` è indispensabile: senza, il primo tentativo fallito
terminerebbe il programma. La ricerca per raddoppio seguita da bisezione
trova il limite in poche decine di tentativi invece che provando un
valore alla volta.

Il valore esatto dipende dalla configurazione dell’interprete e dalla
dimensione dei frame: non è una costante del linguaggio, e per questo va
misurato invece che assunto.

**ES 9.8 — Memoizzazione a due argomenti**

*Riscrivi la funzione `memoizza` generica in modo che funzioni con
funzioni a due argomenti. Confronta due strategie: una chiave
composta ottenuta concatenando gli argomenti, e una struttura di
tabelle annidate. Discuti pregi e difetti di ciascuna, incluso che
cosa succede se gli argomenti non sono stringhe o numeri.*

```lua
local function memoizzaConcatenazione(f)
  local cache = {}
  local calcoli = 0
  local funzione = function(a, b)
    local chiave = tostring(a) .. "\0" .. tostring(b)
    local v = cache[chiave]
    if v == nil then
      calcoli = calcoli + 1
      v = f(a, b)
      cache[chiave] = v
    end
    return v
  end
  return funzione, function() return calcoli end
end

local function memoizzaAnnidata(f)
  local cache = {}
  local calcoli = 0
  local funzione = function(a, b)
    local livello = cache[a]
    if livello == nil then
      livello = {}
      cache[a] = livello
    end
    local v = livello[b]
    if v == nil then
      calcoli = calcoli + 1
      v = f(a, b)
      livello[b] = v
    end
    return v
  end
  return funzione, function() return calcoli end
end

local function lenta(a, b)
  local s = 0
  for i = 1, 100 do s = s + a * b end
  return s
end

local f1, c1 = memoizzaConcatenazione(lenta)
local f2, c2 = memoizzaAnnidata(lenta)

for _ = 1, 3 do
  for a = 1, 5 do
    for b = 1, 5 do
      f1(a, b)
      f2(a, b)
    end
  end
end

print("concatenazione: " .. c1() .. " calcoli reali")
print("annidata:       " .. c2() .. " calcoli reali")

-- Il difetto della concatenazione
print()
print("Collisione con la concatenazione:")
local function etichetta(a, b)
  return type(a) .. "/" .. tostring(a)
    .. "|" .. tostring(b)
end

local g1 = memoizzaConcatenazione(etichetta)
print("concatenazione, argomento numero: " .. g1(1, 2))
print("concatenazione, argomento stringa: " .. g1("1", 2))

local g2 = memoizzaAnnidata(etichetta)
print("annidata, argomento numero:  " .. g2(1, 2))
print("annidata, argomento stringa: " .. g2("1", 2))
```

Entrambe le strategie riducono i calcoli reali da settantacinque a
venticinque, cioè una volta per combinazione distinta.

**La chiave concatenata** è più semplice e usa una tabella sola, ma ha
due difetti. Il primo è che costruisce una stringa a ogni chiamata, il
che alloca memoria e costa. Il secondo, più grave, è la **collisione fra
tipi**: `tostring(1)` e `tostring("1")` producono la stessa stringa, e le
due chiamate condividono la voce di cache pur avendo argomenti diversi.
Nella dimostrazione, la seconda chiamata con la stringa `"1"` restituisce
il risultato memorizzato per il numero uno, cioè `number/1|2` invece di
`string/1|2`: la cache ha restituito la risposta sbagliata. Il separatore
con byte nullo riduce le collisioni fra stringhe che contengono il
separatore, ma non risolve quella fra tipi.

**Le tabelle annidate** non hanno collisioni, perché le chiavi restano i
valori originali e Lua distingue `1` da `"1"`. Costano una ricerca in più
e una tabella per ogni valore distinto del primo argomento.

Se gli argomenti non sono stringhe né numeri, entrambe funzionano ma in
modi diversi: la concatenazione userebbe la rappresentazione testuale,
che per due tabelle diverse produce chiavi diverse ma per la stessa
tabella produce la stessa chiave; le tabelle annidate userebbero
direttamente l’identità dell’oggetto, che è il comportamento corretto.

L’annidata ha però un problema di memoria: la tabella `cache` mantiene
vivi tutti i valori usati come chiave, impedendone la raccolta. Con
chiavi che sono oggetti, servirebbe una tabella debole, come nel
Capitolo 23.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
