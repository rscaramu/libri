/* ES 26.7 — Il longjmp che perde memoria
   Manuale completo di Lua */

#include <stdlib.h>
#include <string.h>
#include <lua.h>
#include <lauxlib.h>

/* Contatore di allocazioni non liberate, per rendere
   visibile la perdita senza strumenti esterni. */
static long allocazioni = 0;
static long liberazioni = 0;

static void *miaAlloc(size_t n) {
  allocazioni++;
  return malloc(n);
}

static void miaFree(void *p) {
  if (p != NULL) {
    liberazioni++;
    free(p);
  }
}

/* VERSIONE DIFETTOSA: alloca, poi valida.
   Se la validazione fallisce, luaL_checkstring
   fa longjmp e il buffer non viene mai liberato. */
static int l_perde(lua_State *L) {
  size_t dimensione = 1024;
  char *buffer = (char *) miaAlloc(dimensione);
  if (buffer == NULL) {
    return luaL_error(L, "memoria insufficiente");
  }

  /* Qui il longjmp puo' scattare */
  const char *s = luaL_checkstring(L, 1);
  lua_Integer n = luaL_checkinteger(L, 2);

  snprintf(buffer, dimensione, "%s ripetuto %d volte",
           s, (int) n);
  lua_pushstring(L, buffer);
  miaFree(buffer);
  return 1;
}

/* CORREZIONE 1: validare PRIMA di allocare. */
static int l_validaPrima(lua_State *L) {
  const char *s = luaL_checkstring(L, 1);
  lua_Integer n = luaL_checkinteger(L, 2);

  size_t dimensione = 1024;
  char *buffer = (char *) miaAlloc(dimensione);
  if (buffer == NULL) {
    return luaL_error(L, "memoria insufficiente");
  }

  snprintf(buffer, dimensione, "%s ripetuto %d volte",
           s, (int) n);
  lua_pushstring(L, buffer);
  miaFree(buffer);
  return 1;
}

/* CORREZIONE 2: far gestire la memoria a Lua.
   L'userdata viene raccolto anche in caso di errore. */
static int l_conUserdata(lua_State *L) {
  size_t dimensione = 1024;
  char *buffer = (char *) lua_newuserdatauv(L,
    dimensione, 0);

  const char *s = luaL_checkstring(L, 1);
  lua_Integer n = luaL_checkinteger(L, 2);

  snprintf(buffer, dimensione, "%s ripetuto %d volte",
           s, (int) n);
  lua_pushstring(L, buffer);
  return 1;
}

static int l_statistiche(lua_State *L) {
  lua_pushinteger(L, allocazioni);
  lua_pushinteger(L, liberazioni);
  lua_pushinteger(L, allocazioni - liberazioni);
  return 3;
}

static const luaL_Reg FUNZIONI[] = {
  {"perde", l_perde},
  {"validaPrima", l_validaPrima},
  {"conUserdata", l_conUserdata},
  {"statistiche", l_statistiche},
  {NULL, NULL}
};

int luaopen_perdita(lua_State *L) {
  luaL_newlib(L, FUNZIONI);
  return 1;
}
