-- ES 3.4 — Tre numeri con validazione
-- Manuale completo di Lua

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
