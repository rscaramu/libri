/* ES 26.4 — Sostituzione letterale
   Manuale completo di Lua */

#include <string.h>
#include <lua.h>
#include <lauxlib.h>

static int l_sostituisci(lua_State *L) {
  size_t nTesto, nDa, nA;
  const char *testo = luaL_checklstring(L, 1, &nTesto);
  const char *da = luaL_checklstring(L, 2, &nDa);
  const char *a = luaL_checklstring(L, 3, &nA);
  lua_Integer massimo = luaL_optinteger(L, 4, -1);

  if (nDa == 0) {
    return luaL_error(L, "sottostringa da cercare "
                      "vuota");
  }

  luaL_Buffer b;
  luaL_buffinit(L, &b);

  lua_Integer quante = 0;
  size_t i = 0;

  while (i < nTesto) {
    if (massimo >= 0 && quante >= massimo) break;
    if (i + nDa <= nTesto
        && memcmp(testo + i, da, nDa) == 0) {
      luaL_addlstring(&b, a, nA);
      i += nDa;
      quante++;
    } else {
      luaL_addchar(&b, testo[i]);
      i++;
    }
  }

  if (i < nTesto) {
    luaL_addlstring(&b, testo + i, nTesto - i);
  }

  luaL_pushresult(&b);
  lua_pushinteger(L, quante);
  return 2;
}

static const luaL_Reg FUNZIONI[] = {
  {"sostituisci", l_sostituisci},
  {NULL, NULL}
};

int luaopen_testo2(lua_State *L) {
  luaL_newlib(L, FUNZIONI);
  return 1;
}
