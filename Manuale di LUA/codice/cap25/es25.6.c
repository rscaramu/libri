/* ES 25.6 — Gestione dei valori di ritorno
   Manuale completo di Lua */

#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

typedef struct {
  char nome[32];
  double valore;
  int valido;
} Voce;

static const char *SCRIPT =
  "function elabora(dati, modalita)\n"
  "  if modalita == 'errore' then\n"
  "    return nil, 'elaborazione rifiutata'\n"
  "  end\n"
  "  if modalita == 'parziale' then\n"
  "    return {{nome = 'solo nome'},\n"
  "            {valore = 3.5},\n"
  "            {nome = 'completo', valore = 1.5}}\n"
  "  end\n"
  "  if modalita == 'tipi' then\n"
  "    return {{nome = 42, valore = 'testo'}}\n"
  "  end\n"
  "  if modalita == 'nontabella' then\n"
  "    return 'non e' .. 'una tabella'\n"
  "  end\n"
  "  local r = {}\n"
  "  for i, v in ipairs(dati) do\n"
  "    r[i] = {nome = v, valore = i * 1.5}\n"
  "  end\n"
  "  return r\n"
  "end\n";

static int leggiVoci(lua_State *L, int indice,
                     Voce *fuori, int massimo,
                     char *avvisi, size_t dimAvvisi) {
  indice = lua_absindex(L, indice);
  avvisi[0] = '\0';

  if (!lua_istable(L, indice)) {
    snprintf(avvisi, dimAvvisi,
             "atteso table, ricevuto %s",
             luaL_typename(L, indice));
    return -1;
  }

  lua_Integer quante = luaL_len(L, indice);
  if (quante > massimo) quante = massimo;

  int prodotte = 0;

  for (lua_Integer i = 1; i <= quante; i++) {
    lua_geti(L, indice, i);
    if (!lua_istable(L, -1)) {
      snprintf(avvisi + strlen(avvisi),
               dimAvvisi - strlen(avvisi),
               "voce %d non e' una tabella; ", (int) i);
      lua_pop(L, 1);
      continue;
    }

    Voce v;
    v.valido = 1;
    v.nome[0] = '\0';
    v.valore = 0.0;

    lua_getfield(L, -1, "nome");
    if (lua_type(L, -1) == LUA_TSTRING) {
      strncpy(v.nome, lua_tostring(L, -1),
              sizeof(v.nome) - 1);
      v.nome[sizeof(v.nome) - 1] = '\0';
    } else {
      snprintf(avvisi + strlen(avvisi),
               dimAvvisi - strlen(avvisi),
               "voce %d: nome %s; ", (int) i,
               lua_isnil(L, -1) ? "mancante"
                                : "di tipo errato");
      v.valido = 0;
    }
    lua_pop(L, 1);

    lua_getfield(L, -1, "valore");
    if (lua_isnumber(L, -1)) {
      v.valore = lua_tonumber(L, -1);
    } else {
      snprintf(avvisi + strlen(avvisi),
               dimAvvisi - strlen(avvisi),
               "voce %d: valore %s; ", (int) i,
               lua_isnil(L, -1) ? "mancante"
                                : "di tipo errato");
      v.valido = 0;
    }
    lua_pop(L, 1);

    fuori[prodotte++] = v;
    lua_pop(L, 1);
  }

  return prodotte;
}

static void prova(lua_State *L, const char *modalita) {
  printf("=== modalita' %s ===\n", modalita);

  lua_getglobal(L, "elabora");
  lua_createtable(L, 2, 0);
  lua_pushstring(L, "alfa");
  lua_seti(L, -2, 1);
  lua_pushstring(L, "beta");
  lua_seti(L, -2, 2);
  lua_pushstring(L, modalita);

  if (lua_pcall(L, 2, 2, 0) != LUA_OK) {
    printf("  chiamata fallita: %s\n",
           lua_tostring(L, -1));
    lua_pop(L, 1);
    return;
  }

  /* convenzione nil + messaggio */
  if (lua_isnil(L, -2)) {
    printf("  lo script ha segnalato: %s\n",
           lua_tostring(L, -1));
    lua_pop(L, 2);
    return;
  }
  lua_pop(L, 1);   /* scartiamo il secondo valore */

  Voce voci[16];
  char avvisi[512];
  int n = leggiVoci(L, -1, voci, 16, avvisi,
                    sizeof(avvisi));
  lua_pop(L, 1);

  if (n < 0) {
    printf("  struttura non valida: %s\n", avvisi);
    return;
  }

  printf("  %d voci lette\n", n);
  for (int i = 0; i < n; i++) {
    printf("    %-14s %8.2f  %s\n", voci[i].nome,
           voci[i].valore,
           voci[i].valido ? "ok" : "INCOMPLETA");
  }
  if (avvisi[0] != '\0') {
    printf("  avvisi: %s\n", avvisi);
  }
}

int main(void) {
  lua_State *L = luaL_newstate();
  luaL_openlibs(L);

  if (luaL_dostring(L, SCRIPT) != LUA_OK) {
    fprintf(stderr, "script: %s\n",
            lua_tostring(L, -1));
    lua_close(L);
    return 1;
  }

  prova(L, "normale");
  prova(L, "errore");
  prova(L, "parziale");
  prova(L, "tipi");
  prova(L, "nontabella");

  printf("stack finale: %d\n", lua_gettop(L));
  lua_close(L);
  return 0;
}
