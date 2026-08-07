# Capitolo 31 — Giochi con LÖVE 2D

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 30](capitolo-30.md) · [Indice](README.md) · [Capitolo 32 →](capitolo-32.md)

---

Le soluzioni di questo capitolo non sono eseguibili fuori da LOVE, che
non è disponibile nell’ambiente in cui il manuale è stato preparato. Il
codice è verificato sintatticamente e segue l’API della versione 11, ma
il comportamento va provato sulla vostra installazione.

Ricordate che LOVE usa LuaJIT: niente interi, niente `//`, niente
operatori bit a bit nativi, niente `<const>` e `<close>`.

**ES 31.3 — Particelle, nemici e potenziamenti**

*Estendi il gioco del paragrafo 31.3 con: un sistema di particelle
per le esplosioni, tre tipi di nemico con comportamenti diversi, e
un potenziamento raccoglibile che modifica temporaneamente il ritmo
di fuoco.*

```lua
local Particelle = {}
Particelle.__index = Particelle

function Particelle.nuovo(massimo)
  return setmetatable({
    vive = {},
    libere = {},
    massimo = massimo or 500,
  }, Particelle)
end

function Particelle:emetti(x, y, quante, colore)
  for _ = 1, quante do
    if #self.vive >= self.massimo then break end
    local p = table.remove(self.libere) or {}
    local angolo = math.random() * math.pi * 2
    local velocita = 50 + math.random() * 200
    p.x, p.y = x, y
    p.vx = math.cos(angolo) * velocita
    p.vy = math.sin(angolo) * velocita
    p.vita = 0.4 + math.random() * 0.6
    p.vitaIniziale = p.vita
    p.raggio = 1 + math.random() * 3
    p.colore = colore
    self.vive[#self.vive + 1] = p
  end
end

function Particelle:aggiorna(dt)
  for i = #self.vive, 1, -1 do
    local p = self.vive[i]
    p.vita = p.vita - dt
    if p.vita <= 0 then
      table.remove(self.vive, i)
      self.libere[#self.libere + 1] = p
    else
      p.x = p.x + p.vx * dt
      p.y = p.y + p.vy * dt
      p.vy = p.vy + 200 * dt        -- gravita'
      p.vx = p.vx * (1 - 2 * dt)    -- attrito
    end
  end
end

function Particelle:disegna()
  for _, p in ipairs(self.vive) do
    local a = p.vita / p.vitaIniziale
    local c = p.colore
    love.graphics.setColor(c[1], c[2], c[3], a)
    love.graphics.circle("fill", p.x, p.y,
      p.raggio * a)
  end
end

local TIPI_NEMICO = {
  dritto = {
    colore = {0.9, 0.3, 0.3},
    raggio = 16,
    punti = 10,
    aggiorna = function(n, dt)
      n.y = n.y + n.velocita * dt
    end,
  },
  ondulato = {
    colore = {0.9, 0.6, 0.2},
    raggio = 14,
    punti = 20,
    aggiorna = function(n, dt)
      n.tempo = n.tempo + dt
      n.y = n.y + n.velocita * dt
      n.x = n.baseX
        + math.sin(n.tempo * 3) * n.ampiezza
    end,
  },
  inseguitore = {
    colore = {0.8, 0.2, 0.8},
    raggio = 12,
    punti = 30,
    aggiorna = function(n, dt, bersaglio)
      n.y = n.y + n.velocita * 0.7 * dt
      local dx = bersaglio.x - n.x
      local direzione = 0
      if dx > 2 then direzione = 1
      elseif dx < -2 then direzione = -1 end
      n.x = n.x + direzione * 120 * dt
    end,
  },
}

local POTENZIAMENTI = {
  fuocoRapido = {
    colore = {0.3, 0.9, 0.9},
    durata = 6,
    applica = function(g) g.ricaricaBase = 0.08 end,
    rimuovi = function(g) g.ricaricaBase = 0.25 end,
  },
  scudo = {
    colore = {0.9, 0.9, 0.3},
    durata = 8,
    applica = function(g) g.invulnerabile = true end,
    rimuovi = function(g) g.invulnerabile = false end,
  },
}

local function creaNemico(tipo, larghezza)
  local modello = TIPI_NEMICO[tipo]
  local raggio = modello.raggio
  local x = math.random(raggio, larghezza - raggio)
  return {
    tipo = tipo,
    modello = modello,
    x = x,
    baseX = x,
    y = -raggio,
    raggio = raggio,
    velocita = 80 + math.random() * 80,
    tempo = 0,
    ampiezza = 40 + math.random() * 60,
  }
end

local function aggiornaPotenziamenti(gioco, dt)
  for nome, attivo in pairs(gioco.potenziamenti) do
    attivo.rimasto = attivo.rimasto - dt
    if attivo.rimasto <= 0 then
      POTENZIAMENTI[nome].rimuovi(gioco)
      gioco.potenziamenti[nome] = nil
    end
  end
end

local function attiva(gioco, nome)
  local p = POTENZIAMENTI[nome]
  if p == nil then return end
  if gioco.potenziamenti[nome] == nil then
    p.applica(gioco)
  end
  gioco.potenziamenti[nome] = {rimasto = p.durata}
end

return {
  Particelle = Particelle,
  TIPI_NEMICO = TIPI_NEMICO,
  POTENZIAMENTI = POTENZIAMENTI,
  creaNemico = creaNemico,
  attiva = attiva,
  aggiornaPotenziamenti = aggiornaPotenziamenti,
}
```

