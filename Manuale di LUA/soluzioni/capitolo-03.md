# Capitolo 3 — Il primo programma: valori, variabili e output

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 2](capitolo-02.md) · [Indice](README.md) · [Capitolo 4 →](capitolo-04.md)

I 6 sorgenti eseguibili di questo capitolo sono in
[`codice/cap03/`](../codice/cap03/).

---

**ES 3.4 — Tre numeri con validazione**

*Scrivi un programma che chieda all’utente tre numeri, uno per volta,
e ne stampi somma, media e prodotto con due cifre decimali. Rifiuta
gli input non numerici indicando quale dei tre è sbagliato.*

```lua
local numeri = {}
local etichette = {"primo", "secondo", "terzo"}

for i = 1, 3 do
  io.write("Inserisci il " .. etichette[i]
    .. " numero: ")
  local riga = io.read()

  if riga == nil then
    print("\nInput terminato.")
    os.exit(1)
  end

  local n = tonumber(riga)
  if n == nil then
    print("Il " .. etichette[i]
      .. " valore non e' un numero: '" .. riga .. "'")
    os.exit(1)
  end

  numeri[i] = n
end

local somma = numeri[1] + numeri[2] + numeri[3]
local media = somma / 3
local prodotto = numeri[1] * numeri[2] * numeri[3]

print(string.format("Somma:    %.2f", somma))
print(string.format("Media:    %.2f", media))
print(string.format("Prodotto: %.2f", prodotto))
```

Il punto dell’esercizio è la **posizione del controllo**: la validazione
avviene subito dopo ogni lettura, e il messaggio dice quale dei tre
valori è sbagliato. Leggere tutti e tre e validare alla fine sarebbe
altrettanto corretto, ma costringerebbe l’utente a reinserire tutto.

Il controllo su `riga == nil` gestisce la fine dell’input, che è diversa
da un valore non numerico.

**ES 3.5 — Le iniziali**

*Scrivi un programma che chieda un nome completo scritto come «Nome
Cognome» e stampi le iniziali. Usa soltanto ciò che hai imparato
finora più la funzione `string.sub`, che estrae una porzione di
stringa: cercane la sintassi nel manuale di riferimento.*

```lua
io.write("Nome e cognome: ")
local completo = io.read()

if completo == nil or completo == "" then
  print("Nessun input.")
  os.exit(1)
end

local spazio = nil
for i = 1, #completo do
  if completo:sub(i, i) == " " then
    spazio = i
    break
  end
end

if spazio == nil then
  print("Serve nome e cognome separati da uno spazio.")
  os.exit(1)
end

local nome = completo:sub(1, spazio - 1)
local cognome = completo:sub(spazio + 1)

if nome == "" or cognome == "" then
  print("Nome o cognome mancante.")
  os.exit(1)
end

local iniziali = nome:sub(1, 1):upper() .. "."
  .. cognome:sub(1, 1):upper() .. "."

print("Iniziali: " .. iniziali)
```

La ricerca dello spazio è fatta a mano perché a questo punto del manuale
non conosciamo ancora `string.find` né i pattern. Con essi si
scriverebbe:

```lua
local nome, cognome = completo:match("^(%S+)%s+(%S+)")
```

che è la versione del Capitolo 17, molto più breve e che gestisce anche
gli spazi multipli.

Il caso di un cognome composto, «Anna Maria De Rossi», produce iniziali
sbagliate in entrambe le versioni. Gestirlo richiede di decidere una
convenzione, ed è il tipo di ambiguità che va discussa con chi userà il
programma prima di codificarla.

**ES 3.6 — L’assegnazione multipla valuta prima**

*Dimostra con un programma che l’assegnazione multipla valuta tutti i
valori a destra prima di assegnarli. Costruisci un caso in cui, se
non fosse così, il risultato sarebbe diverso, e spiega nel commento
quale sarebbe.*

```lua
local a, b = 1, 2

-- Se l'assegnazione fosse sequenziale, a diventerebbe 2
-- e poi b riceverebbe il NUOVO valore di a, cioe' 2:
-- il risultato sarebbe 2, 2.
a, b = b, a
print(a, b)   --> 2  1

-- Caso piu' netto, con tre variabili in rotazione
local x, y, z = "primo", "secondo", "terzo"
x, y, z = z, x, y
print(x, y, z)   --> terzo  primo  secondo

-- Se fosse sequenziale: x diventa "terzo",
-- poi y riceve il nuovo x, cioe' "terzo",
-- poi z riceve il nuovo y, cioe' "terzo":
-- il risultato sarebbe terzo, terzo, terzo.

-- Anche con gli indici di tabella
local t = {10, 20}
local i = 1
i, t[i] = 2, 99
print(i, t[1], t[2])   --> 2  99  20

-- L'indice t[i] usa il valore di i PRIMA
-- dell'assegnazione, quindi scrive in t[1] e non in t[2].
```

