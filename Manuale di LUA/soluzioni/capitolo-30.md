# Capitolo 30 — Le versioni di Lua: da 5.1 a 5.5, migrazione e compatibilità

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 29](capitolo-29.md) · [Indice](README.md) · [Capitolo 31 →](capitolo-31.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap30/`](../codice/cap30/).

---

**ES 30.3 — Migrazione di un programma da 5.1 a 5.4**

*Prendi un programma scritto per Lua 5.1 trovato in rete e migralo a
5.4 seguendo i cinque passi del paragrafo 30.8, documentando ogni
modifica e la ragione.*

Il programma di partenza, tipico del materiale scritto per Lua 5.1:

```text
module("geometria", package.seeall)

function areaCerchio(r)
  return math.pi * math.pow(r, 2)
end

function normalizza(v)
  local somma = 0
  for i = 1, table.maxn(v) do
    somma = somma + (v[i] or 0)
  end
  local r = {}
  for i = 1, table.maxn(v) do
    r[i] = (v[i] or 0) / somma
  end
  return unpack(r)
end

function conAmbiente(codice, dati)
  local f = loadstring(codice)
  setfenv(f, dati)
  return f()
end

function impacchetta(...)
  local n = select("#", ...)
  return {n = n, ...}
end
```

Applicando i cinque passi del paragrafo 30.8.

**Primo passo: inventario.** Il `grep` individua `module(`, `math.pow`,
`table.maxn`, `unpack`, `loadstring`, `setfenv`. Sono sei costruzioni,
tutte rimosse.

**Secondo passo: analisi statica.** `luacheck --std=lua54` segnala anche
`package.seeall`, che non esiste più, e conferma che `unpack` e
`loadstring` sono variabili globali non definite.

**Terzo passo: la riscrittura.**

```lua
local M = {}

function M.areaCerchio(r)
  -- math.pow rimossa in 5.3: si usa l'operatore ^
  return math.pi * r ^ 2
end

function M.normalizza(v)
  -- table.maxn rimossa in 5.2. La sostituzione NON e'
  -- banale: maxn restituiva il massimo indice
  -- numerico, anche con buchi, mentre # restituisce
  -- un bordo qualunque.
  local massimo = 0
  for k in pairs(v) do
    if type(k) == "number" and k > massimo then
      massimo = k
    end
  end

  local somma = 0
  for i = 1, massimo do
    somma = somma + (v[i] or 0)
  end
  if somma == 0 then
    return nil, "somma nulla"
  end

  local r = {}
  for i = 1, massimo do
    r[i] = (v[i] or 0) / somma
  end
  return table.unpack(r, 1, massimo)
end

function M.conAmbiente(codice, dati)
  -- loadstring rimossa in 5.2: load accetta stringhe.
  -- setfenv rimossa: l'ambiente si passa a load.
  local f, errore = load(codice, "codice", "t", dati)
  if f == nil then return nil, errore end
  return f()
end

function M.impacchetta(...)
  -- table.pack fa esattamente questo dalla 5.2
  return table.pack(...)
end

return M
```

**Quarto passo: i test.** La suite va eseguita su entrambe le versioni
durante la transizione. Qui non è possibile, perché la versione nuova usa
`table.pack`, ma il principio resta.

**Quinto passo: le differenze semantiche.** Sono tre, e nessuna produce
un errore.

`math.pow(r, 2)` e `r ^ 2` danno lo stesso valore, ma il **tipo** cambia
fra 5.1 e 5.4? No: entrambi producono un float. Qui non c’è differenza.

`table.maxn` contro `#` è la differenza vera, ed è quella che il commento
nel codice segnala: sulla tabella `{[1]=1, [3]=3}`, `maxn` restituiva
tre mentre `#` può restituire uno. La sostituzione ingenua di `maxn` con
`#` cambierebbe silenziosamente il comportamento della funzione. La
soluzione adottata — scorrere le chiavi con `pairs` — riproduce la
semantica originale.

`setfenv` contro l’ambiente passato a `load` differiscono in un punto:
`setfenv` operava su una funzione **già compilata**, mentre `load` lo
imposta alla compilazione. Se il codice originale compilava una volta e
cambiava ambiente più volte, la riscrittura diretta non lo riproduce e
serve la tecnica dell’ES 24.2 con `debug.setupvalue`.

Il ritorno di `M.normalizza` è stato inoltre modificato per gestire il
caso della somma nulla, che nella versione originale produceva `nan`
silenziosamente: le migrazioni sono l’occasione naturale per correggere i
difetti che si incontrano.

**ES 30.4 — Rilevatore con analizzatore lessicale**

*Estendi il rilevatore dell’ES 30.1 perché gestisca correttamente i
commenti lunghi e le occorrenze dentro le stringhe, usando un
analizzatore lessicale minimo invece dei pattern.*

```lua
local function tokenizza(sorgente)
  local unita = {}
  local i = 1
  local riga = 1
  local n = #sorgente

  local function avanza(quanti)
    for k = i, math.min(i + quanti - 1, n) do
      if sorgente:sub(k, k) == "\n" then
        riga = riga + 1
      end
    end
    i = i + quanti
  end

  local function livelloParentesiLunghe(da)
    if sorgente:sub(da, da) ~= "[" then return nil end
    local k = da + 1
    local livello = 0
    while sorgente:sub(k, k) == "=" do
      livello = livello + 1
      k = k + 1
    end
    if sorgente:sub(k, k) == "[" then
      return livello, k + 1
    end
    return nil
  end

  local function saltaLungo(inizio, livello)
    local chiusura = "]" .. string.rep("=", livello)
      .. "]"
    local fine = sorgente:find(chiusura, inizio, true)
    if fine == nil then return n + 1 end
    return fine + #chiusura
  end

  while i <= n do
    local c = sorgente:sub(i, i)

    -- commento
    if sorgente:sub(i, i + 1) == "--" then
      local livello, dopo =
        livelloParentesiLunghe(i + 2)
      if livello then
        local fine = saltaLungo(dopo, livello)
        avanza(fine - i)
      else
        local fine = sorgente:find("\n", i, true)
          or (n + 1)
        avanza(fine - i)
      end

    -- stringa lunga
    elseif c == "[" and livelloParentesiLunghe(i) then
      local livello, dopo = livelloParentesiLunghe(i)
      local fine = saltaLungo(dopo, livello)
      avanza(fine - i)

    -- stringa breve
    elseif c == '"' or c == "'" then
      local apice = c
      local k = i + 1
      while k <= n do
        local d = sorgente:sub(k, k)
        if d == "\\" then
          k = k + 2
        elseif d == apice then
          k = k + 1
          break
        else
          k = k + 1
        end
      end
      avanza(k - i)

    -- numero
    elseif c:match("%d") then
      local k = i
      while k <= n
        and sorgente:sub(k, k):match("[%w%.]") do
        k = k + 1
      end
      avanza(k - i)

    -- identificatore
    elseif c:match("[%a_]") then
      local k = i
      while k <= n
        and sorgente:sub(k, k):match("[%w_]") do
        k = k + 1
      end
      unita[#unita + 1] = {
        tipo = "nome",
        testo = sorgente:sub(i, k - 1),
        riga = riga,
      }
      avanza(k - i)

    -- simboli significativi
    elseif sorgente:sub(i, i + 1) == "//"
        or sorgente:sub(i, i + 1) == "<<"
        or sorgente:sub(i, i + 1) == ">>" then
      unita[#unita + 1] = {
        tipo = "operatore",
        testo = sorgente:sub(i, i + 1),
        riga = riga,
      }
      avanza(2)

    elseif c == "&" or c == "|" or c == "~" then
      unita[#unita + 1] = {
        tipo = "operatore", testo = c, riga = riga,
      }
      avanza(1)

    elseif c == "<" then
      -- possibile attributo <const> o <close>
      local nome, fine =
        sorgente:match("^<%s*(%a+)%s*>()", i)
      if nome == "const" or nome == "close" then
        unita[#unita + 1] = {
          tipo = "attributo", testo = nome,
          riga = riga,
        }
        avanza(fine - i)
      else
        avanza(1)
      end

    else
      avanza(1)
    end
  end

  return unita
end

local RIMOSSE = {
  ["module"] = {"5.2", "usa una tabella locale"},
  ["setfenv"] = {"5.2", "usa _ENV"},
  ["getfenv"] = {"5.2", "usa _ENV"},
  ["loadstring"] = {"5.2", "usa load"},
  ["maxn"] = {"5.2", "calcola a mano"},
  ["pow"] = {"5.3", "usa l'operatore ^"},
  ["cosh"] = {"5.3", "formula esplicita"},
}

local INTRODOTTE = {
  ["//"] = "5.3", ["&"] = "5.3", ["|"] = "5.3",
  ["<<"] = "5.3", [">>"] = "5.3",
  ["const"] = "5.4", ["close"] = "5.4",
  ["warn"] = "5.4",
}

local function confronta(a, b)
  local ma, na = a:match("(%d+)%.(%d+)")
  local mb, nb = b:match("(%d+)%.(%d+)")
  ma, na = tonumber(ma), tonumber(na)
  mb, nb = tonumber(mb), tonumber(nb)
  if ma ~= mb then return ma < mb and -1 or 1 end
  if na ~= nb then return na < nb and -1 or 1 end
  return 0
end

local function analizza(sorgente, versione)
  local segnalazioni = {}
  for _, u in ipairs(tokenizza(sorgente)) do
    local rimossa = RIMOSSE[u.testo]
    if u.tipo == "nome" and rimossa
       and confronta(versione, rimossa[1]) >= 0 then
      segnalazioni[#segnalazioni + 1] = string.format(
        "riga %d: %s rimossa in Lua %s (%s)",
        u.riga, u.testo, rimossa[1], rimossa[2])
    end

    local introdotta = INTRODOTTE[u.testo]
    if (u.tipo == "operatore" or u.tipo == "attributo"
        or u.tipo == "nome")
       and introdotta
       and confronta(versione, introdotta) < 0 then
      segnalazioni[#segnalazioni + 1] = string.format(
        "riga %d: %s richiede Lua %s",
        u.riga, u.testo, introdotta)
    end
  end
  return segnalazioni
end

local SORGENTE = [==[
local M = {}
-- questo commento parla di math.pow e non conta
local documentazione = [[
  Anche qui dentro math.pow e setfenv sono testo.
]]
local avviso = "loadstring in una stringa"
function M.calcola(x)
  local y <const> = math.pow(x, 2)
  local z = 17 // 5
  return y & z
end
--[[ commento lungo
     con table.maxn dentro
]]
return M
]==]

for _, versione in ipairs({"5.1", "5.3", "5.4"}) do
  print("=== per Lua " .. versione .. " ===")
  local s = analizza(SORGENTE, versione)
  if #s == 0 then print("  nessun problema") end
  for _, riga in ipairs(s) do print("  " .. riga) end
  print()
end
```

produce:

```text
=== per Lua 5.1 ===
  riga 8: const richiede Lua 5.4
  riga 9: // richiede Lua 5.3
  riga 10: & richiede Lua 5.3

=== per Lua 5.3 ===
  riga 8: const richiede Lua 5.4
  riga 8: pow rimossa in Lua 5.3 (usa l'operatore ^)

=== per Lua 5.4 ===
  riga 8: pow rimossa in Lua 5.3 (usa l'operatore ^)
```

Il confronto con la versione a pattern dell’ES 30.1 è netto. Il sorgente
di prova contiene `math.pow`, `setfenv`, `loadstring` e `table.maxn`
dentro **commenti di riga, stringhe lunghe, stringhe brevi e commenti
lunghi**, e nessuna di quelle occorrenze viene segnalata.

Solo il vero `math.pow` alla riga otto compare nel rapporto, insieme
all’attributo `<const>` e agli operatori.

L’analizzatore lessicale non è completo — non gestisce i numeri
esadecimali con esponente, né distingue `math.pow` da `mio.pow` — ma la
differenza qualitativa rispetto ai pattern è già visibile: i falsi
positivi da commenti e stringhe, che nell’ES 30.1 erano il limite
dichiarato, sono spariti.

**ES 30.5 — Rapporto delle differenze semantiche**

*Scrivi un programma che, eseguito su versioni diverse di Lua,
produca un rapporto delle differenze **semantiche** osservate: tipo
del risultato della divisione, comportamento di `#` su tabelle con
buchi, ordine di `pairs` su una tabella data, sequenza dei primi
cinque valori di `math.random` con seme fisso.*

```lua
local righe = {}

local function segnala(nome, valore)
  righe[#righe + 1] = string.format("%-34s %s",
    nome, tostring(valore))
end

segnala("_VERSION", _VERSION)

-- 1. Tipo del risultato della divisione
segnala("tipo di 6/3", math.type and math.type(6/3)
  or "senza math.type")
segnala("6/3 == 2", 6/3 == 2)
segnala("tostring(6/3)", tostring(6/3))
segnala("tipo di 6//3", math.type and math.type(6//3)
  or "n/d")

-- 2. Comportamento di # su tabelle con buchi
local conBuchi = {}
conBuchi[1] = "a"
conBuchi[2] = "b"
conBuchi[4] = "d"
segnala("# su {1,2,_,4}", #conBuchi)

local conBuchi2 = {"a", nil, "c"}
segnala("# su {'a', nil, 'c'}", #conBuchi2)

local grande = {}
for i = 1, 100 do grande[i] = i end
grande[50] = nil
segnala("# su 1..100 senza il 50", #grande)

-- 3. Ordine di pairs su una tabella data
local ordinata = {}
for _, k in ipairs({"alfa", "beta", "gamma", "delta",
    "epsilon"}) do
  ordinata[k] = true
end
local visto = {}
for k in pairs(ordinata) do visto[#visto + 1] = k end
segnala("ordine di pairs", table.concat(visto, " "))

-- 4. Sequenza di math.random con seme fisso
math.randomseed(42)
local casuali = {}
for i = 1, 5 do
  casuali[i] = math.random(1, 1000)
end
segnala("random con seme 42",
  table.concat(casuali, " "))

math.randomseed(42)
local ripetuti = {}
for i = 1, 5 do
  ripetuti[i] = math.random(1, 1000)
end
segnala("stessa sequenza ripetendo il seme",
  table.concat(casuali, " ")
    == table.concat(ripetuti, " "))

-- 5. Rappresentazione dei float
segnala("tostring(0.1)", tostring(0.1))
segnala("tostring(1/3)", tostring(1/3))
segnala("tostring(2^63)", tostring(2^63))
segnala("0.1 + 0.2 == 0.3", 0.1 + 0.2 == 0.3)
segnala("tostring(0.1 + 0.2)", tostring(0.1 + 0.2))

-- 6. Coercizione stringa-numero
segnala("'10' + 5", pcall(function()
  return "10" + 5 end) and ("10" + 5) or "errore")
segnala("tipo di '10' + 5",
  math.type and math.type("10" + 5) or "n/d")

-- 7. Confronto fra interi e float
segnala("1 == 1.0", 1 == 1.0)
segnala("chiave 1 e chiave 1.0",
  (function()
    local t = {}
    t[1] = "intero"
    t[1.0] = "float"
    return t[1]
  end)())

-- 8. Concatenazione di numeri
segnala("1 .. ''", 1 .. "")
segnala("1.0 .. ''", 1.0 .. "")

print(table.concat(righe, "\n"))
```

produce, su Lua 5.4:

```text
_VERSION                           Lua 5.4
tipo di 6/3                        float
6/3 == 2                           true
tostring(6/3)                      2.0
tipo di 6//3                       integer
# su {1,2,_,4}                     4
# su {'a', nil, 'c'}               3
# su 1..100 senza il 50            100
ordine di pairs                    gamma epsilon beta
                                   delta alfa
random con seme 42                 742 50 332 342 950
stessa sequenza ripetendo il seme  true
tostring(0.1)                      0.1
tostring(1/3)                      0.33333333333333
tostring(2^63)                     9.2233720368548e+18
0.1 + 0.2 == 0.3                   false
tostring(0.1 + 0.2)                0.3
'10' + 5                           15
tipo di '10' + 5                   integer
1 == 1.0                           true
chiave 1 e chiave 1.0              float
1 .. ''                            1
1.0 .. ''                          1.0
```

Le righe più istruttive sono quattro.

**`#` sulle tabelle con buchi** restituisce quattro su `{1,2,_,4}`, tre
su `{"a", nil, "c"}` e cento su una sequenza da cui è stato tolto
l’elemento cinquanta. In tutti e tre i casi il valore **salta oltre il
buco**: sono bordi validi secondo la definizione del Capitolo 10, ma non
sono affatto quelli che l’intuizione suggerisce. Chi si aspettasse due,
uno e quarantanove resterebbe sorpreso, e il valore dipende dalla
struttura interna della tabella, non da una regola prevedibile.

**La coercizione stringa-numero** produce un **intero**: `"10" + 5` vale
quindici di tipo `integer`, non float. È il comportamento della 5.4, che
analizza la stringa come numero intero quando può; nelle versioni fino
alla 5.2 sarebbe stato un float, perché gli interi non esistevano.

**L’ordine di `pairs`** non è quello di inserimento né alcun altro
prevedibile. Ma c’è di più, ed è il risultato più istruttivo del
rapporto: **cambia a ogni esecuzione**. Eseguendo tre volte di seguito
lo stesso programma sulle stesse cinque chiavi si ottengono tre ordini
diversi.

La ragione è che Lua 5.4 inizializza con un valore casuale, a ogni
avvio del processo, il seme della funzione di hash delle stringhe: è una
difesa contro gli attacchi che provocano collisioni deliberate. Due
esecuzioni dello stesso programma dispongono quindi le chiavi in modo
diverso dentro la tabella.

La conseguenza pratica è forte: un programma che dipende dall’ordine di
`pairs` non è soltanto fragile fra versioni di Lua, è **irriproducibile
fra due esecuzioni sulla stessa macchina**. È l’osservazione che
giustifica l’ordinamento esplicito delle chiavi ripetuto in tutto il
manuale, e il motivo per cui l’output qui sopra riporta uno dei possibili
ordini e non «l’ordine».

**`0.1 + 0.2 == 0.3` è falso ma `tostring(0.1 + 0.2)` stampa `0.3`.** È
la coppia di righe più insidiosa dell’intero rapporto: la
rappresentazione testuale arrotonda e nasconde la differenza, quindi un
confronto fra output testuali darebbe uguale mentre il confronto
numerico dà diverso. In Lua 5.5, dove `tostring` stampa più cifre, la
stessa riga produrrebbe un valore diverso, e un test che confronta output
si romperebbe.

**ES 30.6 — `print` e `tostring` in Lua 5.4**

*Verifica sperimentalmente l’affermazione del paragrafo 30.4 secondo
cui in Lua 5.4 `print` non passa più dalla funzione globale
`tostring`. Scrivi il programma che lo dimostra e commenta quale
codice esistente questa modifica poteva rompere.*

```lua
local originale = tostring

local chiamate = 0
local ultimoArgomento = nil

_G.tostring = function(v)
  chiamate = chiamate + 1
  ultimoArgomento = v
  return "SOSTITUITO(" .. originale(v) .. ")"
end

print("--- con tostring globale sostituito ---")
print(42)
print("una stringa")
print(nil)
print(true)

local conMeta = setmetatable({}, {
  __tostring = function() return "DA METAMETODO" end
})
print(conMeta)

print("chiamate a tostring intercettate da print: "
  .. chiamate)

print("--- concatenazione e string.format ---")
local prima = chiamate
local s = "valore: " .. 42
local f = string.format("%s", 42)
print("chiamate durante .. e format: "
  .. (chiamate - prima))

print("--- chiamata esplicita ---")
local prima2 = chiamate
local esplicita = tostring(99)
print("chiamate con tostring esplicito: "
  .. (chiamate - prima2))
print("risultato: " .. originale(esplicita))

_G.tostring = originale
print("--- ripristinato ---")
print("ora print e' normale: " .. 7)
```

produce, su Lua 5.4:

```text
--- con tostring globale sostituito ---
42
una stringa
nil
true
DA METAMETODO
chiamate a tostring intercettate da print: 0
--- concatenazione e string.format ---
chiamate durante .. e format: 0
--- chiamata esplicita ---
chiamate con tostring esplicito: 1
risultato: SOSTITUITO(99)
--- ripristinato ---
ora print e' normale: 7
```

La dimostrazione è netta: **`print` non passa dalla funzione globale
`tostring`**. Il contatore resta a zero dopo cinque chiamate a `print`,
compresa quella su un oggetto con `__tostring`, che viene invece
onorato.

Anche `string.format` con `%s` e la concatenazione non passano dalla
globale: usano la conversione interna e il metametodo.

Solo la chiamata esplicita a `tostring` invoca la versione sostituita, e
il suo risultato viene stampato con il prefisso.

Quale codice esistente questa modifica poteva rompere? Ne esistono due
categorie.

**Le librerie di tracciamento** che sostituivano `tostring` per
registrare o formattare in modo speciale ogni valore stampato. Fino a Lua
5.3 bastava sostituire la globale per intercettare tutti i `print`; dalla
5.4 non funziona più, e serve sostituire `print` stesso.

**I sistemi di localizzazione** che sostituivano `tostring` per
formattare i numeri secondo la convenzione locale, con la virgola
decimale. La sostituzione non ha più effetto su `print`.

In entrambi i casi la correzione è sostituire `print`, che resta una
funzione globale ordinaria, invece di `tostring`.

**ES 30.7 — Le incompatibilità delle sezioni 8**

*Documenta, consultando i manuali di riferimento ufficiali, tutte le
incompatibilità elencate nella sezione 8 di Lua 5.4 e 5.5, e
stabilisci per ciascuna quanto è probabile che tocchi un progetto
reale.*

Le incompatibilità dichiarate nei manuali di riferimento, con una stima
di quanto è probabile che tocchino un progetto reale.

**Da 5.3 a 5.4 — molto probabili:**

`__gc` **sugli oggetti che non lo avevano al momento di
`setmetatable`** non viene più onorato. Tocca chi costruisce metatabelle
in modo dinamico, ed è il caso B dell’ES 13.7. Probabilità **media**.

`math.randomseed` **senza argomenti** ora produce un seme casuale invece
di un errore, e il generatore è diverso. Rompe ogni test che dipenda da
una sequenza casuale con seme fisso. Probabilità **alta** nei progetti
con test.

`print` **non passa più da `tostring`**, come nell’ES 30.6. Probabilità
**bassa** ma con effetti confusi quando capita.

**Da 5.3 a 5.4 — poco probabili:**

La funzione `luaL_checkversion` è più severa sui moduli C compilati per
versioni diverse. Tocca solo chi distribuisce moduli C binari.

Le funzioni `lua_resume` e `lua_pcallk` hanno firme leggermente diverse.
Tocca solo chi usa l’API C con le continuazioni.

`os.date` con formati non standard ora produce un errore invece di un
risultato dipendente dalla piattaforma. Probabilità **bassa**, e il
cambiamento è un miglioramento.

**Da 5.4 a 5.5 — molto probabili:**

Le **variabili di controllo del `for` sono in sola lettura**. Assegnare
alla variabile del ciclo è ora un errore di compilazione. È inutile
farlo, ma il codice esistente che lo fa non compila più. Probabilità
**media** su basi di codice grandi e vecchie.

Le **globali possono richiedere dichiarazione**. Non è attivo per
difetto, ma i progetti che lo attivano devono dichiarare ogni globale.
Probabilità **alta** se si adotta la funzionalità, che è il motivo per
cui adottarla su un progetto esistente va pianificato.

La **stampa dei float con più cifre** rompe i test che confrontano output
testuali contenenti numeri. Probabilità **media**, e il sintomo è
sconcertante: test che falliscono senza che il codice sia cambiato.

**Da 5.4 a 5.5 — poco probabili:**

I costruttori con più livelli di annidamento ora sono consentiti: è un
allentamento, non una restrizione.

`math.frexp` e `math.ldexp` reintrodotte: chi le aveva riscritte a mano
non ne è toccato.

Le stringhe esterne toccano solo chi incorpora l’interprete.

La regola generale che emerge: le incompatibilità che colpiscono
davvero sono quelle che riguardano il **generatore casuale**, i
**finalizzatori** e la **rappresentazione testuale dei numeri**, perché
non producono errori ma cambiano il comportamento. Le rimozioni di
funzioni, che sembrano più drammatiche, sono in realtà le più facili: il
programma non parte e il messaggio dice esattamente che cosa manca.

**ES 30.8 — Strato di compatibilità per `<close>`, verificato**

*Scrivi uno strato di compatibilità per `<close>` che su Lua 5.4 e
successivi usi l’attributo e sulle versioni precedenti simuli il
comportamento con `pcall`, con la stessa interfaccia e le stesse
garanzie in caso di errore. Verifica entrambi i percorsi.*

La soluzione è quella dell’ES 27.8, di cui questo esercizio chiede la
verifica di **entrambi i percorsi**. Poiché su Lua 5.4 il ramo simulato
non verrebbe mai eseguito, lo si forza:

```lua
local function costruisciStrato(forzaSimulato)
  local haClose = not forzaSimulato
    and load("local x <close> = nil") ~= nil

  local function chiudi(risorsa, errore)
    local m = getmetatable(risorsa)
    if m and type(m.__close) == "function" then
      return m.__close(risorsa, errore)
    end
    return risorsa:chiudi(errore)
  end

  if haClose then
    return load([[
      local chiudi = ...
      return function(costruttore, azione)
        local risorsa, errore = costruttore()
        if risorsa == nil then
          return nil, errore or "costruzione fallita"
        end
        local guardia <close> = risorsa
        return azione(risorsa)
      end
    ]])(chiudi), "nativa"
  end

  return function(costruttore, azione)
    local risorsa, errore = costruttore()
    if risorsa == nil then
      return nil, errore or "costruzione fallita"
    end
    local risultati = table.pack(pcall(azione, risorsa))

    -- ATTENZIONE: qui NON si puo' scrivere
    --   risultati[1] and nil or risultati[2]
    -- perche' con il ramo vero uguale a nil l'idioma
    -- restituisce sempre il ramo falso. E' la trappola
    -- del Capitolo 6.
    local motivo
    if not risultati[1] then motivo = risultati[2] end

    local okChiusura, erroreChiusura = pcall(chiudi,
      risorsa, motivo)
    if not risultati[1] then error(risultati[2], 0) end
    if not okChiusura then error(erroreChiusura, 0) end
    return table.unpack(risultati, 2, risultati.n)
  end, "simulata"
end

local function creaRisorsa(nome, registro)
  return setmetatable({nome = nome}, {
    __close = function(r, errore)
      registro[#registro + 1] = string.format(
        "chiusa %s (errore: %s)", r.nome,
        tostring(errore))
    end,
    __index = {
      usa = function(r) return "uso di " .. r.nome end,
    },
  })
end

local SCENARI = {
  {
    nome = "successo",
    azione = function(r) return r:usa() end,
    atteso = "uso di X",
  },
  {
    nome = "errore nell'azione",
    azione = function() error("guasto", 0) end,
    atteso = nil,
  },
  {
    nome = "valori multipli",
    azione = function(r) return 1, 2, 3 end,
    atteso = 1,
  },
  {
    nome = "nil come risultato",
    azione = function(r) return nil, "motivo" end,
    atteso = nil,
  },
}

for _, forzaSimulato in ipairs({false, true}) do
  local conRisorsa, quale =
    costruisciStrato(forzaSimulato)
  print("=== implementazione " .. quale .. " ===")

  for _, sc in ipairs(SCENARI) do
    local registro = {}
    local risultati = table.pack(pcall(conRisorsa,
      function() return creaRisorsa("X", registro) end,
      sc.azione))

    local esito
    if risultati[1] then
      esito = "ok: " .. tostring(risultati[2])
    else
      esito = "errore: " .. tostring(risultati[2])
    end

    print(string.format("  %-22s %-22s chiusure: %d",
      sc.nome, esito, #registro))
    for _, r in ipairs(registro) do
      print("      " .. r)
    end
  end
  print()
end
```

produce:

```text
=== implementazione nativa ===
  successo               ok: uso di X           chiusure: 1
      chiusa X (errore: nil)
  errore nell'azione     errore: guasto         chiusure: 1
      chiusa X (errore: guasto)
  valori multipli        ok: 1                  chiusure: 1
      chiusa X (errore: nil)
  nil come risultato     ok: nil                chiusure: 1
      chiusa X (errore: nil)

=== implementazione simulata ===
  successo               ok: uso di X           chiusure: 1
      chiusa X (errore: nil)
  errore nell'azione     errore: guasto         chiusure: 1
      chiusa X (errore: guasto)
  valori multipli        ok: 1                  chiusure: 1
      chiusa X (errore: nil)
  nil come risultato     ok: nil                chiusure: 1
      chiusa X (errore: nil)
```

I due percorsi si comportano **identicamente** su tutti e quattro gli
scenari: la risorsa viene chiusa esattamente una volta in ogni caso, il
motivo dell’errore viene propagato al metametodo, e i valori multipli
sopravvivono.

Vale la pena raccontare come questa uguaglianza sia stata raggiunta. La
prima stesura del ramo simulato calcolava il motivo dell’errore con
`risultati[1] and nil or risultati[2]`, e il confronto fra i due rami
mostrava una discrepanza: negli scenari **riusciti** la versione simulata
passava a `__close` il valore restituito dall’azione invece di `nil`,
producendo righe come `chiusa X (errore: uso di X)`.

La causa è la trappola del Capitolo 6, comparsa qui per l’ennesima volta:
il ramo vero dell’idioma è `nil`, quindi `and` lo restituisce, `or` lo
scarta e prende sempre il ramo falso. La correzione è un `if` esplicito,
segnalato con un commento nel codice.

È esattamente il motivo per cui questo esercizio chiede di provare
**entrambi** i rami: la discrepanza era invisibile finché si eseguiva
solo quello nativo.

La verifica di entrambi i rami richiede di poterli forzare, ed è il
motivo del parametro `forzaSimulato`. Uno strato di compatibilità in cui
un ramo non è mai provato sulla macchina dello sviluppatore è uno strato
di cui non si sa nulla: il ramo non testato è quello che si romperà
sull’ambiente dell’utente.

Restano le due differenze dichiarate nell’ES 27.8: la traccia dello stack
e il comportamento sulle uscite anticipate da un blocco. Nessuna delle
due è osservabile in questi scenari, il che è a sua volta un’osservazione
utile: i test verificano le proprietà che si è pensato di verificare.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