Tre decisioni progettuali.

Le **particelle usano una pool**, secondo la tecnica del paragrafo 31.9.
Un’esplosione emette decine di particelle e ne libera altrettante ogni
frazione di secondo: senza pool, il garbage collector lavorerebbe
continuamente durante il gioco, producendo scatti visibili.

I **tipi di nemico sono strategie**, come nell’ES 15.7: una tabella con
le costanti e una funzione di aggiornamento. Aggiungere un quarto tipo
significa aggiungere una voce, senza toccare il ciclo di gioco.

I **potenziamenti hanno `applica` e `rimuovi` simmetrici**, e riattivare
un potenziamento già attivo **non richiama `applica`**: si limita a
rinnovare la durata. Senza quel controllo, due potenziamenti di fuoco
rapido raccolti in sequenza applicherebbero l’effetto due volte e la
rimozione lo annullerebbe una volta sola, lasciando il gioco in uno stato
incoerente.

**ES 31.4 — Telecamera con inseguimento morbido**

*Implementa una telecamera che segua il giocatore con un ritardo
morbido, con limiti sui bordi del mondo e un effetto di tremolio
quando il giocatore viene colpito.*

```lua
local Telecamera = {}
Telecamera.__index = Telecamera

function Telecamera.nuova(opzioni)
  opzioni = opzioni or {}
  return setmetatable({
    x = opzioni.x or 0,
    y = opzioni.y or 0,
    zoom = opzioni.zoom or 1,
    morbidezza = opzioni.morbidezza or 5,
    limiti = opzioni.limiti,
    tremolio = 0,
    intensitaTremolio = 0,
    scostamentoX = 0,
    scostamentoY = 0,
  }, Telecamera)
end

function Telecamera:segui(bersaglio, dt)
  local larghezza = love.graphics.getWidth()
  local altezza = love.graphics.getHeight()

  local desiderataX = bersaglio.x - larghezza
    / (2 * self.zoom)
  local desiderataY = bersaglio.y - altezza
    / (2 * self.zoom)

  -- Interpolazione indipendente dal frame rate:
  -- NON self.x + (desiderata - self.x) * 0.1,
  -- che dipenderebbe dai fotogrammi al secondo.
  local fattore = 1 - math.exp(-self.morbidezza * dt)
  self.x = self.x + (desiderataX - self.x) * fattore
  self.y = self.y + (desiderataY - self.y) * fattore

  if self.limiti then
    local L = self.limiti
    local visibileL = larghezza / self.zoom
    local visibileA = altezza / self.zoom

    if L.destra - L.sinistra < visibileL then
      self.x = (L.sinistra + L.destra - visibileL) / 2
    else
      if self.x < L.sinistra then self.x = L.sinistra end
      if self.x > L.destra - visibileL then
        self.x = L.destra - visibileL
      end
    end

    if L.basso - L.alto < visibileA then
      self.y = (L.alto + L.basso - visibileA) / 2
    else
      if self.y < L.alto then self.y = L.alto end
      if self.y > L.basso - visibileA then
        self.y = L.basso - visibileA
      end
    end
  end
end

function Telecamera:trema(intensita, durata)
  self.intensitaTremolio =
    math.max(self.intensitaTremolio, intensita)
  self.tremolio = math.max(self.tremolio, durata)
end

function Telecamera:aggiorna(dt)
  if self.tremolio > 0 then
    self.tremolio = self.tremolio - dt
    local scala = self.intensitaTremolio
      * math.max(0, self.tremolio)
    self.scostamentoX = (math.random() * 2 - 1) * scala
    self.scostamentoY = (math.random() * 2 - 1) * scala
    if self.tremolio <= 0 then
      self.scostamentoX = 0
      self.scostamentoY = 0
      self.intensitaTremolio = 0
    end
  end
end

function Telecamera:applica()
  love.graphics.push()
  love.graphics.scale(self.zoom)
  love.graphics.translate(
    -math.floor(self.x + self.scostamentoX),
    -math.floor(self.y + self.scostamentoY))
end

function Telecamera:rilascia()
  love.graphics.pop()
end

function Telecamera:schermoAMondo(sx, sy)
  return sx / self.zoom + self.x,
         sy / self.zoom + self.y
end

return Telecamera
```