L’ultimo caso è il più istruttivo e il più insidioso: anche gli
**indici** a sinistra dell’uguale sono valutati prima di qualunque
assegnazione. È una regola che vale la pena conoscere, e un motivo in più
per non scrivere assegnazioni multiple troppo furbe.

**ES 3.7 — Cinque modi di ottenere `nil`**

*Scrivi un programma che stampi il valore e il tipo di cinque
espressioni che restituiscono `nil` per motivi diversi fra loro: una
variabile mai dichiarata, un campo inesistente di una tabella, il
risultato di `tonumber` su testo non numerico, e altri due casi che
troverai da solo.*

```lua
local casi = {}

-- 1. Variabile globale mai dichiarata
casi[#casi + 1] = {"globale inesistente", mai_definita}

-- 2. Campo inesistente di una tabella
local t = {a = 1}
casi[#casi + 1] = {"campo assente", t.b}

-- 3. tonumber su testo non numerico
casi[#casi + 1] = {"tonumber('ciao')", tonumber("ciao")}

-- 4. Indice oltre la fine di una sequenza
local s = {"x", "y"}
casi[#casi + 1] = {"indice fuori", s[10]}

-- 5. Funzione che non restituisce nulla
local function niente() end
casi[#casi + 1] = {"funzione vuota", niente()}

-- 6. Variabile locale dichiarata e non assegnata
local dichiarata
casi[#casi + 1] = {"local non assegnata", dichiarata}

-- 7. Argomento non passato
local function f(a, b) return b end
casi[#casi + 1] = {"argomento mancante", f(1)}

for i = 1, #casi do
  local nome = casi[i][1]
  local valore = casi[i][2]
  print(string.format("%-22s %-6s %s", nome,
    type(valore), tostring(valore)))
end
```

Tutti e sette producono `nil`, di tipo `"nil"`. Il punto dell’esercizio è
che `nil` non è un errore: è un valore ordinario che segnala assenza, e
in Lua l’assenza si presenta in molte forme diverse che il linguaggio non
distingue.

Notate che la tabella `casi` funziona anche se il secondo elemento di
ogni coppia è `nil`: quella posizione semplicemente non esiste, e
leggerla restituisce `nil`, che è ciò che vogliamo.

**ES 3.8 — Indice di massa corporea in centimetri**

*Riscrivi il calcolatore di indice di massa corporea del paragrafo
3.9 in modo che accetti l’altezza in centimetri anziché in metri,
gestisca il caso di valori nulli o negativi per entrambi i dati e
aggiunga alla fine una riga che classifichi il risultato in una
delle categorie standard, usando solo il costrutto `if`.*

```lua
io.write("Peso in kg: ")
local rigaPeso = io.read()
io.write("Altezza in cm: ")
local rigaAltezza = io.read()

if rigaPeso == nil or rigaAltezza == nil then
  print("Input terminato.")
  os.exit(1)
end

local peso = tonumber(rigaPeso)
local altezzaCm = tonumber(rigaAltezza)

if peso == nil then
  print("Peso non valido: '" .. rigaPeso .. "'")
  os.exit(1)
end
if altezzaCm == nil then
  print("Altezza non valida: '" .. rigaAltezza .. "'")
  os.exit(1)
end
if peso <= 0 then
  print("Il peso deve essere positivo.")
  os.exit(1)
end
if altezzaCm <= 0 then
  print("L'altezza deve essere positiva.")
  os.exit(1)
end
if altezzaCm < 50 or altezzaCm > 250 then
  print("Altezza fuori da un intervallo plausibile.")
  os.exit(1)
end

local altezza = altezzaCm / 100
local imc = peso / (altezza * altezza)

local categoria
if imc < 16 then
  categoria = "grave magrezza"
elseif imc < 18.5 then
  categoria = "sottopeso"
elseif imc < 25 then
  categoria = "normopeso"
elseif imc < 30 then
  categoria = "sovrappeso"
elseif imc < 35 then
  categoria = "obesita' di primo grado"
elseif imc < 40 then
  categoria = "obesita' di secondo grado"
else
  categoria = "obesita' di terzo grado"
end

print(string.format("IMC: %.1f (%s)", imc, categoria))
print("Valore puramente indicativo: l'indice di massa")
print("corporea non tiene conto di eta', sesso,")
print("composizione corporea e altri fattori.")
```

Il controllo sull’intervallo plausibile dell’altezza è quello che
distingue un programma difensivo da uno ingenuo: un utente che digita
`1.75` invece di `175` otterrebbe altrimenti un indice di massa corporea
astronomico senza alcun avviso.

L’avvertenza finale non è pedanteria: un programma che classifica una
persona in categorie mediche deve dichiarare i propri limiti.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
