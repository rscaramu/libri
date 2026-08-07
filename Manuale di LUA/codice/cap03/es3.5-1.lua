-- ES 3.5 — Le iniziali
-- Manuale completo di Lua

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