Il punto tecnicamente più importante è l’**interpolazione indipendente
dal frame rate**.

La formula ingenua `posizione + (desiderata - posizione) * 0.1` è
scorretta: applicata sessanta volte al secondo produce un inseguimento
molto più rapido di quando è applicata trenta volte. La telecamera
sarebbe più reattiva sui monitor veloci, il che è visibile e fastidioso.

La formula corretta `1 - math.exp(-velocita * dt)` produce lo stesso
avvicinamento nell’unità di tempo indipendentemente da quante volte
venga applicata. È l’equivalente continuo del decadimento esponenziale, e
va usata per qualunque interpolazione morbida in un ciclo di gioco.

Il `math.floor` sulla traslazione evita che la telecamera si fermi su
coordinate frazionarie, che con le immagini a pixel producono
sfocature.

Il caso in cui il mondo è **più piccolo dello schermo** va gestito
separatamente: senza, i due limiti si contraddirebbero e la telecamera
oscillerebbe. La soluzione è centrare il mondo.

**ES 31.5 — Gestore di risorse con cache**

*Scrivi un gestore di risorse che carichi immagini e suoni al primo
uso, li conservi in cache e riporti quanta memoria occupano. Usa una
tabella a valori deboli e discuti se sia la scelta giusta in un
gioco.*

```lua
local Risorse = {}
Risorse.__index = Risorse

function Risorse.nuovo(opzioni)
  opzioni = opzioni or {}
  return setmetatable({
    debole = opzioni.debole or false,
    cache = opzioni.debole
      and setmetatable({}, {__mode = "v"})
      or {},
    caricamenti = 0,
    colpi = 0,
    byteStimati = 0,
    caricatori = {},
  }, Risorse)
end

function Risorse:registra(tipo, caricatore, stima)
  self.caricatori[tipo] = {
    carica = caricatore,
    stima = stima,
  }
  return self
end

function Risorse:ottieni(tipo, percorso, ...)
  local chiave = tipo .. ":" .. percorso
  local v = self.cache[chiave]
  if v ~= nil then
    self.colpi = self.colpi + 1
    return v
  end

  local c = self.caricatori[tipo]
  if c == nil then
    return nil, "tipo sconosciuto: " .. tostring(tipo)
  end

  local ok, risorsa = pcall(c.carica, percorso, ...)
  if not ok then
    return nil, "caricamento fallito: "
      .. tostring(risorsa)
  end

  self.cache[chiave] = risorsa
  self.caricamenti = self.caricamenti + 1
  if c.stima then
    self.byteStimati = self.byteStimati
      + c.stima(risorsa)
  end

  return risorsa
end

function Risorse:stato()
  local quante = 0
  for _ in pairs(self.cache) do quante = quante + 1 end
  return {
    inCache = quante,
    caricamenti = self.caricamenti,
    colpi = self.colpi,
    byteStimati = self.byteStimati,
    debole = self.debole,
  }
end

function Risorse:rapporto()
  local s = self:stato()
  local totale = s.caricamenti + s.colpi
  return string.format(
    "risorse: %d in cache, %d caricamenti, %d colpi "
    .. "(%.1f%%), circa %.1f MB, modalita' %s",
    s.inCache, s.caricamenti, s.colpi,
    totale > 0 and (s.colpi / totale * 100) or 0,
    s.byteStimati / 1048576,
    s.debole and "debole" or "forte")
end

-- Registrazione dei tipi in un gioco LOVE
local function configura(r)
  r:registra("immagine", function(percorso)
    return love.graphics.newImage(percorso)
  end, function(img)
    local w, h = img:getDimensions()
    return w * h * 4
  end)

  r:registra("suono", function(percorso, modalita)
    return love.audio.newSource(percorso,
      modalita or "static")
  end, function() return 0 end)

  r:registra("font", function(percorso, dimensione)
    return love.graphics.newFont(percorso,
      dimensione or 12)
  end, function() return 0 end)

  return r
end

return {nuovo = Risorse.nuovo, configura = configura}
```

