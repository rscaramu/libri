# Capitolo 21 — Gestione degli errori: pcall, error, xpcall

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 20](capitolo-20.md) · [Indice](README.md) · [Capitolo 22 →](capitolo-22.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap21/`](../codice/cap21/).

---

**ES 21.4 — Validatore robusto sui confronti**

*Irrobustisci il validatore dell’ES 21.1 perché i controlli su minimo
e massimo non sollevino un errore quando il valore non è
confrontabile con la soglia, ma lo segnalino come problema. Aggiungi
un caso di test con una stringa dove lo schema prevede un numero
senza dichiararne il tipo.*

```lua
local function confrontabile(valore, soglia)
  local tv, ts = type(valore), type(soglia)
  if tv == "number" and ts == "number" then
    return true
  end
  if tv == "string" and ts == "string" then
    return true
  end
  return false
end

local function valida(dato, schema, percorso, errori)
  percorso = percorso or ""
  errori = errori or {}

  local function segnala(campo, messaggio)
    local completo = percorso
    if campo then
      completo = completo == "" and campo
        or (completo .. "." .. campo)
    end
    if completo == "" then completo = "(radice)" end
    errori[#errori + 1] = completo .. ": " .. messaggio
  end

  if type(dato) ~= "table" then
    segnala(nil, "atteso table, ricevuto " .. type(dato))
    return errori
  end

  for campo, regola in pairs(schema) do
    local valore = dato[campo]
    local sotto = percorso == "" and campo
      or (percorso .. "." .. campo)

    if valore == nil then
      if regola.obbligatorio then
        segnala(campo, "campo obbligatorio mancante")
      end

    elseif regola.tipo == "table" and regola.campi then
      valida(valore, regola.campi, sotto, errori)

    elseif regola.tipo and type(valore) ~= regola.tipo then
      segnala(campo, string.format(
        "atteso %s, ricevuto %s",
        regola.tipo, type(valore)))

    else
      if regola.minimo ~= nil then
        if not confrontabile(valore, regola.minimo) then
          segnala(campo, string.format(
            "non confrontabile con il minimo: %s "
            .. "contro %s", type(valore),
            type(regola.minimo)))
        elseif valore < regola.minimo then
          segnala(campo, string.format(
            "valore %s minore del minimo %s",
            tostring(valore), tostring(regola.minimo)))
        end
      end

      if regola.massimo ~= nil then
        if not confrontabile(valore, regola.massimo) then
          segnala(campo, string.format(
            "non confrontabile con il massimo: %s "
            .. "contro %s", type(valore),
            type(regola.massimo)))
        elseif valore > regola.massimo then
          segnala(campo, string.format(
            "valore %s maggiore del massimo %s",
            tostring(valore), tostring(regola.massimo)))
        end
      end

      if regola.ammessi then
        local trovato = false
        for _, a in ipairs(regola.ammessi) do
          if valore == a then trovato = true break end
        end
        if not trovato then
          segnala(campo, "valore non ammesso: "
            .. tostring(valore))
        end
      end
    end
  end

  for campo in pairs(dato) do
    if schema[campo] == nil then
      segnala(campo, "campo non previsto")
    end
  end

  table.sort(errori)
  return errori
end

local SCHEMA = {
  -- tipo NON dichiarato: e' il caso dell'esercizio
  quantita = {minimo = 1, massimo = 100},
  nome = {tipo = "string", obbligatorio = true},
}

local casi = {
  {nome = "ok", quantita = 50},
  {nome = "stringa", quantita = "molte"},
  {nome = "tabella", quantita = {}},
  {nome = "booleano", quantita = true},
  {nome = "fuori", quantita = 500},
}

for _, dato in ipairs(casi) do
  local errori = valida(dato, SCHEMA)
  print(string.format("%-10s -> %s", dato.nome,
    #errori == 0 and "ok"
      or table.concat(errori, "; ")))
end
```

produce:

```text
ok         -> ok
stringa    -> quantita: non confrontabile con il
              massimo: string contro number;
              quantita: non confrontabile con il
              minimo: string contro number
tabella    -> (le stesse due segnalazioni, con table)
booleano   -> (le stesse due segnalazioni, con boolean)
fuori      -> quantita: valore 500 maggiore del
              massimo 100
```

Notate che i valori non confrontabili producono **due** segnalazioni, una
per il minimo e una per il massimo: è coerente con la scelta di
accumulare tutti i problemi invece di fermarsi al primo.

Senza la funzione `confrontabile`, il secondo caso solleverebbe *attempt
to compare string with number* e il terzo *attempt to compare table with
number*: il validatore **fallirebbe** invece di segnalare, e chi lo usa
riceverebbe un errore invece di un elenco di problemi.

La funzione ammette due combinazioni: numero con numero e stringa con
stringa, che sono le uniche per cui `<` è definito in Lua senza
metametodi. Su tabelle con `__lt` il confronto sarebbe possibile, ma
ammetterlo richiederebbe di verificare la presenza del metametodo, e ne
vale la pena solo se lo schema deve trattare tipi personalizzati.

Notate che la segnalazione riporta **entrambi** i tipi coinvolti: sapere
che il valore è una stringa e la soglia un numero è ciò che permette di
capire se l’errore è nei dati o nello schema.

**ES 21.5 — Acquisizione e rilascio di più risorse**

*Scrivi una funzione `conRisorse` che accetti un elenco di funzioni
di acquisizione e di rilascio, esegua un’azione e garantisca il
rilascio in ordine inverso anche in caso di errore in una qualunque
delle acquisizioni. Verifica che un fallimento alla terza
acquisizione rilasci correttamente le prime due.*

```lua
local function conRisorse(specifiche, azione)
  local acquisite = {}
  local eventi = {}

  local function rilasciaTutte()
    for i = #acquisite, 1, -1 do
      local voce = acquisite[i]
      local ok, err = pcall(voce.rilascia, voce.valore)
      eventi[#eventi + 1] = string.format(
        "rilascio %s: %s", voce.nome,
        ok and "ok" or ("ERRORE " .. tostring(err)))
      acquisite[i] = nil
    end
  end

  for _, spec in ipairs(specifiche) do
    local ok, valore = pcall(spec.acquisisci)
    if not ok then
      eventi[#eventi + 1] = "acquisizione " .. spec.nome
        .. " FALLITA: " .. tostring(valore)
      rilasciaTutte()
      return nil, "acquisizione fallita: " .. spec.nome,
        eventi
    end
    eventi[#eventi + 1] = "acquisito " .. spec.nome
    acquisite[#acquisite + 1] = {
      nome = spec.nome,
      valore = valore,
      rilascia = spec.rilascia,
    }
  end

  local valori = {}
  for i, v in ipairs(acquisite) do
    valori[i] = v.valore
  end

  local risultati = table.pack(
    pcall(azione, table.unpack(valori, 1, #valori)))
  rilasciaTutte()

  if not risultati[1] then
    return nil, risultati[2], eventi
  end
  return table.unpack(risultati, 2, risultati.n)
end

local function spec(nome, fallisce)
  return {
    nome = nome,
    acquisisci = function()
      if fallisce then
        error("guasto nell'acquisizione di " .. nome, 0)
      end
      return "risorsa-" .. nome
    end,
    rilascia = function(v)
      -- niente da fare, il rilascio e' registrato
      -- dal chiamante
    end,
  }
end

print("=== tutto riesce ===")
local r, e, eventi = conRisorse(
  {spec("A"), spec("B"), spec("C")},
  function(a, b, c)
    return a .. "+" .. b .. "+" .. c
  end)
print("risultato: " .. tostring(r))
for _, ev in ipairs(eventi or {}) do print("  " .. ev) end

print()
print("=== la terza acquisizione fallisce ===")
local r2, e2, eventi2 = conRisorse(
  {spec("A"), spec("B"), spec("C", true), spec("D")},
  function() return "mai eseguita" end)
print("risultato: " .. tostring(r2) .. "  " .. tostring(e2))
for _, ev in ipairs(eventi2 or {}) do print("  " .. ev) end

print()
print("=== l'azione fallisce ===")
local r3, e3, eventi3 = conRisorse(
  {spec("A"), spec("B")},
  function() error("guasto nell'azione", 0) end)
print("risultato: " .. tostring(r3) .. "  " .. tostring(e3))
for _, ev in ipairs(eventi3 or {}) do print("  " .. ev) end
```

produce:

```text
=== tutto riesce ===
risultato: risorsa-A+risorsa-B+risorsa-C

=== la terza acquisizione fallisce ===
risultato: nil  acquisizione fallita: C
  acquisito A
  acquisito B
  acquisizione C FALLITA: guasto nell'acquisizione di C
  rilascio B: ok
  rilascio A: ok

=== l'azione fallisce ===
risultato: nil  guasto nell'azione
  acquisito A
  acquisito B
  rilascio B: ok
  rilascio A: ok
```

Il secondo caso è quello che l’esercizio chiedeva di verificare: il
fallimento della terza acquisizione rilascia **le prime due, in ordine
inverso**, e non tenta la quarta.

L’ordine inverso è la convenzione universale: le risorse acquisite per
ultime possono dipendere dalle precedenti, quindi vanno rilasciate per
prime.

Ogni rilascio è protetto da `pcall`: un rilascio che fallisce non deve
impedire quelli rimanenti, e viene registrato invece che ignorato.

Nel primo caso gli eventi non vengono restituiti, perché la funzione
restituisce i valori dell’azione: è un’asimmetria della firma che in una
libreria vera andrebbe risolta, per esempio restituendo sempre una
tabella di risultato.

**ES 21.6 — Costo di pcall e xpcall**

*Confronta con `os.clock` il costo di un milione di chiamate dirette,
di un milione dentro `pcall` e di un milione dentro `xpcall` con
gestore. Commenta se la differenza giustifica evitare la protezione
nei percorsi caldi.*

```lua
local N = 5000000

local function bersaglio(a, b)
  return a + b
end

local function gestore(m) return m end

local prove = {
  {"chiamata diretta", function()
    local s = 0
    for i = 1, N do s = s + bersaglio(i, 1) end
    return s
  end},
  {"pcall", function()
    local s = 0
    for i = 1, N do
      local ok, r = pcall(bersaglio, i, 1)
      s = s + r
    end
    return s
  end},
  {"pcall con closure", function()
    local s = 0
    for i = 1, N do
      local ok, r = pcall(function()
        return bersaglio(i, 1)
      end)
      s = s + r
    end
    return s
  end},
  {"xpcall con gestore", function()
    local s = 0
    for i = 1, N do
      local ok, r = xpcall(bersaglio, gestore, i, 1)
      s = s + r
    end
    return s
  end},
}

local riferimento
for _, p in ipairs(prove) do
  collectgarbage("collect")
  local inizio = os.clock()
  local r = p[2]()
  local durata = os.clock() - inizio
  riferimento = riferimento or durata
  print(string.format("%-24s %.4f s  %5.2fx",
    p[1], durata, durata / riferimento))
end
```

I rapporti tipici: `pcall` costa qualche volta la chiamata diretta,
`xpcall` un poco di più perché deve installare il gestore, e la versione
con la closure è la più lenta di tutte, perché crea un oggetto funzione a
ogni iterazione.

Il giudizio sull’opportunità di evitare la protezione nei percorsi caldi
dipende dal contesto. Su cinque milioni di chiamate la differenza è di
frazioni di secondo: se il vostro ciclo caldo esegue milioni di
operazioni **e** ciascuna è banale come un’addizione, la protezione pesa.
Se ciascuna operazione fa lavoro reale — legge un file, elabora una
stringa, interroga una struttura — il costo di `pcall` scompare nel
rumore.

La conclusione pratica è quella del paragrafo 21.4: non evitate `pcall`
per motivi di prestazioni, evitatelo perché catturare errori che non
sapete gestire nasconde i bug. Se poi il profilatore vi dice che pesa,
allora e solo allora toglietelo dal punto caldo.

Notate che la versione con la closure è inutilmente costosa: passare gli
argomenti direttamente a `pcall` evita l’allocazione.

**ES 21.7 — Gerarchia di errori a due livelli**

*Scrivi una gerarchia di errori a due livelli, con un tipo base e tre
sottotipi, e una funzione di verifica che riconosca sia il tipo
esatto sia l’appartenenza al tipo base. Dimostra il comportamento
con un chiamante che gestisce due sottotipi e lascia propagare il
terzo.*

```lua
local ErroreBase = {}
ErroreBase.__index = ErroreBase
ErroreBase.__nome = "Errore"
ErroreBase.__tostring = function(e)
  return string.format("[%s] %s", e.tipo, e.messaggio)
end

local function creaTipo(nome, base)
  local T = setmetatable({}, {__index = base})
  T.__index = T
  T.__nome = nome
  T.__tostring = ErroreBase.__tostring
  T.super = base

  T.nuovo = function(messaggio, dettagli)
    return setmetatable({
      tipo = nome,
      messaggio = messaggio,
      dettagli = dettagli,
    }, T)
  end

  return T
end

local ErroreApplicazione = creaTipo("Applicazione",
  ErroreBase)
local ErroreRete = creaTipo("Rete", ErroreApplicazione)
local ErroreDati = creaTipo("Dati", ErroreApplicazione)
local ErroreAutenticazione = creaTipo("Autenticazione",
  ErroreApplicazione)

local function eDiTipo(valore, tipo)
  if type(valore) ~= "table" then return false end
  local m = getmetatable(valore)
  while m do
    if m == tipo then return true end
    m = m.super
  end
  return false
end

local function operazione(quale)
  if quale == "rete" then
    error(ErroreRete.nuovo("connessione rifiutata",
      {host = "example.com"}))
  elseif quale == "dati" then
    error(ErroreDati.nuovo("record malformato",
      {riga = 42}))
  elseif quale == "auth" then
    error(ErroreAutenticazione.nuovo("token scaduto"))
  elseif quale == "generico" then
    error("errore non strutturato")
  end
  return "tutto bene"
end

for _, quale in ipairs({"ok", "rete", "dati", "auth",
    "generico"}) do
  local ok, e = pcall(operazione, quale)

  if ok then
    print(string.format("%-10s -> %s", quale, e))

  elseif eDiTipo(e, ErroreRete) then
    print(string.format("%-10s -> gestito come rete: "
      .. "%s (host %s)", quale, tostring(e),
      tostring(e.dettagli and e.dettagli.host)))

  elseif eDiTipo(e, ErroreDati) then
    print(string.format("%-10s -> gestito come dati: "
      .. "%s (riga %s)", quale, tostring(e),
      tostring(e.dettagli and e.dettagli.riga)))

  elseif eDiTipo(e, ErroreApplicazione) then
    print(string.format("%-10s -> non gestito qui, "
      .. "rilancio: %s", quale, tostring(e)))

  else
    print(string.format("%-10s -> errore esterno: %s",
      quale, tostring(e)))
  end
end

print()
print("verifiche di appartenenza:")
local e = ErroreRete.nuovo("x")
print("  Rete e' Rete:          "
  .. tostring(eDiTipo(e, ErroreRete)))
print("  Rete e' Applicazione:  "
  .. tostring(eDiTipo(e, ErroreApplicazione)))
print("  Rete e' Base:          "
  .. tostring(eDiTipo(e, ErroreBase)))
print("  Rete e' Dati:          "
  .. tostring(eDiTipo(e, ErroreDati)))
```

produce:

```text
ok         -> tutto bene
rete       -> gestito come rete: [Rete] connessione
              rifiutata (host example.com)
dati       -> gestito come dati: [Dati] record
              malformato (riga 42)
auth       -> non gestito qui, rilancio:
              [Autenticazione] token scaduto
generico   -> errore esterno: ...: errore non
              strutturato

verifiche di appartenenza:
  Rete e' Rete:          true
  Rete e' Applicazione:  true
  Rete e' Base:          true
  Rete e' Dati:          false
```

Il chiamante gestisce due sottotipi specifici, riconosce il terzo come
appartenente alla famiglia e lo lascia propagare, e distingue infine gli
errori non strutturati provenienti da altre parti del programma.

`eDiTipo` risale la catena `super`, quindi un errore di rete risulta
anche di tipo applicazione e di tipo base: è il comportamento atteso da
una gerarchia.

Il `__tostring` è ereditato da `ErroreBase` e assegnato esplicitamente a
ogni tipo: senza, un errore non catturato che arrivasse all’interprete
produrrebbe *error object is not a string*.

**ES 21.8 — Convertire fra le due convenzioni**

*Scrivi una funzione che converta qualunque funzione dalla
convenzione con `error` a quella con `nil` più messaggio e una che
faccia il contrario. Verifica che entrambe conservino tutti i valori
di ritorno, compresi i `nil` intermedi.*

```lua
local function aRisultato(f)
  return function(...)
    local r = table.pack(pcall(f, ...))
    if not r[1] then
      return nil, r[2]
    end
    return table.unpack(r, 2, r.n)
  end
end

local function aErrore(f, messaggioPredefinito)
  return function(...)
    local r = table.pack(f(...))
    if r.n >= 1 and r[1] == nil then
      local messaggio = r[2]
        or messaggioPredefinito
        or "operazione fallita"
      error(messaggio, 2)
    end
    return table.unpack(r, 1, r.n)
  end
end

-- Funzioni di prova
local function conError(a, b)
  if type(a) ~= "number" then
    error("primo argomento non numerico", 2)
  end
  return a + b, a - b, a * b
end

local function conNil(a, b)
  if type(a) ~= "number" then
    return nil, "primo argomento non numerico"
  end
  return a + b, a - b, a * b
end

local function conNilIntermedi()
  return 1, nil, 3, nil
end

print("=== aRisultato su una funzione con error ===")
local sicura = aRisultato(conError)
print(sicura(10, 3))
print(sicura("x", 3))

print()
print("=== aErrore su una funzione con nil ===")
local esplosiva = aErrore(conNil)
print(esplosiva(10, 3))
print(pcall(esplosiva, "x", 3))

print()
print("=== conservazione dei nil intermedi ===")
local a = table.pack(conNilIntermedi())
print("originale: n=" .. a.n)

local b = table.pack(aRisultato(conNilIntermedi)())
print("aRisultato: n=" .. b.n)
for i = 1, b.n do
  io.write("[", tostring(b[i]), "]")
end
print()

local c = table.pack(aErrore(function()
  return 1, nil, 3, nil
end)())
print("aErrore: n=" .. c.n)
for i = 1, c.n do
  io.write("[", tostring(c[i]), "]")
end
print()

print()
print("=== composizione: andata e ritorno ===")
local andata = aRisultato(conError)
local ritorno = aErrore(andata)
print(ritorno(10, 3))
print(pcall(ritorno, "x", 3))
```

produce:

```text
=== aRisultato su una funzione con error ===
13	7	30
nil	primo argomento non numerico

=== aErrore su una funzione con nil ===
13	7	30
false	primo argomento non numerico

=== conservazione dei nil intermedi ===
originale: n=4
aRisultato: n=4
[1][nil][3][nil]
aErrore: n=4
[1][nil][3][nil]

=== composizione: andata e ritorno ===
13	7	30
false	primo argomento non numerico
```

La conservazione dei valori multipli, compresi i `nil` intermedi e
finali, è la parte tecnicamente delicata: richiede `table.pack` e
`table.unpack` con gli estremi espliciti, perché `#` su una tabella con
buchi non è affidabile.

`aErrore` ha un difetto da dichiarare: distingue il fallimento
dall’assenza di risultati guardando **solo** il primo valore. Una
funzione che restituisca legittimamente `nil` come primo valore in caso
di successo verrebbe interpretata come fallita. È un limite intrinseco
della convenzione, non dell’implementazione.

La composizione andata e ritorno restituisce il comportamento originale,
il che è la verifica che le due funzioni siano davvero inverse.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
