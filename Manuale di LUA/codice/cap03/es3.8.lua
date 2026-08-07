-- ES 3.8 — Indice di massa corporea in centimetri
-- Manuale completo di Lua

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
