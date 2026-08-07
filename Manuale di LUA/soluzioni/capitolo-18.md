# Capitolo 18 — Espressioni regolari a modo di Lua: pattern avanzati e gsub

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 17](capitolo-17.md) · [Indice](README.md) · [Capitolo 19 →](capitolo-19.md)

I 6 sorgenti eseguibili di questo capitolo sono in
[`codice/cap18/`](../codice/cap18/).

---

**ES 18.4 — Dividi robusta**

*Scrivi una funzione `dividi` che accetti un separatore di lunghezza
qualunque, anche contenente caratteri magici, e gestisca
correttamente i campi vuoti, il separatore all’inizio e alla fine, e
la stringa vuota. Verificala su almeno dieci casi.*

```lua
local function proteggi(s)
  return (s:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1"))
end

local function dividi(s, separatore)
  if type(s) ~= "string" then
    return nil, "primo argomento non e' una stringa"
  end
  separatore = separatore or ","
  if type(separatore) ~= "string" or separatore == "" then
    return nil, "separatore non valido"
  end

  local pezzi = {}
  local pattern = proteggi(separatore)
  local posizione = 1

  while true do
    local inizio, fine = s:find(pattern, posizione)
    if inizio == nil then
      pezzi[#pezzi + 1] = s:sub(posizione)
      break
    end
    pezzi[#pezzi + 1] = s:sub(posizione, inizio - 1)
    posizione = fine + 1
  end

  return pezzi
end

local casi = {
  {"a,b,c", ",", {"a", "b", "c"}},
  {"", ",", {""}},
  {"abc", ",", {"abc"}},
  {",a", ",", {"", "a"}},
  {"a,", ",", {"a", ""}},
  {",", ",", {"", ""}},
  {"a,,b", ",", {"a", "", "b"}},
  {"a--b--c", "--", {"a", "b", "c"}},
  {"a.b.c", ".", {"a", "b", "c"}},
  {"a+b", "+", {"a", "b"}},
  {"a%b", "%", {"a", "b"}},
  {"aXXbXXc", "XX", {"a", "b", "c"}},
}

for _, c in ipairs(casi) do
  local r = dividi(c[1], c[2])
  local uguale = #r == #c[3]
  if uguale then
    for i = 1, #r do
      if r[i] ~= c[3][i] then uguale = false end
    end
  end
  print(string.format("%-12s sep=%-4s -> [%s] %s",
    "[" .. c[1] .. "]", "[" .. c[2] .. "]",
    table.concat(r, "|"),
    uguale and "ok" or "ERRORE"))
end

print(dividi("abc", ""))
print(dividi(42, ","))
```

I casi che distinguono un’implementazione corretta da una ingenua.

La **stringa vuota** produce una sequenza con un elemento vuoto, non una
sequenza vuota: è la convenzione coerente con «zero separatori danno un
campo».

Il **separatore all’inizio** e **alla fine** producono campi vuoti alle
estremità, che vanno conservati: chi analizza un CSV con un campo finale
vuoto deve poterlo distinguere da una riga più corta.

Il **separatore multicarattere** funziona perché la ricerca usa `find`
con il pattern protetto, non un insieme di caratteri.

I **caratteri magici** come punto, più e percento sono protetti, quindi
si comportano letteralmente. Senza protezione, dividere su `.` spezzerebbe
a ogni carattere.

**ES 18.5 — Da printf a segnaposto con nome**

*Scrivi una funzione che converta un testo con segnaposto in stile
`printf` — `%s`, `%d` e simili — nella notazione con nomi `${nome}`,
dato l’elenco ordinato dei nomi. Gestisci il `%%` letterale.*