La discussione sulla tabella a valori deboli è il punto dell’esercizio, e
la risposta è **no, in un gioco non è la scelta giusta**.

La ragione è la prevedibilità. Con la cache debole, una texture non
riferita da nulla può essere raccolta in qualunque momento, e la
ricaricheremo alla prossima richiesta. Il caricamento di un’immagine
dal disco richiede millisecondi, che a sessanta fotogrammi al secondo
significa **saltare fotogrammi**: lo scatto è visibile e avviene in modo
imprevedibile.

Un gioco preferisce quasi sempre l’opposto: caricare tutto all’avvio o al
caricamento del livello, tenerlo in memoria per l’intera partita, e
liberarlo esplicitamente ai cambi di livello. La memoria è nota in
anticipo, e il costo si paga in un momento in cui il giocatore si aspetta
un’attesa.

La cache debole ha senso in un editor o in uno strumento, dove l’insieme
delle risorse non è noto in anticipo e le pause sono accettabili. È il
motivo per cui il gestore offre entrambe le modalità invece di
sceglierne una.

**ES 31.6 — Salvataggio e caricamento**

*Implementa il salvataggio e il caricamento dello stato di gioco
usando `love.filesystem` e la serializzazione del Capitolo 20.
Gestisci il caso di un file di salvataggio corrotto o di versione
precedente.*

```lua
local Salvataggio = {}

local VERSIONE = 3
local NOME = "salvataggio.lua"

local function serializza(v, livello)
  livello = livello or 0
  local t = type(v)

  if t == "nil" or t == "boolean" or t == "number" then
    return tostring(v)
  end
  if t == "string" then
    return string.format("%q", v)
  end
  if t ~= "table" then
    return nil, "tipo non serializzabile: " .. t
  end

  local dentro = string.rep("  ", livello + 1)
  local pezzi = {}
  local n = #v

  for i = 1, n do
    local s, e = serializza(v[i], livello + 1)
    if s == nil then return nil, e end
    pezzi[#pezzi + 1] = dentro .. s
  end

  local chiavi = {}
  for k in pairs(v) do
    local numerica = type(k) == "number"
      and k == math.floor(k) and k >= 1 and k <= n
    if not numerica then chiavi[#chiavi + 1] = k end
  end
  table.sort(chiavi, function(a, b)
    return tostring(a) < tostring(b)
  end)

  for _, k in ipairs(chiavi) do
    local sv, e = serializza(v[k], livello + 1)
    if sv == nil then return nil, e end
    local sk
    if type(k) == "string"
       and k:match("^[%a_][%w_]*$") then
      sk = k
    else
      sk = "[" .. serializza(k) .. "]"
    end
    pezzi[#pezzi + 1] = dentro .. sk .. " = " .. sv
  end

  if #pezzi == 0 then return "{}" end
  return "{\n" .. table.concat(pezzi, ",\n") .. "\n"
    .. string.rep("  ", livello) .. "}"
end

local MIGRAZIONI = {
  [1] = function(dati)
    -- v1 -> v2: il punteggio era una stringa
    dati.punteggio = tonumber(dati.punteggio) or 0
    dati.versione = 2
    return dati
  end,
  [2] = function(dati)
    -- v2 -> v3: introdotte le statistiche
    dati.statistiche = dati.statistiche or {
      partite = 0, tempoTotale = 0,
    }
    dati.versione = 3
    return dati
  end,
}

function Salvataggio.scrivi(stato)
  local dati = {
    versione = VERSIONE,
    salvatoIl = os.time(),
    punteggio = stato.punteggio or 0,
    livello = stato.livello or 1,
    vite = stato.vite or 3,
    sbloccati = stato.sbloccati or {},
    statistiche = stato.statistiche or {
      partite = 0, tempoTotale = 0,
    },
  }

  local testo, errore = serializza(dati)
  if testo == nil then
    return nil, "serializzazione: " .. errore
  end

  local temporaneo = NOME .. ".tmp"
  local ok, err = love.filesystem.write(temporaneo,
    "return " .. testo .. "\n")
  if not ok then
    return nil, "scrittura fallita: " .. tostring(err)
  end

  -- LOVE non ha rename: si rimuove e si riscrive.
  -- Non e' atomico, ma il file temporaneo permette
  -- di accorgersi di un salvataggio interrotto.
  love.filesystem.remove(NOME)
  local contenuto = love.filesystem.read(temporaneo)
  love.filesystem.write(NOME, contenuto)
  love.filesystem.remove(temporaneo)

  return true
end

function Salvataggio.leggi()
  if not love.filesystem.getInfo(NOME) then
    return nil, "nessun salvataggio"
  end

  local testo = love.filesystem.read(NOME)
  if testo == nil then
    return nil, "file illeggibile"
  end

  local chunk, errore = load(testo, "salvataggio",
    "t", {})
  if chunk == nil then
    return nil, "salvataggio corrotto: " .. errore
  end

  local ok, dati = pcall(chunk)
  if not ok then
    return nil, "salvataggio corrotto: "
      .. tostring(dati)
  end
  if type(dati) ~= "table" then
    return nil, "salvataggio malformato"
  end

  local versione = tonumber(dati.versione) or 1
  if versione > VERSIONE then
    return nil, string.format(
      "salvataggio di versione %d, questo gioco "
      .. "arriva alla %d", versione, VERSIONE)
  end

  while versione < VERSIONE do
    local migrazione = MIGRAZIONI[versione]
    if migrazione == nil then
      return nil, "nessuna migrazione da " .. versione
    end
    dati = migrazione(dati)
    versione = dati.versione
  end

  if type(dati.punteggio) ~= "number" then
    dati.punteggio = 0
  end
  if type(dati.vite) ~= "number" or dati.vite < 0 then
    dati.vite = 3
  end
  if type(dati.sbloccati) ~= "table" then
    dati.sbloccati = {}
  end

  return dati
end

return Salvataggio
```

