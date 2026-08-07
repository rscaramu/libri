# Capitolo 10 — Le tabelle: l’unica struttura dati di Lua

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 9](capitolo-09.md) · [Indice](README.md) · [Capitolo 11 →](capitolo-11.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap10/`](../codice/cap10/).

---

**ES 10.4 — Riconoscere una sequenza**

*Scrivi una funzione che restituisca `true` se una tabella è una
sequenza secondo la definizione del paragrafo 10.7, e `false`
altrimenti. Testala su almeno sei tabelle diverse, comprese quelle
con buchi, con chiavi stringa e con chiavi float.*

```lua
local function eSequenza(t)
  if type(t) ~= "table" then return false end

  local massimo = 0
  local quante = 0

  for k in pairs(t) do
    if math.type(k) ~= "integer" then
      return false
    end
    if k < 1 then return false end
    if k > massimo then massimo = k end
    quante = quante + 1
  end

  return massimo == quante, quante
end

local prove = {
  {{}, true, "vuota"},
  {{1, 2, 3}, true, "sequenza normale"},
  {{"a", nil, "c"}, false, "con buco"},
  {{a = 1}, false, "chiave stringa"},
  {{[1] = "x", [3] = "y"}, false, "indici non contigui"},
  {{[0] = "zero", "uno"}, false, "indice zero"},
  {{[1.5] = "x"}, false, "chiave float"},
  {{[2.0] = "x", [1] = "y"}, true, "float intero"},
  {{1, 2, nome = "x"}, false, "mista"},
  {{[-1] = "x"}, false, "indice negativo"},
}

for _, p in ipairs(prove) do
  local r = eSequenza(p[1])
  print(string.format("%-22s atteso=%-5s ottenuto=%-5s %s",
    p[3], tostring(p[2]), tostring(r),
    r == p[2] and "ok" or "ERRORE"))
end
```

Il caso `{[2.0] = "x", [1] = "y"}` è quello istruttivo: la chiave `2.0` è
un float, ma Lua la **normalizza** a intero perché ha valore intero,
secondo la regola del paragrafo 10.4. `math.type` restituisce quindi
`"integer"` e la tabella è una sequenza valida.

Il caso `{"a", nil, "c"}` merita un avvertimento: il costruttore assegna
`"c"` all’indice tre e lascia il due assente, quindi la funzione lo
riconosce come non sequenza. Ma `#` su quella tabella potrebbe
restituire uno oppure tre, e questa incertezza è esattamente ciò che la
definizione di sequenza serve a evitare.

**ES 10.5 — Copia superficiale contro profonda**

*Dimostra con un programma la differenza fra copia superficiale e
copia profonda su una struttura annidata di tre livelli. Poi
verifica che cosa succede quando la struttura contiene un
riferimento circolare, con entrambe le versioni.*

```lua
local function superficiale(t)
  local n = {}
  for k, v in pairs(t) do n[k] = v end
  return n
end

local function profonda(t, viste)
  if type(t) ~= "table" then return t end
  viste = viste or {}
  if viste[t] then return viste[t] end
  local n = {}
  viste[t] = n
  for k, v in pairs(t) do
    n[profonda(k, viste)] = profonda(v, viste)
  end
  return n
end

local originale = {
  nome = "radice",
  livello2 = {
    nome = "secondo",
    livello3 = {
      nome = "terzo",
      dati = {1, 2, 3},
    },
  },
}

local sup = superficiale(originale)
local pro = profonda(originale)

sup.livello2.livello3.nome = "MODIFICATO DA SUP"
print("dopo modifica via copia superficiale:")
print("  originale: "
  .. originale.livello2.livello3.nome)

pro.livello2.livello3.nome = "MODIFICATO DA PRO"
print("dopo modifica via copia profonda:")
print("  originale: "
  .. originale.livello2.livello3.nome)
print("  copia:     "
  .. pro.livello2.livello3.nome)

print()
print("--- con riferimento circolare ---")
local ciclica = {nome = "ciclo"}
ciclica.se_stessa = ciclica
ciclica.figlio = {padre = ciclica}

local supC = superficiale(ciclica)
print("superficiale: riuscita, ma se_stessa punta")
print("  all'originale: "
  .. tostring(supC.se_stessa == ciclica))

local proC = profonda(ciclica)
print("profonda: riuscita, se_stessa punta alla copia: "
  .. tostring(proC.se_stessa == proC))
print("  e non all'originale: "
  .. tostring(proC.se_stessa ~= ciclica))
print("  anche il figlio: "
  .. tostring(proC.figlio.padre == proC))
```

produce:

```text
dopo modifica via copia superficiale:
  originale: MODIFICATO DA SUP
dopo modifica via copia profonda:
  originale: MODIFICATO DA SUP
  copia:     MODIFICATO DA PRO
--- con riferimento circolare ---
superficiale: riuscita, ma se_stessa punta
  all'originale: true
profonda: riuscita, se_stessa punta alla copia: true
  e non all'originale: true
  anche il figlio: true
```

Fra le due sezioni l’output contiene una riga vuota, omessa qui.

La copia superficiale copia solo il primo livello: `sup.livello2` è
**la stessa tabella** dell’originale, quindi modificarla attraverso la
copia modifica l’originale.

Sul riferimento circolare la copia superficiale non fallisce, perché non
ricorre: si limita a copiare il riferimento. Ma il risultato non è una
copia indipendente.

La copia profonda **senza** la tabella `viste` andrebbe in ricorsione
infinita ed esaurirebbe lo stack. Con `viste` funziona, e il test
verifica la proprietà che conta: nella copia, i riferimenti circolari
puntano alla copia stessa e non all’originale.

**ES 10.6 — Unione con strategia di conflitto**

*Scrivi una funzione che unisca due tabelle in una terza, con una
strategia di risoluzione dei conflitti passata come parametro:
prendere il valore della prima, quello della seconda, oppure unire
ricorsivamente se entrambi sono tabelle.*

```lua
local STRATEGIE = {}

STRATEGIE.prima = function(a, b) return a end
STRATEGIE.seconda = function(a, b) return b end

STRATEGIE.unisci = function(a, b, ricorsiva)
  if type(a) == "table" and type(b) == "table" then
    return ricorsiva(a, b)
  end
  return b
end

STRATEGIE.errore = function(a, b, _, chiave)
  error("conflitto sulla chiave " .. tostring(chiave), 0)
end

local function unione(a, b, strategia)
  strategia = strategia or "seconda"
  local risolvi = STRATEGIE[strategia]
  if risolvi == nil then
    local nomi = {}
    for k in pairs(STRATEGIE) do nomi[#nomi + 1] = k end
    table.sort(nomi)
    return nil, "strategia sconosciuta: " .. strategia
      .. " (disponibili: " .. table.concat(nomi, ", ")
      .. ")"
  end

  local function fondi(x, y)
    local r = {}
    for k, v in pairs(x) do r[k] = v end
    for k, v in pairs(y) do
      if r[k] == nil then
        r[k] = v
      else
        r[k] = risolvi(r[k], v, fondi, k)
      end
    end
    return r
  end

  local ok, risultato = pcall(fondi, a, b)
  if not ok then return nil, risultato end
  return risultato
end

local function mostra(etichetta, t)
  if t == nil then
    print(etichetta .. ": errore")
    return
  end
  local chiavi = {}
  for k in pairs(t) do chiavi[#chiavi + 1] = k end
  table.sort(chiavi)
  local pezzi = {}
  for _, k in ipairs(chiavi) do
    local v = t[k]
    if type(v) == "table" then
      local sotto = {}
      local sk = {}
      for kk in pairs(v) do sk[#sk + 1] = kk end
      table.sort(sk)
      for _, kk in ipairs(sk) do
        sotto[#sotto + 1] = kk .. "=" .. tostring(v[kk])
      end
      pezzi[#pezzi + 1] = k .. "={"
        .. table.concat(sotto, ",") .. "}"
    else
      pezzi[#pezzi + 1] = k .. "=" .. tostring(v)
    end
  end
  print(etichetta .. ": " .. table.concat(pezzi, " "))
end

local A = {x = 1, y = 2, dentro = {p = 1, q = 2}}
local B = {y = 99, z = 3, dentro = {q = 88, r = 3}}

mostra("prima  ", unione(A, B, "prima"))
mostra("seconda", unione(A, B, "seconda"))
mostra("unisci ", unione(A, B, "unisci"))

local r, e = unione(A, B, "errore")
print("errore : " .. tostring(e))

print(unione(A, B, "inesistente"))
```

produce:

```text
prima  : dentro={p=1,q=2} x=1 y=2 z=3
seconda: dentro={q=88,r=3} x=1 y=99 z=3
unisci : dentro={p=1,q=88,r=3} x=1 y=99 z=3
errore : conflitto sulla chiave y
nil	strategia sconosciuta: inesistente
	(disponibili: errore, prima, seconda, unisci)
```

Quale chiave venga riportata nel messaggio di conflitto dipende
dall’ordine di `pairs`, che non è specificato: potrebbe essere `y` o
`dentro`. Se il messaggio deve essere riproducibile, occorre raccogliere
**tutti** i conflitti e ordinarli prima di segnalarli.

La strategia `unisci` è quella interessante: la sottotabella `dentro`
viene fusa ricorsivamente, conservando `p` da A e `r` da B, e risolvendo
`q` a favore di B. Le altre due la sostituiscono per intero.

Notate che la funzione `fondi` viene passata a sé stessa come argomento:
è il modo di permettere alla strategia di ricorrere senza che le
strategie conoscano la funzione esterna. Un’alternativa sarebbe
dichiarare `fondi` con `local function`, ma passarla esplicitamente
rende visibile la dipendenza.

**ES 10.7 — Il menù del ristorante**

*Costruisci la rappresentazione a tabelle di un menù di ristorante
con categorie, piatti, prezzi in centesimi e allergeni. Poi scrivi
tre funzioni: elenca tutti i piatti sotto un certo prezzo, elenca i
piatti che non contengono un dato allergene, calcola il prezzo medio
per categoria.*

```lua
local MENU = {
  {
    categoria = "Antipasti",
    piatti = {
      {nome = "Bruschette", prezzo = 600,
       allergeni = {"glutine"}},
      {nome = "Tagliere di salumi", prezzo = 1200,
       allergeni = {}},
      {nome = "Insalata di mare", prezzo = 1400,
       allergeni = {"crostacei", "molluschi"}},
    },
  },
  {
    categoria = "Primi",
    piatti = {
      {nome = "Spaghetti al pomodoro", prezzo = 900,
       allergeni = {"glutine"}},
      {nome = "Risotto ai funghi", prezzo = 1100,
       allergeni = {"latte"}},
      {nome = "Lasagne", prezzo = 1200,
       allergeni = {"glutine", "latte", "uova"}},
    },
  },
  {
    categoria = "Dolci",
    piatti = {
      {nome = "Tiramisu", prezzo = 700,
       allergeni = {"glutine", "latte", "uova"}},
      {nome = "Sorbetto", prezzo = 500,
       allergeni = {}},
    },
  },
}

local function tuttiIPiatti()
  local r = {}
  for _, c in ipairs(MENU) do
    for _, p in ipairs(c.piatti) do
      r[#r + 1] = {
        nome = p.nome, prezzo = p.prezzo,
        allergeni = p.allergeni, categoria = c.categoria,
      }
    end
  end
  return r
end

local function sottoPrezzo(massimo)
  local r = {}
  for _, p in ipairs(tuttiIPiatti()) do
    if p.prezzo <= massimo then r[#r + 1] = p end
  end
  table.sort(r, function(a, b)
    if a.prezzo ~= b.prezzo then
      return a.prezzo < b.prezzo
    end
    return a.nome < b.nome
  end)
  return r
end

local function senzaAllergene(allergene)
  allergene = allergene:lower()
  local r = {}
  for _, p in ipairs(tuttiIPiatti()) do
    local contiene = false
    for _, a in ipairs(p.allergeni) do
      if a:lower() == allergene then
        contiene = true
        break
      end
    end
    if not contiene then r[#r + 1] = p end
  end
  return r
end

local function mediaPerCategoria()
  local r = {}
  for _, c in ipairs(MENU) do
    local somma, quanti = 0, 0
    for _, p in ipairs(c.piatti) do
      somma = somma + p.prezzo
      quanti = quanti + 1
    end
    r[#r + 1] = {
      categoria = c.categoria,
      media = quanti > 0 and somma / quanti or 0,
      quanti = quanti,
    }
  end
  return r
end

print("--- sotto 10 euro ---")
for _, p in ipairs(sottoPrezzo(1000)) do
  print(string.format("  %-24s %6.2f  (%s)",
    p.nome, p.prezzo / 100, p.categoria))
end

print("--- senza glutine ---")
for _, p in ipairs(senzaAllergene("glutine")) do
  print(string.format("  %-24s %6.2f",
    p.nome, p.prezzo / 100))
end

print("--- prezzo medio per categoria ---")
for _, c in ipairs(mediaPerCategoria()) do
  print(string.format("  %-12s %6.2f (%d piatti)",
    c.categoria, c.media / 100, c.quanti))
end
```

La struttura scelta è una **sequenza di categorie**, ciascuna con una
sequenza di piatti. L’alternativa — un dizionario da nome di categoria a
elenco di piatti — renderebbe immediato l’accesso per nome ma perderebbe
l’ordine, che in un menù conta.

La ricerca per allergene è una scansione lineare dentro una scansione
lineare: accettabile su un menù, inadatta su un catalogo di migliaia di
prodotti, dove servirebbe l’insieme del Capitolo 12 o l’indice inverso.

Ogni ordinamento ha un criterio secondario, secondo la regola del
Capitolo 11.

**ES 10.8 — Chiavi numeriche e chiavi stringa**

*Verifica sperimentalmente l’affermazione del paragrafo 10.4 secondo
cui `t[2]` e `t[2.0]` sono la stessa chiave mentre `t[1]` e `t["1"]`
sono diverse. Scrivi un programma che lo dimostri e che stampi tutte
le chiavi effettivamente presenti con il loro tipo.*

```lua
local t = {}

t[1] = "intero uno"
t["1"] = "stringa uno"
t[2] = "intero due"
t[2.0] = "float due"
t[2.5] = "float due e mezzo"
t[0] = "zero"
t[-1] = "meno uno"

print("--- accessi diretti ---")
print("t[1]     = " .. tostring(t[1]))
print("t['1']   = " .. tostring(t["1"]))
print("t[2]     = " .. tostring(t[2]))
print("t[2.0]   = " .. tostring(t[2.0]))
print("t[2.5]   = " .. tostring(t[2.5]))

print()
print("--- tutte le chiavi presenti ---")
local chiavi = {}
for k in pairs(t) do
  chiavi[#chiavi + 1] = {chiave = k, tipo = type(k),
    sottotipo = math.type(k)}
end
table.sort(chiavi, function(a, b)
  if a.tipo ~= b.tipo then return a.tipo < b.tipo end
  return tostring(a.chiave) < tostring(b.chiave)
end)

for _, c in ipairs(chiavi) do
  print(string.format("  %-4s tipo=%-8s sottotipo=%-9s "
    .. "val=%s",
    tostring(c.chiave), c.tipo,
    tostring(c.sottotipo), tostring(t[c.chiave])))
end

print()
print("chiavi totali: " .. #chiavi)
print("t[2] e t[2.0] sono la stessa chiave? "
  .. tostring(t[2] == t[2.0]))
print("t[1] e t['1'] sono la stessa chiave? "
  .. tostring(t[1] == t["1"]))
```

produce:

```text
--- accessi diretti ---
t[1]     = intero uno
t['1']   = stringa uno
t[2]     = float due
t[2.0]   = float due
t[2.5]   = float due e mezzo
--- tutte le chiavi presenti ---
  -1   tipo=number  sottotipo=integer  val=meno uno
  0    tipo=number  sottotipo=integer  val=zero
  1    tipo=number  sottotipo=integer  val=intero uno
  2    tipo=number  sottotipo=integer  val=float due
  2.5  tipo=number  sottotipo=float    val=float due
                                           e mezzo
  1    tipo=string  sottotipo=nil      val=stringa uno

chiavi totali: 6
t[2] e t[2.0] sono la stessa chiave? true
t[1] e t['1'] sono la stessa chiave? false
```

Due comportamenti distinti, spesso confusi.

**`t[2]` e `t[2.0]` sono la stessa chiave.** Lua normalizza i float con
valore intero alla chiave intera corrispondente, quindi la seconda
assegnazione **sovrascrive** la prima. Nell’elenco delle chiavi compare
un solo due, con sottotipo intero.

**`t[1]` e `t["1"]` sono chiavi diverse.** Numero e stringa restano
distinti, e nell’elenco compaiono due voci che si stampano entrambe come
uno, distinguibili solo dal tipo.

`t[2.5]` resta un float, perché non ha valore intero.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