```lua
local function converti(modello, nomi)
  if type(modello) ~= "string" then
    return nil, "atteso una stringa"
  end
  nomi = nomi or {}

  local indice = 0
  local usati = {}
  local errore = nil

  local risultato = modello:gsub("%%(.)",
    function(carattere)
      if carattere == "%" then
        -- La funzione di sostituzione restituisce
        -- testo LETTERALE: qui va un solo percento
        return "%"
      end
      if not carattere:match("[diufeEgGsxXcoq]") then
        errore = errore or ("segnaposto sconosciuto: %"
          .. carattere)
        return nil
      end
      indice = indice + 1
      local nome = nomi[indice]
      if nome == nil then
        errore = errore or string.format(
          "manca il nome per il segnaposto %d", indice)
        return nil
      end
      usati[#usati + 1] = nome
      return "${" .. nome .. "}"
    end)

  if errore then return nil, errore end
  return risultato, usati, indice
end

local casi = {
  {"Ciao %s, hai %d anni", {"nome", "eta"}},
  {"Totale: %.2f euro (%d%%)", {"totale", "sconto"}},
  {"%s", {"solo"}},
  {"nessun segnaposto", {}},
  {"100%% sicuro", {}},
  {"%s e %s", {"uno"}},
  {"%z sconosciuto", {"x"}},
}

for _, c in ipairs(casi) do
  local r, usati, quanti = converti(c[1], c[2])
  if r then
    print(string.format("%-28s -> %s  (%d)",
      "[" .. c[1] .. "]", r, quanti))
  else
    print(string.format("%-28s -> ERRORE: %s",
      "[" .. c[1] .. "]", usati))
  end
end
```

produce:

```text
[Ciao %s, hai %d anni]       -> Ciao ${nome}, hai
                                ${eta} anni  (2)
[Totale: %.2f euro (%d%%)]   -> ERRORE: segnaposto
                                sconosciuto: %.
[%s]                         -> ${solo}  (1)
[nessun segnaposto]          -> nessun segnaposto  (0)
[100%% sicuro]               -> 100% sicuro  (0)
[%s e %s]                    -> ERRORE: manca il nome
                                per il segnaposto 2
[%z sconosciuto]             -> ERRORE: segnaposto
                                sconosciuto: %z
```

Il secondo caso rivela un **limite dell’implementazione**: il pattern
`"%%(.)"` cattura un solo carattere dopo il percento, quindi non gestisce
i segnaposto con modificatori come `%.2f` o `%-10s`.

La correzione richiede un pattern più ampio:

```lua
local pattern = "%%([%-%+ #0]*%d*%.?%d*)([diufeEgGsxXcoq%%])"
```

che cattura separatamente i modificatori e la lettera finale. È il tipo
di scoperta che solo l’esecuzione produce, ed è la ragione per cui i casi
di prova vanno scelti apposta per rompere il codice.

Il `%%` letterale è gestito correttamente e non consuma un nome, come
deve.

**ES 18.6 — La corrispondenza vuota, tre casi**

*Dimostra con almeno tre esempi la trappola della corrispondenza
vuota, e per ciascuno mostra la correzione. Includi un caso con
`gmatch` e uno con `gsub`.*

```lua
print("=== Caso 1: gsub con pattern che accetta il "
  .. "vuoto ===")
print("(\"abc\"):gsub(\"%d*\", \"-\")")
local r1, n1 = ("abc"):gsub("%d*", "-")
print("  risultato: [" .. r1 .. "] sostituzioni: " .. n1)
print("  atteso: solo le cifre sostituite, ma non ce "
  .. "ne sono")
local r1c, n1c = ("abc"):gsub("%d+", "-")
print("  corretto con +: [" .. r1c .. "] " .. n1c)

print()
print("=== Caso 2: gmatch che produce corrispondenze "
  .. "vuote ===")
print("for w in (\"abc\"):gmatch(\"%d*\") do ...")
local quante = 0
for w in ("abc"):gmatch("%d*") do
  quante = quante + 1
  io.write("[", w, "]")
end
print("  iterazioni: " .. quante
  .. " (attese 0: non ci sono cifre)")
local quante2 = 0
for w in ("abc"):gmatch("%d+") do
  quante2 = quante2 + 1
end
print("  corretto con +: " .. quante2)

print()
print("=== Caso 3: divisione che produce campi "
  .. "fantasma ===")
local pezzi = {}
for pezzo in ("a,b"):gmatch("[^,]*") do
  pezzi[#pezzi + 1] = "[" .. pezzo .. "]"
end
print("  con *: " .. table.concat(pezzi, " ")
  .. "  (" .. #pezzi .. " pezzi)")

local pezzi2 = {}
for pezzo in ("a,,b"):gmatch("[^,]*") do
  pezzi2[#pezzi2 + 1] = "[" .. pezzo .. "]"
end
print("  con campo vuoto: " .. table.concat(pezzi2, " ")
  .. "  (" .. #pezzi2 .. " pezzi)")

local pezzi3 = {}
for pezzo in ("a,,b"):gmatch("[^,]+") do
  pezzi3[#pezzi3 + 1] = "[" .. pezzo .. "]"
end
print("  con +: " .. table.concat(pezzi3, " ")
  .. "  (perde il campo vuoto!)")
print("  la soluzione corretta e' find in un ciclo,")
print("  come nell'ES 18.4")
```