Tre elementi.

Il caricamento usa `load` con **modo `"t"` e ambiente vuoto**, come nel
Capitolo 20: il file di salvataggio si trova in una cartella che
l’utente può modificare, e non deve poter eseguire codice.

La **migrazione a catena** applica le trasformazioni una versione alla
volta, il che rende possibile aggiungere una versione senza toccare le
migrazioni precedenti. Una versione **più recente** di quella supportata
viene rifiutata invece di essere interpretata: leggere un salvataggio
del futuro produrrebbe risultati arbitrari.

La **validazione dopo la migrazione** è la rete di sicurezza: anche un
file formalmente valido può contenere valori assurdi, perché un utente
può averlo modificato a mano. I campi critici vengono riportati a valori
sensati invece di far fallire il caricamento.

Va notato che `love.filesystem` non offre `os.rename`, quindi il
salvataggio atomico del Capitolo 34 non è riproducibile. Il file
temporaneo resta comunque utile come indizio di un salvataggio
interrotto.

**ES 31.7 — Tre modi di disegnare diecimila elementi**

*Confronta le prestazioni di tre modi di disegnare diecimila
elementi: chiamate individuali a `love.graphics.draw`, un
`SpriteBatch`, e un `SpriteBatch` aggiornato solo quando qualcosa
cambia.*

