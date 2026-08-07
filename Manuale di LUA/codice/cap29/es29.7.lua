-- ES 29.7 — luacheck su un progetto reale
-- Manuale completo di Lua

-- .luacheckrc
ignore = {
  "212/self",   -- self inutilizzato nei metodi
  "212/_.*",    -- argomenti con nome che inizia per _
  "542",        -- blocco if vuoto (usato come
                -- documentazione di un caso)
}
