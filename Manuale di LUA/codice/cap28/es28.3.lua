-- ES 28.3 — Rockspec con moduli Lua e C
-- Manuale completo di Lua

package = "misto"
version = "0.3.0-1"

source = {
  url = "git+https://example.com/rs/misto.git",
  tag = "v0.3.0",
}

description = {
  summary = "Utilita' miste con un nucleo in C",
  detailed = [[
    Funzioni di supporto in Lua puro piu' un modulo C
    che implementa le operazioni piu' pesanti.
  ]],
  homepage = "https://example.com/rs/misto",
  license = "MIT",
  maintainer = "Roberto Scaramuzzino",
}

dependencies = {
  "lua >= 5.3, < 5.5",
}

build = {
  type = "builtin",
  modules = {
    -- moduli Lua puri
    ["misto"] = "src/misto.lua",
    ["misto.util"] = "src/misto/util.lua",
    ["misto.formato"] = "src/misto/formato.lua",

    -- modulo C con due sorgenti
    ["misto.nucleo"] = {
      sources = {
        "csrc/nucleo.c",
        "csrc/aiuto.c",
      },
      incdirs = {"csrc"},
      libraries = {"m"},
      defines = {"MISTO_VERSIONE=\"0.3.0\""},
    },
  },
  copy_directories = {"doc"},
}
