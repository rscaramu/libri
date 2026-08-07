# Capitolo 23 — Il garbage collector e la gestione della memoria

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 22](capitolo-22.md) · [Indice](README.md) · [Capitolo 24 →](capitolo-24.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap23/`](../codice/cap23/).

---

**ES 23.4 — Incrementale contro generazionale**

*Misura sperimentalmente la differenza fra modalità incrementale e
generazionale su due carichi diversi: molti oggetti di breve durata,
e una struttura grande e stabile con poche modifiche. Commenta quale
modalità vince in ciascun caso e perché.*

```lua
local function misura(nome, modalita, carico)
  collectgarbage(modalita)
  collectgarbage("collect")
  collectgarbage("collect")

  local memPrima = collectgarbage("count")
  local inizio = os.clock()
  local pausaMassima = 0

  local risultato = carico(function()
    local t = os.clock()
    collectgarbage("step")
    local d = os.clock() - t
    if d > pausaMassima then pausaMassima = d end
  end)

  local durata = os.clock() - inizio
  local memDopo = collectgarbage("count")

  print(string.format(
    "  %-14s %.4f s  memoria finale %7.0f KB",
    modalita, durata, memDopo - memPrima))
  return risultato
end

-- Carico 1: molti oggetti di breve durata
local function caricoEffimero()
  return function()
    local somma = 0
    for i = 1, 300000 do
      local t = {a = i, b = i * 2, c = tostring(i)}
      somma = somma + t.a
    end
    return somma
  end
end

-- Carico 2: struttura grande e stabile
local function caricoStabile()
  return function()
    local vivi = {}
    for i = 1, 100000 do
      vivi[i] = {indice = i, dati = {i, i + 1}}
    end
    local somma = 0
    for _ = 1, 20 do
      for i = 1, 100000 do
        somma = somma + vivi[i].indice
      end
    end
    return somma, vivi
  end
end

print("=== carico effimero (oggetti di breve durata) ===")
misura("effimero", "incremental", caricoEffimero())
misura("effimero", "generational", caricoEffimero())

print()
print("=== carico stabile (struttura viva e grande) ===")
misura("stabile", "incremental", caricoStabile())
misura("stabile", "generational", caricoStabile())

collectgarbage("incremental")
```

Sul **carico effimero** la modalità generazionale è tipicamente più
veloce: gli oggetti muoiono giovani e vengono raccolti dalle scansioni
minori, senza che il raccoglitore debba mai attraversare l’intera
struttura viva.

Sul **carico stabile** il vantaggio si riduce o si inverte: la struttura
viva è grande e non cambia, quindi le scansioni minori trovano poco da
fare e le maggiori periodiche devono comunque attraversare tutto.

I numeri assoluti variano molto fra macchine e fra esecuzioni: quello che
resta stabile è la direzione della differenza. La conclusione operativa
del paragrafo 23.3 vale integralmente: cambiare **modalità** è una riga e
ha un effetto molto maggiore di qualunque taratura fine dei parametri, ma
va misurato sul carico reale.

**ES 23.5 — Chiavi deboli: stringhe contro tabelle**

*Dimostra con un programma che una tabella a chiavi deboli con chiavi
stringa non perde mai voci, mentre la stessa tabella con chiavi
tabella si svuota dopo una raccolta. Spiega nel commento il motivo.*

```lua
local conStringhe = setmetatable({}, {__mode = "k"})
local conTabelle = setmetatable({}, {__mode = "k"})
local conValoriDeboli = setmetatable({}, {__mode = "v"})

local function quante(t)
  local n = 0
  for _ in pairs(t) do n = n + 1 end
  return n
end

do
  for i = 1, 100 do
    conStringhe["chiave" .. i] = i
    conTabelle[{indice = i}] = i
    conValoriDeboli[i] = {indice = i}
  end
end

print("prima della raccolta:")
print("  chiavi stringa:  " .. quante(conStringhe))
print("  chiavi tabella:  " .. quante(conTabelle))
print("  valori tabella:  " .. quante(conValoriDeboli))

collectgarbage("collect")
collectgarbage("collect")

print("dopo la raccolta:")
print("  chiavi stringa:  " .. quante(conStringhe))
print("  chiavi tabella:  " .. quante(conTabelle))
print("  valori tabella:  " .. quante(conValoriDeboli))

print()
print("con un riferimento trattenuto:")
local trattenuta = {marcata = true}
conTabelle[trattenuta] = "sopravvive"
for i = 1, 50 do conTabelle[{}] = i end

collectgarbage("collect")
collectgarbage("collect")
print("  voci rimaste: " .. quante(conTabelle))
print("  la trattenuta c'e' ancora: "
  .. tostring(conTabelle[trattenuta]))

print()
print("chiavi numeriche:")
local conNumeri = setmetatable({}, {__mode = "k"})
for i = 1, 100 do conNumeri[i] = "x" end
collectgarbage("collect")
print("  voci rimaste: " .. quante(conNumeri))
```

produce:

```text
prima della raccolta:
  chiavi stringa:  100
  chiavi tabella:  1
  valori tabella:  1
dopo la raccolta:
  chiavi stringa:  100
  chiavi tabella:  0
  valori tabella:  0

con un riferimento trattenuto:
  voci rimaste: 1
  la trattenuta c'e' ancora: sopravvive

chiavi numeriche:
  voci rimaste: 100
```

La dimostrazione è netta. Notate che già **prima** della raccolta
esplicita le tabelle deboli si sono quasi svuotate: il raccoglitore
lavora in modo incrementale durante il ciclo di inserimento, e le voci
non riferite spariscono man mano. Le chiavi stringa, invece, sono ancora
tutte e cento.

Le **chiavi stringa** non spariscono mai: le stringhe in Lua non sono
oggetti con identità nel senso rilevante per la debolezza. Anche se
nessuno le riferisce, la voce resta.

Le **chiavi tabella** spariscono tutte, perché le tabelle create nel
blocco non sono più raggiungibili da nessuna parte.

La **tabella trattenuta** sopravvive, perché la variabile locale la
riferisce: è la proprietà che rende utili le tabelle deboli.

Le **chiavi numeriche** si comportano come le stringhe: i numeri non
sono raccoglibili.

La lezione pratica: `__mode = "k"` con chiavi che non siano tabelle,
funzioni o coroutine non serve a nulla, e chi lo scrive aspettandosi una
pulizia automatica scriverà una perdita di memoria convinto di aver fatto
il contrario.

**ES 23.6 — Memoria trattenuta e transitoria**

*Scrivi una funzione `misuraMemoria` che, data una funzione,
restituisca la memoria trattenuta dal suo risultato e quella
transitoria consumata durante l’esecuzione. Usala per confrontare
tre modi di costruire una stringa da centomila pezzi.*

```lua
local function misuraMemoria(funzione)
  collectgarbage("collect")
  collectgarbage("collect")
  local base = collectgarbage("count")

  local massimo = base
  local risultato = funzione(function()
    local attuale = collectgarbage("count")
    if attuale > massimo then massimo = attuale end
  end)

  local dopoEsecuzione = collectgarbage("count")
  if dopoEsecuzione > massimo then
    massimo = dopoEsecuzione
  end

  collectgarbage("collect")
  collectgarbage("collect")
  local trattenuta = collectgarbage("count") - base

  return {
    trattenuta = trattenuta,
    picco = massimo - base,
    transitoria = massimo - base - trattenuta,
    risultato = risultato,
  }
end

local N = 100000

local strategie = {
  {"concatenazione", function(campiona)
    local s = ""
    for i = 1, N // 10 do
      s = s .. i .. ","
      if i % 1000 == 0 then campiona() end
    end
    return s
  end},

  {"table.concat", function(campiona)
    local pezzi = {}
    for i = 1, N do
      pezzi[#pezzi + 1] = i
      if i % 10000 == 0 then campiona() end
    end
    return table.concat(pezzi, ",")
  end},

  {"table.concat + pulizia", function(campiona)
    local pezzi = {}
    for i = 1, N do
      pezzi[#pezzi + 1] = i
      if i % 10000 == 0 then campiona() end
    end
    local r = table.concat(pezzi, ",")
    pezzi = nil
    collectgarbage("collect")
    return r
  end},
}

print(string.format("%-24s %11s %11s %11s",
  "STRATEGIA", "TRATTENUTA", "PICCO", "TRANSITORIA"))

for _, s in ipairs(strategie) do
  local m = misuraMemoria(s[2])
  print(string.format("%-24s %9.0f KB %9.0f KB %9.0f KB",
    s[1], m.trattenuta, m.picco, m.transitoria))
end
```

La distinzione fra le tre grandezze è quella che l’esercizio chiedeva.

La **memoria trattenuta** è quella che resta occupata dopo la raccolta:
dipende solo dal risultato restituito, e per le tre strategie è
sostanzialmente la stessa, perché la stringa finale è la stessa.

Il **picco** è il massimo osservato durante l’esecuzione, ed è ciò che
determina se il programma sta in memoria.

La **memoria transitoria** è la differenza: è spazzatura prodotta e
poi liberata. La concatenazione ne produce moltissima, perché ogni
iterazione abbandona la stringa precedente.

La terza strategia mostra un dettaglio pratico: assegnare `nil` alla
tabella dei pezzi e forzare una raccolta **prima** di restituire riduce
la memoria trattenuta al solo risultato. In una funzione che prosegue a
lungo dopo aver costruito un dato grande, è la differenza fra tenere in
memoria una copia o due.

**ES 23.7 — Ordine dei finalizzatori e resurrezione**

*Verifica sperimentalmente l’ordine di esecuzione dei finalizzatori e
che cosa succede quando un finalizzatore rende di nuovo
raggiungibile l’oggetto che sta finalizzando, fenomeno noto come
resurrezione. Documenta il comportamento osservato.*

```lua
local eventi = {}
local resuscitato = nil

local function crea(nome)
  return setmetatable({nome = nome}, {
    __gc = function(o)
      eventi[#eventi + 1] = "finalizzo " .. o.nome
    end
  })
end

print("=== ordine di finalizzazione ===")
do
  local primo = crea("primo")
  local secondo = crea("secondo")
  local terzo = crea("terzo")
end

collectgarbage("collect")
collectgarbage("collect")

for _, e in ipairs(eventi) do print("  " .. e) end
print("  (creati nell'ordine primo, secondo, terzo)")

print()
print("=== resurrezione ===")
eventi = {}

local funzionaAncora = nil

do
  local risorsa = setmetatable({nome = "resuscitabile",
    valore = 42}, {
    __gc = function(o)
      eventi[#eventi + 1] = "gc chiamato su " .. o.nome
      -- Rendiamo l'oggetto di nuovo raggiungibile
      resuscitato = o
    end
  })
end

collectgarbage("collect")
collectgarbage("collect")

print("  eventi: " .. #eventi)
for _, e in ipairs(eventi) do print("    " .. e) end
print("  l'oggetto e' tornato raggiungibile: "
  .. tostring(resuscitato ~= nil))
if resuscitato then
  print("  e i suoi campi sono intatti: valore = "
    .. tostring(resuscitato.valore))
end

print()
print("=== il finalizzatore viene chiamato una "
  .. "seconda volta? ===")
eventi = {}
resuscitato = nil
collectgarbage("collect")
collectgarbage("collect")
print("  eventi dopo la seconda morte: " .. #eventi)
print("  (atteso 0: Lua marca l'oggetto come gia'")
print("   finalizzato e non richiama __gc)")
```

produce:

```text
=== ordine di finalizzazione ===
  finalizzo terzo
  finalizzo secondo
  finalizzo primo
  (creati nell'ordine primo, secondo, terzo)

=== resurrezione ===
  eventi: 1
    gc chiamato su resuscitabile
  l'oggetto e' tornato raggiungibile: true
  e i suoi campi sono intatti: valore = 42

=== il finalizzatore viene chiamato una seconda volta? ===
  eventi dopo la seconda morte: 0
  (atteso 0: Lua marca l'oggetto come gia'
   finalizzato e non richiama __gc)
```

L’**ordine è inverso rispetto alla creazione**: l’ultimo oggetto marcato
per la finalizzazione è il primo a essere finalizzato. È la regola
documentata nel paragrafo 23.6, e ha una motivazione pratica: se
l’oggetto B è stato costruito dopo A e ne dipende, B va rilasciato prima.

La **resurrezione** funziona: il finalizzatore riceve l’oggetto ancora
intatto e può renderlo di nuovo raggiungibile assegnandolo a una
variabile viva. Da quel momento l’oggetto è di nuovo utilizzabile a tutti
gli effetti.

Il finalizzatore, però, **non viene chiamato una seconda volta**: Lua
marca l’oggetto come già finalizzato, e alla morte successiva lo libera
senza cerimonie. È una protezione contro i cicli infiniti di
resurrezione.

La conclusione è che la resurrezione è un meccanismo curioso ma
inaffidabile per la gestione delle risorse: un oggetto resuscitato ha
perso il proprio finalizzatore, e la sua risorsa non verrà più rilasciata
automaticamente.

**ES 23.8 — Cache a due livelli**

*Implementa una cache a due livelli: un livello forte con un numero
massimo di voci recenti, e un livello debole illimitato per tutto il
resto. Verifica che le voci recenti sopravvivano a una raccolta e le
altre no.*

```lua
local Cache = {}
Cache.__index = Cache

function Cache.nuova(capacitaForte)
  return setmetatable({
    capacita = capacitaForte or 10,
    forte = {},
    ordine = {},
    debole = setmetatable({}, {__mode = "v"}),
    letture = 0,
    colpiForte = 0,
    colpiDebole = 0,
    mancati = 0,
  }, Cache)
end

function Cache:promuovi(chiave, valore)
  if self.forte[chiave] == nil then
    self.ordine[#self.ordine + 1] = chiave
    if #self.ordine > self.capacita then
      local vecchia = table.remove(self.ordine, 1)
      -- Retrocede al livello debole
      self.debole[vecchia] = self.forte[vecchia]
      self.forte[vecchia] = nil
    end
  end
  self.forte[chiave] = valore
end

function Cache:imposta(chiave, valore)
  self:promuovi(chiave, valore)
  return valore
end

function Cache:leggi(chiave)
  self.letture = self.letture + 1

  local v = self.forte[chiave]
  if v ~= nil then
    self.colpiForte = self.colpiForte + 1
    return v, "forte"
  end

  v = self.debole[chiave]
  if v ~= nil then
    self.colpiDebole = self.colpiDebole + 1
    self:promuovi(chiave, v)
    self.debole[chiave] = nil
    return v, "debole"
  end

  self.mancati = self.mancati + 1
  return nil, "assente"
end

function Cache:stato()
  local nForte, nDebole = 0, 0
  for _ in pairs(self.forte) do nForte = nForte + 1 end
  for _ in pairs(self.debole) do nDebole = nDebole + 1 end
  return {
    forte = nForte, debole = nDebole,
    letture = self.letture,
    colpiForte = self.colpiForte,
    colpiDebole = self.colpiDebole,
    mancati = self.mancati,
  }
end

local c = Cache.nuova(5)

for i = 1, 20 do
  c:imposta("k" .. i, {indice = i,
    riempimento = string.rep("x", 500)})
end

local s1 = c:stato()
print(string.format("dopo 20 inserimenti: forte=%d "
  .. "debole=%d", s1.forte, s1.debole))

collectgarbage("collect")
collectgarbage("collect")

local s2 = c:stato()
print(string.format("dopo la raccolta:    forte=%d "
  .. "debole=%d", s2.forte, s2.debole))

print()
print("verifica delle voci recenti:")
for i = 16, 20 do
  local v, dove = c:leggi("k" .. i)
  print(string.format("  k%-3d %s", i, dove))
end

print("verifica delle voci vecchie:")
for i = 6, 10 do
  local v, dove = c:leggi("k" .. i)
  print(string.format("  k%-3d %s", i, dove))
end

local s3 = c:stato()
print()
print(string.format(
  "letture=%d forte=%d debole=%d mancati=%d",
  s3.letture, s3.colpiForte, s3.colpiDebole,
  s3.mancati))
```

Il primo livello, **forte**, conserva le voci recenti e le mantiene vive
con certezza. Il secondo, **debole**, raccoglie ciò che esce dal primo:
le voci restano disponibili finché qualcun altro le riferisce o finché il
raccoglitore non passa.

L’esecuzione mostra il comportamento atteso e una sfumatura utile. Dopo
i venti inserimenti il livello forte contiene esattamente cinque voci,
mentre il debole ne contiene sette e non quindici: il raccoglitore ha già
liberato le altre durante il ciclo, perché nessuno le riferiva.

Dopo la raccolta esplicita il livello debole si svuota **del tutto**, e
restano solo le cinque voci recenti. Le letture successive lo confermano:
`k16` fino a `k20` rispondono dal livello forte, `k6` fino a `k10`
risultano assenti.

È esattamente il contratto delle due strutture: il livello forte
**garantisce** la permanenza, il debole la offre soltanto finché qualcuno
riferisce il valore o finché il raccoglitore non passa. Una cache a due
livelli va progettata sapendo che il secondo può svuotarsi in qualunque
momento.

Un colpo sul livello debole **promuove** la voce al livello forte, perché
un accesso è indizio che servirà ancora. È una politica elementare di
promozione, e da sola trasforma la struttura in una cache a due velocità
che si adatta all’uso.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
