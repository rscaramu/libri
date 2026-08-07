-- ES 33.7 — Registrazione strutturata e aggregazione
-- Manuale completo di Lua
-- Richiede OpenResty: non eseguibile con l'interprete
-- Lua da solo.

-- /app/lua/registro.lua
local durata = 0
if ngx.ctx.inizio then
  durata = (ngx.now() - ngx.ctx.inizio) * 1000
end

-- formato a coppie chiave=valore separate da tab:
-- niente virgole da proteggere, niente JSON da
-- analizzare, campi aggiungibili senza rompere
-- chi legge
local campi = {
  "t=" .. ngx.now(),
  "cliente=" .. (ngx.ctx.cliente or "-"),
  "metodo=" .. ngx.var.request_method,
  "percorso=" .. (ngx.var.uri or "-"),
  "stato=" .. ngx.status,
  "durata=" .. string.format("%.1f", durata),
  "cache=" .. (ngx.header["X-Cache"] or "-"),
  "byte=" .. (ngx.var.bytes_sent or "0"),
}

ngx.log(ngx.INFO, table.concat(campi, "\t"))
