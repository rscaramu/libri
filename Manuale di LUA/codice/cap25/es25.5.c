/* ES 25.5 — Limite di tempo con hook
   Manuale completo di Lua */

#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

typedef struct {
  long limite;
  long eseguite;
  int superato;
} Contatore;

static Contatore contatore;

static void hook(lua_State *L, lua_Debug *ar) {
  (void) ar;
  contatore.eseguite += 1000;
  if (contatore.eseguite >= contatore.limite) {
    contatore.superato = 1;
    lua_sethook(L, NULL, 0, 0);
    luaL_error(L, "limite di istruzioni superato "
               "(%d)", (int) contatore.eseguite);
  }
}

static int esegui(lua_State *L, const char *codice,
                  long limite) {
  contatore.limite = limite;
  contatore.eseguite = 0;
  contatore.superato = 0;

  if (luaL_loadbufferx(L, codice, strlen(codice),
                       "prova", "t") != LUA_OK) {
    printf("  compilazione: %s\n",
           lua_tostring(L, -1));
    lua_pop(L, 1);
    return 0;
  }

  lua_sethook(L, hook, LUA_MASKCOUNT, 1000);
  int esito = lua_pcall(L, 0, 1, 0);
  lua_sethook(L, NULL, 0, 0);

  if (esito != LUA_OK) {
    printf("  interrotto dopo %ld istruzioni: %s\n",
           contatore.eseguite, lua_tostring(L, -1));
    lua_pop(L, 1);
    return 0;
  }

  printf("  completato in circa %ld istruzioni, "
         "risultato %s\n", contatore.eseguite,
         lua_tostring(L, -1));
  lua_pop(L, 1);
  return 1;
}

int main(void) {
  lua_State *L = luaL_newstate();
  luaL_openlibs(L);

  const char *casi[][2] = {
    {"calcolo breve", "local s = 0\n"
     "for i = 1, 1000 do s = s + i end\nreturn s"},
    {"calcolo lungo", "local s = 0\n"
     "for i = 1, 10000000 do s = s + i end\nreturn s"},
    {"ciclo infinito", "while true do end"},
    {"ricorsione infinita",
     "local function f() return 1 + f() end\n"
     "return f()"},
    {"errore di sintassi", "return 1 +"},
    {NULL, NULL}
  };

  for (int i = 0; casi[i][0] != NULL; i++) {
    printf("%s:\n", casi[i][0]);
    esegui(L, casi[i][1], 500000);
  }

  lua_close(L);
  return 0;
}
