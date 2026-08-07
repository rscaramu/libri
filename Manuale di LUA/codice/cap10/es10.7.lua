-- ES 10.7 — Il menù del ristorante
-- Manuale completo di Lua

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