```lua
local N = 10000

local strategie = {}

strategie.individuale = {
  nome = "draw individuali",
  prepara = function(stato)
    stato.elementi = {}
    for i = 1, N do
      stato.elementi[i] = {
        x = math.random() * 800,
        y = math.random() * 600,
        r = math.random() * math.pi * 2,
      }
    end
  end,
  disegna = function(stato)
    for i = 1, N do
      local e = stato.elementi[i]
      love.graphics.draw(stato.immagine, e.x, e.y,
        e.r, 1, 1, 8, 8)
    end
  end,
}

strategie.batchOgniVolta = {
  nome = "SpriteBatch ricostruito",
  prepara = function(stato)
    stato.elementi = strategie.individuale
      .prepara and {} or {}
    stato.elementi = {}
    for i = 1, N do
      stato.elementi[i] = {
        x = math.random() * 800,
        y = math.random() * 600,
        r = math.random() * math.pi * 2,
      }
    end
    stato.batch = love.graphics.newSpriteBatch(
      stato.immagine, N)
  end,
  disegna = function(stato)
    stato.batch:clear()
    for i = 1, N do
      local e = stato.elementi[i]
      stato.batch:add(e.x, e.y, e.r, 1, 1, 8, 8)
    end
    love.graphics.draw(stato.batch)
  end,
}

strategie.batchStatico = {
  nome = "SpriteBatch statico",
  prepara = function(stato)
    stato.elementi = {}
    for i = 1, N do
      stato.elementi[i] = {
        x = math.random() * 800,
        y = math.random() * 600,
        r = math.random() * math.pi * 2,
      }
    end
    stato.batch = love.graphics.newSpriteBatch(
      stato.immagine, N, "static")
    for i = 1, N do
      local e = stato.elementi[i]
      stato.batch:add(e.x, e.y, e.r, 1, 1, 8, 8)
    end
  end,
  disegna = function(stato)
    love.graphics.draw(stato.batch)
  end,
}

local corrente = "individuale"
local stato = {}
local misure = {}

function love.load()
  love.window.setMode(800, 600)

  local dati = love.image.newImageData(16, 16)
  dati:mapPixel(function(x, y)
    local d = math.sqrt((x - 8) ^ 2 + (y - 8) ^ 2)
    if d < 7 then return 1, 1, 1, 1 end
    return 0, 0, 0, 0
  end)
  stato.immagine = love.graphics.newImage(dati)

  math.randomseed(12345)
  strategie[corrente].prepara(stato)
end

function love.update(dt)
  local s = misure[corrente]
  if s == nil then
    s = {fotogrammi = 0, tempo = 0, fps = 0}
    misure[corrente] = s
  end
  s.fotogrammi = s.fotogrammi + 1
  s.tempo = s.tempo + dt
  if s.tempo >= 1 then
    s.fps = s.fotogrammi / s.tempo
    s.fotogrammi = 0
    s.tempo = 0
  end
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 0.6)
  strategie[corrente].disegna(stato)

  love.graphics.setColor(1, 1, 0)
  love.graphics.print("strategia: "
    .. strategie[corrente].nome, 10, 10)
  love.graphics.print(string.format("%d elementi", N),
    10, 30)
  love.graphics.print("premi 1, 2, 3 per cambiare",
    10, 50)

  local y = 80
  for chiave, s in pairs(misure) do
    love.graphics.print(string.format("%-26s %6.1f fps",
      strategie[chiave].nome, s.fps), 10, y)
    y = y + 20
  end
end

function love.keypressed(tasto)
  local mappa = {
    ["1"] = "individuale",
    ["2"] = "batchOgniVolta",
    ["3"] = "batchStatico",
  }
  if mappa[tasto] then
    corrente = mappa[tasto]
    math.randomseed(12345)
    strategie[corrente].prepara(stato)
  elseif tasto == "escape" then
    love.event.quit()
  end
end
```

L’ordine dei risultati è prevedibile e la differenza è drastica.

Le **chiamate individuali** eseguono diecimila `love.graphics.draw`, e
ciascuna comporta un cambio di stato e un invio alla scheda grafica. È la
strategia più lenta di gran lunga, e su diecimila elementi il frame rate
crolla ben sotto i sessanta.

Il **`SpriteBatch` ricostruito** raccoglie tutte le posizioni in un
unico buffer e lo invia con una sola chiamata di disegno. Paga
diecimila `add` per fotogramma, ma sono operazioni su memoria, molto più
economiche di una chiamata di disegno.

Il **`SpriteBatch` statico** costruisce il buffer una volta sola e ogni
fotogramma esegue **una singola** operazione. È di gran lunga il più
veloce, e il limite è che gli elementi non possono muoversi.

La conclusione pratica: se gli elementi sono fermi — uno sfondo, una
mappa a tasselli, una griglia — il batch statico è la scelta ovvia. Se si
muovono, il batch ricostruito resta molto migliore delle chiamate
individuali. Le chiamate individuali si giustificano solo con poche
decine di elementi.

**ES 31.8 — Allocazioni del modulo vettore**

*Prendi il modulo vettore dell’ES 31.1 e verifica quante allocazioni
produce un ciclo di gioco che aggiorna mille entità per mille
fotogrammi, usando i metodi che allocano e poi quelli sul posto.
Misura con `collectgarbage("count")`.*