produce:

```text
=== Caso 1: gsub con pattern che accetta il vuoto ===
("abc"):gsub("%d*", "-")
  risultato: [-a-b-c-] sostituzioni: 4
  atteso: solo le cifre sostituite, ma non ce ne sono
  corretto con +: [abc] 0

=== Caso 2: gmatch che produce corrispondenze vuote ===
for w in ("abc"):gmatch("%d*") do ...
[][][][]  iterazioni: 4 (attese 0: non ci sono cifre)
  corretto con +: 0

=== Caso 3: divisione che produce campi fantasma ===
  con *: [a] [b]  (2 pezzi)
  con campo vuoto: [a] [] [b]  (3 pezzi)
  con +: [a] [b]  (perde il campo vuoto!)
  la soluzione corretta e' find in un ciclo,
  come nell'ES 18.4
```

I primi due casi mostrano il fenomeno in forma pura: un pattern che
accetta il vuoto produce una corrispondenza in ogni posizione in cui non
trova nulla, quindi quattro sostituzioni e quattro iterazioni su una
stringa di tre caratteri che non contiene cifre.

Il terzo caso è quello più istruttivo, perché in **Lua 5.4 nessuno dei
due quantificatori risolve**, ma per ragioni opposte.

Con `*` si ottengono due pezzi su `a,b`, il che è corretto: la
soppressione delle corrispondenze vuote adiacente a una precedente,
introdotta nella 5.4 e descritta nel paragrafo 18.3, elimina i campi
fantasma. Su `a,,b` si ottengono tre pezzi, compreso quello vuoto in
mezzo: anche questo corretto. Sembra funzionare.

Con `+` i campi vuoti legittimi spariscono: `a,,b` produce due pezzi
invece di tre.

Il problema del `*` emerge altrove: sulle versioni precedenti alla 5.4 e
su LuaJIT produce i campi fantasma. Un codice che dipende dalla
soppressione delle corrispondenze vuote **non è portabile**, ed è la
ragione per cui la divisione corretta non si fa con `gmatch` ma con
`find` in un ciclo, come nella funzione dell’ES 18.4.

**ES 18.7 — Proteggere la stringa di sostituzione**

*Scrivi una funzione che protegga una stringa perché possa essere
usata come **sostituzione** in `gsub`, e dimostra con un esempio
concreto l’errore che si ottiene senza protezione quando il testo
contiene un segno di percentuale.*

```lua
local function proteggiSostituzione(s)
  return (s:gsub("%%", "%%%%"))
end

local TESTO = "Lo sconto e' del VALORE."

local sostituzioni = {
  "20%",
  "50%% (doppio)",
  "%1 riferimento",
  "%0 intera",
  "normale",
}

for _, sost in ipairs(sostituzioni) do
  io.write(string.format("%-18s ", "[" .. sost .. "]"))

  local ok, risultato = pcall(function()
    return (TESTO:gsub("VALORE", sost))
  end)

  if ok then
    io.write("senza protezione: " .. risultato)
  else
    io.write("senza protezione: ERRORE")
  end
  io.write("\n")

  io.write(string.rep(" ", 19))
  local protetto = TESTO:gsub("VALORE",
    proteggiSostituzione(sost))
  io.write("con protezione:   " .. protetto .. "\n")
end

print()
print("Alternativa: usare una funzione, che non")
print("interpreta nulla.")
local conFunzione = TESTO:gsub("VALORE", function()
  return "20%"
end)
print("  " .. conFunzione)
```

