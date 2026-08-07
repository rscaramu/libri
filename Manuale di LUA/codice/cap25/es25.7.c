/* ES 25.7 — Serializzazione JSON dal C
   Manuale completo di Lua */

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

static void aggiungiStringa(luaL_Buffer *b,
                            const char *s, size_t n) {
  luaL_addchar(b, '"');
  for (size_t i = 0; i < n; i++) {
    unsigned char c = (unsigned char) s[i];
    switch (c) {
      case '"':  luaL_addstring(b, "\\\""); break;
      case '\\': luaL_addstring(b, "\\\\"); break;
      case '\n': luaL_addstring(b, "\\n");  break;
      case '\r': luaL_addstring(b, "\\r");  break;
      case '\t': luaL_addstring(b, "\\t");  break;
      case '\b': luaL_addstring(b, "\\b");  break;
      case '\f': luaL_addstring(b, "\\f");  break;
      default:
        if (c < 0x20) {
          char temp[8];
          snprintf(temp, sizeof(temp), "\\u%04X", c);
          luaL_addstring(b, temp);
        } else {
          luaL_addchar(b, (char) c);
        }
    }
  }
  luaL_addchar(b, '"');
}

static int eSequenza(lua_State *L, int indice) {
  lua_Integer n = luaL_len(L, indice);
  lua_Integer quante = 0;

  lua_pushnil(L);
  while (lua_next(L, indice) != 0) {
    if (lua_type(L, -2) != LUA_TNUMBER
        || !lua_isinteger(L, -2)) {
      lua_pop(L, 2);
      return 0;
    }
    lua_Integer k = lua_tointeger(L, -2);
    if (k < 1 || k > n) {
      lua_pop(L, 2);
      return 0;
    }
    quante++;
    lua_pop(L, 1);
  }

  return quante == n;
}

static void codifica(lua_State *L, int indice,
                     luaL_Buffer *b, int profondita) {
  if (profondita > 100) {
    luaL_error(L, "annidamento eccessivo o ciclo");
  }
  indice = lua_absindex(L, indice);

  switch (lua_type(L, indice)) {
    case LUA_TNIL:
      luaL_addstring(b, "null");
      return;

    case LUA_TBOOLEAN:
      luaL_addstring(b,
        lua_toboolean(L, indice) ? "true" : "false");
      return;

    case LUA_TNUMBER: {
      char temp[64];
      if (lua_isinteger(L, indice)) {
        snprintf(temp, sizeof(temp), "%lld",
                 (long long) lua_tointeger(L, indice));
      } else {
        double d = lua_tonumber(L, indice);
        if (d != d || d == HUGE_VAL || d == -HUGE_VAL) {
          luaL_addstring(b, "null");
          return;
        }
        snprintf(temp, sizeof(temp), "%.14g", d);
      }
      luaL_addstring(b, temp);
      return;
    }

    case LUA_TSTRING: {
      size_t n;
      const char *s = lua_tolstring(L, indice, &n);
      aggiungiStringa(b, s, n);
      return;
    }

    case LUA_TTABLE: {
      luaL_checkstack(L, 6, "json troppo profondo");
      if (eSequenza(L, indice)) {
        lua_Integer n = luaL_len(L, indice);
        luaL_addchar(b, '[');
        for (lua_Integer i = 1; i <= n; i++) {
          if (i > 1) luaL_addchar(b, ',');
          lua_geti(L, indice, i);
          codifica(L, -1, b, profondita + 1);
          lua_pop(L, 1);
        }
        luaL_addchar(b, ']');
      } else {
        luaL_addchar(b, '{');
        int primo = 1;
        lua_pushnil(L);
        while (lua_next(L, indice) != 0) {
          if (lua_type(L, -2) == LUA_TSTRING) {
            if (!primo) luaL_addchar(b, ',');
            primo = 0;
            size_t nk;
            /* copiamo la chiave: lua_tolstring su una
               chiave numerica romperebbe lua_next */
            lua_pushvalue(L, -2);
            const char *k = lua_tolstring(L, -1, &nk);
            aggiungiStringa(b, k, nk);
            lua_pop(L, 1);
            luaL_addchar(b, ':');
            codifica(L, -1, b, profondita + 1);
          }
          lua_pop(L, 1);
        }
        luaL_addchar(b, '}');
      }
      return;
    }

    default:
      luaL_error(L, "tipo non serializzabile: %s",
                 luaL_typename(L, indice));
  }
}

static int l_json(lua_State *L) {
  luaL_checkany(L, 1);
  luaL_Buffer b;
  luaL_buffinit(L, &b);
  codifica(L, 1, &b, 0);
  luaL_pushresult(&b);
  return 1;
}

static const char *PROVE =
  "local casi = {\n"
  "  {'numeri', {1, 2.5, -3, 0}},\n"
  "  {'stringhe', {'a', 'con \\\"virgolette\\\"',\n"
  "                'con\\\\nacapo'}},\n"
  "  {'oggetto', {nome = 'Anna', eta = 34,\n"
  "               attivo = true}},\n"
  "  {'annidato', {a = {b = {c = {1, 2}}}}},\n"
  "  {'vuoto array', {}},\n"
  "  {'misto', {1, 2, nome = 'x'}},\n"
  "  {'booleani', {true, false}},\n"
  "}\n"
  "for _, c in ipairs(casi) do\n"
  "  print(string.format('%-14s %s', c[1],\n"
  "    json(c[2])))\n"
  "end\n"
  "local ciclo = {}\n"
  "ciclo.se = ciclo\n"
  "print('ciclico:      ',\n"
  "  select(2, pcall(json, ciclo)))\n"
  "print('funzione:     ',\n"
  "  select(2, pcall(json, print)))\n";

int main(void) {
  lua_State *L = luaL_newstate();
  luaL_openlibs(L);

  lua_pushcfunction(L, l_json);
  lua_setglobal(L, "json");

  if (luaL_dostring(L, PROVE) != LUA_OK) {
    fprintf(stderr, "%s\n", lua_tostring(L, -1));
  }

  lua_close(L);
  return 0;
}
