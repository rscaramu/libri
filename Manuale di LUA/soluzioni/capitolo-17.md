# Capitolo 17 — La libreria string e i pattern di Lua

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 16](capitolo-16.md) · [Indice](README.md) · [Capitolo 18 →](capitolo-18.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap17/`](../codice/cap17/).

---

**ES 17.4 — Validazione ancorata di un indirizzo**

*Scrivi una funzione che validi un indirizzo di posta elettronica
ancorando il pattern a entrambe le estremità, e confrontala con la
versione estrattiva dell’ES 17.2 su almeno dieci casi, compresi
quelli malformati.*

```lua
local function valida(indirizzo)
  if type(indirizzo) ~= "string" then
    return false, "non e' una stringa"
  end
  if #indirizzo > 254 then
    return false, "troppo lungo"
  end

  local locale, dominio =
    indirizzo:match("^([^@]+)@([^@]+)$")
  if locale == nil then
    return false, "serve esattamente una chiocciola"
  end

  if #locale > 64 then
    return false, "parte locale troppo lunga"
  end
  if not locale:match("^[%w%.%-_%+]+$") then
    return false, "caratteri non ammessi prima della @"
  end
  if locale:match("^%.") or locale:match("%.$")
     or locale:match("%.%.") then
    return false, "punti mal posizionati nella parte "
      .. "locale"
  end

  if not dominio:match("^[%w%.%-]+$") then
    return false, "caratteri non ammessi nel dominio"
  end
  if dominio:match("^[%.%-]") or dominio:match("[%.%-]$")
     or dominio:match("%.%.") then
    return false, "punti o trattini mal posizionati"
  end

  local etichetta, tld = dominio:match("^(.+)%.(%a+)$")
  if tld == nil then
    return false, "manca il dominio di primo livello"
  end
  if #tld < 2 then
    return false, "dominio di primo livello troppo corto"
  end
  if etichetta == "" then
    return false, "dominio incompleto"
  end

  return true
end

local casi = {
  {"anna.rossi@example.com", true},
  {"a@b.co", true},
  {"nome+tag@example.co.uk", true},
  {"nome_cognome@sotto.dominio.it", true},
  {"dario@example..com", false},
  {"dario@@example.com", false},
  {"@example.com", false},
  {"dario@", false},
  {"dario@example", false},
  {".dario@example.com", false},
  {"dario.@example.com", false},
  {"da..rio@example.com", false},
  {"dario@-example.com", false},
  {"dario@example.c", false},
  {"dario spazio@example.com", false},
}

for _, c in ipairs(casi) do
  local ok, motivo = valida(c[1])
  print(string.format("%-30s %-5s %-5s %s",
    c[1], tostring(ok), tostring(c[2]),
    ok == c[2] and "ok" or ("ERRORE: "
      .. tostring(motivo))))
end
```

La differenza rispetto alla versione estrattiva dell’ES 17.2 è
sostanziale: qui il pattern è **ancorato a entrambe le estremità** con
`^` e `$`, quindi la stringa intera deve corrispondere. Non si estrae
una porzione plausibile da un testo qualunque: si verifica che tutto il
testo sia un indirizzo.

Il pattern `"^([^@]+)@([^@]+)$"` garantisce da solo che ci sia
esattamente una chiocciola: `[^@]+` non può contenerne, quindi due
chiocciole non corrispondono affatto.

I controlli restanti sono in Lua e non nel pattern, perché la notazione
non sa esprimerli: punti consecutivi, punti agli estremi, lunghezze
massime. È la divisione del lavoro descritta nel paragrafo 17.9.

Va detto che nessuna di queste validazioni è **completa**: la
specifica reale degli indirizzi di posta elettronica ammette forme
esotiche che questo codice rifiuta. Per l’uso pratico va benissimo, e
l’unica verifica davvero conclusiva resta l’invio di un messaggio di
conferma.

**ES 17.5 — Parole duplicate consecutive**

*Scrivi una funzione che, dato un testo, restituisca tutte le parole
che compaiono duplicate consecutivamente, sfruttando i riferimenti
alle catture. Verifica che riconosca «il il» ma non «il gatto il».*

```lua
local function duplicate(testo)
  local trovate = {}
  local posizione = 1

  while true do
    local inizio, fine, prima, seconda =
      testo:find("()(%a+)%s+(%a+)", posizione)
    if inizio == nil then break end

    local pos, uno, due =
      testo:match("()(%a+)%s+(%a+)", posizione)
    if pos == nil then break end

    if uno:lower() == due:lower() then
      trovate[#trovate + 1] = {
        parola = uno, posizione = pos,
      }
    end

    -- Avanziamo di UNA parola, non di due,
    -- per cogliere "il il il"
    local dopo = testo:find("%a+", pos + #uno)
    if dopo == nil then break end
    posizione = dopo
  end

  return trovate
end

local casi = {
  "il il gatto",
  "il gatto il",
  "il il il cane",
  "la La casa",
  "una parola sola",
  "fine   fine con spazi",
  "",
}

for _, t in ipairs(casi) do
  local r = duplicate(t)
  local pezzi = {}
  for _, d in ipairs(r) do
    pezzi[#pezzi + 1] = d.parola .. "@" .. d.posizione
  end
  print(string.format("%-26s -> %s",
    "[" .. t .. "]",
    #pezzi > 0 and table.concat(pezzi, " ")
      or "nessuna"))
end
```

produce:

```text
[il il gatto]              -> il@1
[il gatto il]              -> nessuna
[il il il cane]            -> il@1 il@4
[la La casa]               -> la@1
[una parola sola]          -> nessuna
[fine   fine con spazi]    -> fine@1
[]                         -> nessuna
```

L’esercizio suggeriva i riferimenti alle catture, e la forma
`"(%a+)%s+%1"` funziona ma ha un limite: `%1` corrisponde **esattamente**
al testo catturato, quindi non riconosce «la La» con maiuscola diversa.

La versione qui presentata cattura le due parole separatamente e le
confronta in Lua dopo aver normalizzato il caso, il che è più flessibile.

Il dettaglio che conta è l’avanzamento: dopo aver esaminato una coppia si
riparte dalla **seconda** parola, non da dopo la coppia. Altrimenti «il
il il» produrrebbe una sola segnalazione invece di due.

**ES 17.6 — Estrarre chiamate con `%b`**

*Usa `%b` per scrivere una funzione che estragga il contenuto di
tutte le chiamate di funzione in un frammento di codice, gestendo
correttamente le chiamate annidate. Confronta il risultato con
quello che otterresti usando `%((.-)%)` e `%((.*)%)`.*

```lua
local CODICE = [[
print(a, f(b, c), d)
risultato = calcola(x + g(y), z)
vuota()
annidata(f(g(h(1))))
]]

local function conBilanciate(testo)
  local r = {}
  for nome, dentro in testo:gmatch("(%a[%w_]*)(%b())") do
    r[#r + 1] = nome .. " -> "
      .. dentro:sub(2, -2)
  end
  return r
end

local function conNonAvido(testo)
  local r = {}
  for nome, dentro in testo:gmatch("(%a[%w_]*)%((.-)%)") do
    r[#r + 1] = nome .. " -> " .. dentro
  end
  return r
end

local function conAvido(testo)
  local r = {}
  for nome, dentro in testo:gmatch("(%a[%w_]*)%((.*)%)") do
    r[#r + 1] = nome .. " -> " .. dentro
  end
  return r
end

local function mostra(etichetta, elenco)
  print("=== " .. etichetta .. " ===")
  for _, v in ipairs(elenco) do print("  " .. v) end
end

mostra("con %b()", conBilanciate(CODICE))
mostra("con %((.-)%) non avido", conNonAvido(CODICE))
mostra("con %((.*)%) avido", conAvido(CODICE))
```

produce:

```text
=== con %b() ===
  print -> a, f(b, c), d
  calcola -> x + g(y), z
  vuota ->
  annidata -> f(g(h(1)))
=== con %((.-)%) non avido ===
  print -> a, f(b, c
  calcola -> x + g(y
  vuota ->
  annidata -> f(g(h(1
=== con %((.*)%) avido ===
  print -> a, f(b, c), d)
risultato = calcola(x + g(y), z)
vuota()
annidata(f(g(h(1)))
```

`%b()` è l’unico dei tre che sia **sempre** corretto: conta le
parentesi e si ferma quando il bilancio torna a zero. Restituisce le
quattro chiamate di primo livello, con il loro contenuto completo; le
chiamate annidate non compaiono perché `gmatch` riprende dopo la
corrispondenza, che ingloba l’intero gruppo bilanciato. Per trovare
anche le annidate occorre applicare la funzione ricorsivamente al
contenuto estratto.

La versione **non avida** si ferma alla **prima** parentesi chiusa,
quindi tronca ogni chiamata che ne contenga un’altra: `print` produce
`a, f(b, c` invece del testo completo.

La versione **avida** è il caso peggiore, e mostra un dettaglio che
sorprende chi arriva dalle espressioni regolari: in Lua il punto
**corrisponde anche all’a capo**. Non esiste una modalità «multiriga» da
attivare, perché il comportamento è sempre quello. Il risultato è che
`(.*)` si mangia tutto il testo fino all’ultima parentesi chiusa
dell’intero documento, producendo una singola corrispondenza mostruosa
che attraversa quattro righe.

È la dimostrazione più chiara del perché `%b` esista.

**ES 17.7 — Date in formati diversi**

*Scrivi una funzione che divida una data scritta in uno qualunque di
questi formati — con trattini, barre o punti, con l’anno prima o
dopo — restituendo giorno, mese e anno normalizzati. Segnala i casi
ambigui.*

```lua
local FORMATI = {
  {nome = "AAAA-MM-GG",
   pattern = "^(%d%d%d%d)([%-/%.])(%d%d?)%2(%d%d?)$",
   ordine = "amg"},
  {nome = "GG-MM-AAAA",
   pattern = "^(%d%d?)([%-/%.])(%d%d?)%2(%d%d%d%d)$",
   ordine = "gma"},
}

local GIORNI_MESE = {31, 28, 31, 30, 31, 30,
                     31, 31, 30, 31, 30, 31}

local function bisestile(anno)
  return (anno % 4 == 0 and anno % 100 ~= 0)
    or anno % 400 == 0
end

local function valida(g, m, a)
  if m < 1 or m > 12 then
    return false, "mese fuori intervallo"
  end
  local massimo = GIORNI_MESE[m]
  if m == 2 and bisestile(a) then massimo = 29 end
  if g < 1 or g > massimo then
    return false, "giorno fuori intervallo"
  end
  return true
end

local function analizza(testo)
  if type(testo) ~= "string" then
    return nil, "atteso una stringa"
  end
  testo = testo:match("^%s*(.-)%s*$")

  for _, f in ipairs(FORMATI) do
    local x, _, y, z = testo:match(f.pattern)
    if x then
      local g, m, a
      if f.ordine == "amg" then
        a, m, g = tonumber(x), tonumber(y), tonumber(z)
      else
        g, m, a = tonumber(x), tonumber(y), tonumber(z)
      end

      local ok, motivo = valida(g, m, a)
      if not ok then return nil, motivo end

      local ambigua = false
      if f.ordine == "gma" and g <= 12 and m <= 12
         and g ~= m then
        ambigua = true
      end

      return {
        giorno = g, mese = m, anno = a,
        formato = f.nome,
        ambigua = ambigua,
        iso = string.format("%04d-%02d-%02d", a, m, g),
      }
    end
  end

  return nil, "formato non riconosciuto"
end

local casi = {
  "2026-08-07", "2026/08/07", "2026.08.07",
  "07-08-2026", "07/08/2026", "7/8/2026",
  "29-02-2024", "29-02-2026",
  "31-04-2026", "13/13/2026",
  "2026-08-07 ", "07-08/2026", "ciao",
}

for _, c in ipairs(casi) do
  local r, errore = analizza(c)
  if r then
    print(string.format("%-14s -> %s  [%s]%s",
      c, r.iso, r.formato,
      r.ambigua and "  AMBIGUA" or ""))
  else
    print(string.format("%-14s -> %s", c, errore))
  end
end
```

produce:

```text
2026-08-07     -> 2026-08-07  [AAAA-MM-GG]
2026/08/07     -> 2026-08-07  [AAAA-MM-GG]
2026.08.07     -> 2026-08-07  [AAAA-MM-GG]
07-08-2026     -> 2026-08-07  [GG-MM-AAAA]  AMBIGUA
07/08/2026     -> 2026-08-07  [GG-MM-AAAA]  AMBIGUA
7/8/2026       -> 2026-08-07  [GG-MM-AAAA]  AMBIGUA
29-02-2024     -> 2024-02-29  [GG-MM-AAAA]
29-02-2026     -> giorno fuori intervallo
31-04-2026     -> giorno fuori intervallo
13/13/2026     -> mese fuori intervallo
2026-08-07     -> 2026-08-07  [AAAA-MM-GG]
07-08/2026     -> formato non riconosciuto
ciao           -> formato non riconosciuto
```

Tre elementi tecnici.

Il riferimento alla cattura `%2` impone che il **secondo separatore sia
uguale al primo**: `07-08/2026` viene correttamente rifiutato. È l’uso
del riferimento visto nel paragrafo 17.6.

La **segnalazione di ambiguità** è la parte richiesta dall’esercizio:
`07-08-2026` può essere il sette agosto o il primo luglio a seconda della
convenzione, e il programma non può deciderlo. Segnalarlo è più onesto
che scegliere in silenzio.

La validazione del giorno tiene conto dei mesi di lunghezza diversa e
degli anni bisestili, quindi `29-02-2024` è accettata e `29-02-2026` no.

**ES 17.8 — Parola intera con `%f`**

*Usa `%f` per scrivere una funzione che conti le occorrenze di una
parola come parola intera, e dimostra su un testo in cui la stessa
sequenza compare anche come parte di parole più lunghe.*

```lua
local function contaParolaIntera(testo, parola)
  local pattern = "%f[%w]" .. parola:gsub(
    "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1") .. "%f[%W]"
  local _, quante = testo:gsub(pattern, "")
  return quante
end

local function contaIngenuo(testo, parola)
  local _, quante = testo:gsub(parola, "")
  return quante
end

local TESTO = [[
Il gatto e il gattone giocano. Il gattino dorme.
Un gatto, due gatti, mille gattoni.
gatto
(gatto) [gatto] "gatto"
grattacielo non contiene la parola.
]]

for _, parola in ipairs({"gatto", "il", "gatti"}) do
  print(string.format("%-8s intera=%d  ingenuo=%d",
    parola,
    contaParolaIntera(TESTO, parola),
    contaIngenuo(TESTO, parola)))
end
```

produce:

```text
gatto    intera=6  ingenuo=8
il       intera=1  ingenuo=2
gatti    intera=1  ingenuo=2
```

La differenza è netta. Per «gatto» il conteggio ingenuo include le
occorrenze dentro «gattone», «gattino» e «gattoni»; quello con frontiera
conta solo le sei occorrenze come parola autonoma, comprese quelle fra
parentesi e virgolette.

Per «il» il conteggio ingenuo trova due occorrenze perché la sequenza
compare anche dentro «mille», mentre la parola autonoma «il» compare una
volta sola con la minuscola: le altre sono «Il» con la maiuscola, e il
confronto è sensibile al caso.

Il costrutto `%f[%w]parola%f[%W]` richiede una posizione in cui si passa
da un carattere non alfanumerico a uno alfanumerico prima della parola, e
il contrario dopo. All’inizio e alla fine della stringa Lua immagina un
carattere nullo, che appartiene a `%W`: per questo la riga che contiene
solo «gatto» viene contata.

La protezione della parola con la sostituzione dei caratteri magici è
necessaria: cercare `c++` o `a.b` senza protezione produrrebbe risultati
assurdi.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
