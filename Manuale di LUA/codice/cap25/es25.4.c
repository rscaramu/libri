/* ES 25.4 — Profondità di annidamento
   Manuale completo di Lua */

#include <stdio.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

/* Registro dei puntatori gia' visitati, tenuto in
   una tabella Lua con chiavi light userdata. */

static int profondita(lua_State *L, int indice,
                      int viste) {
  if (!lua_istable(L, indice)) return 0;

  indice = lua_absindex(L, indice);

  /* gia' vista? */
  lua_pushlightuserdata(L,
    (void *) lua_topointer(L, indice));
  lua_gettable(L, viste);
  int presente = !lua_isnil(L, -1);
  lua_pop(L, 1);
  if (presente) return 0;

  lua_pushlightuserdata(L,
    (void *) lua_topointer(L, indice));
  lua_pushboolean(L, 1);
  lua_settable(L, viste);

  int massima = 0;

  luaL_checkstack(L, 4, "profondita' eccessiva");
  lua_pushnil(L);
  while (lua_next(L, indice) != 0) {
    /* stack: chiave, valore */
    if (lua_istable(L, -1)) {
      int d = profondita(L, lua_gettop(L), viste);
      if (d > massima) massima = d;
    }
    lua_pop(L, 1);
  }

  /* rimuoviamo il segno, per permettere di
     visitare la stessa tabella in rami diversi */
  lua_pushlightuserdata(L,
    (void *) lua_topointer(L, indice));
  lua_pushnil(L);
  lua_settable(L, viste);

  return massima + 1;
}

static int l_profondita(lua_State *L) {
  luaL_checktype(L, 1, LUA_TTABLE);
  lua_newtable(L);            /* tabella delle viste */
  int viste = lua_gettop(L);
  int d = profondita(L, 1, viste);
  lua_pop(L, 1);
  lua_pushinteger(L, d);
  return 1;
}

static const char *PROVE =
  "return {\n"
  "  piatta = {1, 2, 3},\n"
  "  due = {a = {1}},\n"
  "  tre = {a = {b = {1}}},\n"
  "  cinque = {a = {b = {c = {d = {1}}}}},\n"
  "  condivisa = (function()\n"
  "    local c = {1}\n"
  "    return {x = c, y = c}\n"
  "  end)(),\n"
  "  ciclica = (function()\n"
  "    local t = {}\n"
  "    t.se_stessa = t\n"
  "    return t\n"
  "  end)(),\n"
  "}\n";

int main(void) {
  lua_State *L = luaL_newstate();
  luaL_openlibs(L);

  lua_pushcfunction(L, l_profondita);
  lua_setglobal(L, "profondita");

  if (luaL_dostring(L, PROVE) != LUA_OK) {
    fprintf(stderr, "%s\n", lua_tostring(L, -1));
    lua_close(L);
    return 1;
  }

  /* la tabella dei casi e' in cima */
  lua_pushnil(L);
  while (lua_next(L, -2) != 0) {
    const char *nome = lua_tostring(L, -2);

    lua_getglobal(L, "profondita");
    lua_pushvalue(L, -2);
    if (lua_pcall(L, 1, 1, 0) != LUA_OK) {
      printf("%-12s ERRORE: %s\n", nome,
             lua_tostring(L, -1));
    } else {
      printf("%-12s profondita' %lld\n", nome,
             (long long) lua_tointeger(L, -1));
    }
    lua_pop(L, 2);
  }
  lua_pop(L, 1);

  printf("stack finale: %d\n", lua_gettop(L));
  lua_close(L);
  return 0;
}