```lua
local V = {}
V.__index = V

local function nuovo(x, y)
  return setmetatable({x = x or 0, y = y or 0}, V)
end

V.__add = function(a, b) return nuovo(a.x + b.x,
  a.y + b.y) end
V.__mul = function(a, k)
  if type(a) == "number" then return nuovo(a * k.x,
    a * k.y) end
  return nuovo(a.x * k, a.y * k)
end

function V:normalizzato()
  local l = math.sqrt(self.x * self.x
    + self.y * self.y)
  if l == 0 then return nuovo(0, 0) end
  return nuovo(self.x / l, self.y / l)
end

function V:aggiungiSuPosto(altro, scala)
  scala = scala or 1
  self.x = self.x + altro.x * scala
  self.y = self.y + altro.y * scala
  return self
end

function V:normalizza()
  local l = math.sqrt(self.x * self.x
    + self.y * self.y)
  if l > 0 then
    self.x = self.x / l
    self.y = self.y / l
  end
  return self
end

local ENTITA = 1000
local FOTOGRAMMI = 1000
local DT = 1 / 60

local function creaEntita()
  local e = {}
  math.randomseed(999)
  for i = 1, ENTITA do
    e[i] = {
      posizione = nuovo(math.random() * 800,
        math.random() * 600),
      velocita = nuovo(math.random() * 100 - 50,
        math.random() * 100 - 50),
      bersaglio = nuovo(400, 300),
    }
  end
  return e
end

local function misura(nome, aggiorna)
  local entita = creaEntita()
  collectgarbage("collect")
  collectgarbage("collect")

  local prima = collectgarbage("count")
  local raccolte = 0
  local contatore = 0

  local inizio = os.clock()
  for _ = 1, FOTOGRAMMI do
    aggiorna(entita, DT)
    contatore = contatore + 1
    if contatore % 100 == 0 then
      local adesso = collectgarbage("count")
      if adesso < prima then raccolte = raccolte + 1 end
      prima = adesso
    end
  end
  local durata = os.clock() - inizio

  collectgarbage("collect")
  local dopo = collectgarbage("count")

  print(string.format(
    "%-24s %.4f s  raccolte osservate: %d  "
    .. "memoria finale %.0f KB",
    nome, durata, raccolte, dopo))
end

misura("con allocazioni", function(entita, dt)
  for i = 1, ENTITA do
    local e = entita[i]
    local verso = nuovo(
      e.bersaglio.x - e.posizione.x,
      e.bersaglio.y - e.posizione.y)
    local direzione = verso:normalizzato()
    e.velocita = e.velocita + direzione * (200 * dt)
    e.posizione = e.posizione + e.velocita * dt
  end
end)

local temporaneo = nuovo(0, 0)

misura("sul posto", function(entita, dt)
  for i = 1, ENTITA do
    local e = entita[i]
    temporaneo.x = e.bersaglio.x - e.posizione.x
    temporaneo.y = e.bersaglio.y - e.posizione.y
    temporaneo:normalizza()
    e.velocita:aggiungiSuPosto(temporaneo, 200 * dt)
    e.posizione:aggiungiSuPosto(e.velocita, dt)
  end
end)
```

produce:

```text
con allocazioni  2.5556 s  raccolte osservate: 5
                 memoria finale 500 KB
sul posto        0.5469 s  raccolte osservate: 0
                 memoria finale 500 KB
```

La differenza è di quasi **cinque volte** nel tempo, e la ragione non è
il calcolo: le operazioni aritmetiche sono le stesse.

La versione con allocazioni crea **quattro vettori per entità per
fotogramma** — il verso, il normalizzato, il risultato della
moltiplicazione e quello dell’addizione, moltiplicati per due
espressioni. Su mille entità e mille fotogrammi sono milioni di tabelle
allocate e immediatamente abbandonate.

Le cinque raccolte osservate sono la prova diretta: la memoria cala
periodicamente perché il raccoglitore interviene. Nella versione sul
posto la memoria non cala mai, perché non c’è nulla da raccogliere.

In un gioco reale la differenza non si manifesta come lentezza uniforme
ma come **scatti**: i fotogrammi in cui il raccoglitore lavora durano più
degli altri, e l’occhio li percepisce.

La conclusione del Capitolo 31 vale integralmente: la doppia interfaccia
del modulo vettore, con metodi che allocano e metodi sul posto, esiste
per questa ragione. Si usa la forma leggibile dove non conta e quella sul
posto nei cicli caldi.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