produce:

```text
[20%]              senza protezione: ERRORE
                   con protezione:   Lo sconto e' del 20%.
[50%% (doppio)]    senza protezione: Lo sconto e' del
                   50% (doppio).
                   con protezione:   Lo sconto e' del
                   50%% (doppio).
[%1 riferimento]   senza protezione: Lo sconto e' del
                   VALORE riferimento.
                   con protezione:   Lo sconto e' del %1
                   riferimento.
[%0 intera]        senza protezione: Lo sconto e' del
                   VALORE intera.
                   con protezione:   Lo sconto e' del %0
                   intera.
[normale]          senza protezione: Lo sconto e' del
                   normale.
                   con protezione:   Lo sconto e' del
                   normale.
```

Il primo caso è il più realistico: una percentuale in una stringa di
sostituzione produce l’errore *invalid use of '%' in replacement string*
perché il percento seguito da uno spazio non è un segnaposto valido.

I casi `%0` e `%1` sono i più insidiosi: **non** producono errore, ma
inseriscono l’intera corrispondenza, cioè la parola `VALORE`, al posto
della sostituzione voluta. `%1` si comporta come `%0` perché il pattern
non ha catture, e in quel caso Lua fa coincidere la prima cattura con
l’intera corrispondenza. Un dato che contenga per caso `%0` o `%1`
corromperebbe silenziosamente il risultato, e non c’è alcun segnale.

L’alternativa migliore, mostrata alla fine, è usare una **funzione** come
sostituzione: il valore restituito non viene mai interpretato, quindi non
serve alcuna protezione.

**ES 18.8 — Ancorato contro non ancorato**

*Misura con `os.clock` la differenza fra un pattern ancorato e uno
non ancorato su una stringa di centomila caratteri in cui la
corrispondenza è all’inizio, e su una in cui non c’è affatto.
Commenta i quattro tempi ottenuti.*

```lua
local N = 100000
local RIPETIZIONI = 200

local conCorrispondenza = string.rep("a", N)
local senzaCorrispondenza = string.rep("b", N)

local prove = {
  {"ancorato, corrisponde", "^aaa", conCorrispondenza},
  {"non ancorato, corrisponde", "aaa",
    conCorrispondenza},
  {"ancorato, non corrisponde", "^aaa",
    senzaCorrispondenza},
  {"non ancorato, non corrisponde", "aaa",
    senzaCorrispondenza},
}

for _, p in ipairs(prove) do
  collectgarbage("collect")
  local inizio = os.clock()
  local trovato = false
  for _ = 1, RIPETIZIONI do
    trovato = p[3]:match(p[2]) ~= nil
  end
  local durata = os.clock() - inizio
  print(string.format("%-32s %.4f s  trovato=%s",
    p[1], durata, tostring(trovato)))
end
```

I quattro tempi raccontano una storia precisa.

**Ancorato e corrisponde**: istantaneo. Il pattern viene provato solo
nella posizione uno, corrisponde, e si finisce.

**Non ancorato e corrisponde**: altrettanto istantaneo, perché la
corrispondenza è comunque all’inizio e il motore la trova al primo
tentativo.

**Ancorato e non corrisponde**: istantaneo. Il pattern viene provato solo
nella posizione uno, fallisce, e non ci sono altre posizioni da provare.

**Non ancorato e non corrisponde**: **lentissimo**. Il motore prova il
pattern in tutte e centomila le posizioni prima di arrendersi.

Il quarto caso è quindi centinaia o migliaia di volte più lento degli
altri tre, e la differenza cresce linearmente con la lunghezza della
stringa.

La conclusione operativa: ancorare non serve solo alla correttezza. Su
testi lunghi in cui la corrispondenza spesso non c’è — la validazione è
esattamente questo scenario — l’ancora trasforma un lavoro proporzionale
alla lunghezza in un lavoro costante.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
