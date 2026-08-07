/* ES 25.8 — Il limite dello stack
   Manuale completo di Lua */

#include <stdio.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

static int l_senzaControllo(lua_State *L) {
  lua_Integer quanti = luaL_checkinteger(L, 1);
  for (lua_Integer i = 1; i <= quanti; i++) {
    lua_pushinteger(L, i);
  }
  lua_pushinteger(L, lua_gettop(L));
  return 1;
}

static int l_conControllo(lua_State *L) {
  lua_Integer quanti = luaL_checkinteger(L, 1);
  if (!lua_checkstack(L, (int) quanti + 2)) {
    return luaL_error(L,
      "impossibile riservare %d posizioni",
      (int) quanti);
  }
  for (lua_Integer i = 1; i <= quanti; i++) {
    lua_pushinteger(L, i);
  }
  lua_pushinteger(L, lua_gettop(L));
  return 1;
}

static const char *PROVE =
  "print('entro la garanzia di 20 posizioni:')\n"
  "for _, n in ipairs({5, 15, 19}) do\n"
  "  local ok1, r1 = pcall(senzaControllo, n)\n"
  "  local ok2, r2 = pcall(conControllo, n)\n"
  "  print(string.format('%9d  senza: %-10s "
  "con: %s', n,\n"
  "    tostring(r1), tostring(r2)))\n"
  "end\n"
  "print('oltre la garanzia, solo con controllo:')\n"
  "for _, n in ipairs({100, 1000, 100000,\n"
  "                    10000000}) do\n"
  "  local ok, r = pcall(conControllo, n)\n"
  "  print(string.format('%9d  con: %s', n,\n"
  "    tostring(r)))\n"
  "end\n";

int main(void) {
  lua_State *L = luaL_newstate();
  luaL_openlibs(L);

  lua_pushcfunction(L, l_senzaControllo);
  lua_setglobal(L, "senzaControllo");
  lua_pushcfunction(L, l_conControllo);
  lua_setglobal(L, "conControllo");

  if (luaL_dostring(L, PROVE) != LUA_OK) {
    fprintf(stderr, "%s\n", lua_tostring(L, -1));
  }

  printf("stack finale: %d\n", lua_gettop(L));
  lua_close(L);
  return 0;
}
