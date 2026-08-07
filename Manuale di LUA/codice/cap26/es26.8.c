/* ES 26.8 — Stati Lua indipendenti
   Manuale completo di Lua */

#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

#define CHIAVE_CONTESTO "app.contesto"

typedef struct {
  char nome[32];
  int contatore;
} Contesto;

static Contesto *contesto(lua_State *L) {
  lua_getfield(L, LUA_REGISTRYINDEX, CHIAVE_CONTESTO);
  Contesto *c = (Contesto *) lua_touserdata(L, -1);
  lua_pop(L, 1);
  return c;
}

static int api_nome(lua_State *L) {
  lua_pushstring(L, contesto(L)->nome);
  return 1;
}

static int api_incrementa(lua_State *L) {
  Contesto *c = contesto(L);
  c->contatore += (int) luaL_optinteger(L, 1, 1);
  lua_pushinteger(L, c->contatore);
  return 1;
}

static const luaL_Reg API[] = {
  {"nome", api_nome},
  {"incrementa", api_incrementa},
  {NULL, NULL}
};

static lua_State *creaStato(Contesto *c) {
  lua_State *L = luaL_newstate();
  if (L == NULL) return NULL;

  static const luaL_Reg librerie[] = {
    {LUA_GNAME,      luaopen_base},
    {LUA_TABLIBNAME, luaopen_table},
    {LUA_STRLIBNAME, luaopen_string},
    {NULL, NULL}
  };
  for (const luaL_Reg *l = librerie; l->func; l++) {
    luaL_requiref(L, l->name, l->func, 1);
    lua_pop(L, 1);
  }

  lua_pushlightuserdata(L, c);
  lua_setfield(L, LUA_REGISTRYINDEX, CHIAVE_CONTESTO);

  luaL_newlib(L, API);
  lua_setglobal(L, "app");

  return L;
}

static void esegui(lua_State *L, const char *nome,
                   const char *codice) {
  if (luaL_dostring(L, codice) != LUA_OK) {
    printf("  [%s] errore: %s\n", nome,
           lua_tostring(L, -1));
    lua_pop(L, 1);
  }
}

int main(void) {
  Contesto ca = {"stato-A", 0};
  Contesto cb = {"stato-B", 0};
  Contesto cc = {"stato-C", 0};

  lua_State *A = creaStato(&ca);
  lua_State *B = creaStato(&cb);
  lua_State *C = creaStato(&cc);

  printf("=== ogni stato vede il proprio contesto ===\n");
  const char *identifica =
    "print('  io sono ' .. app.nome())";
  esegui(A, "A", identifica);
  esegui(B, "B", identifica);
  esegui(C, "C", identifica);

  printf("=== le globali non sono condivise ===\n");
  esegui(A, "A", "segreto = 'solo di A'\n"
    "tabellaCondivisa = {1, 2, 3}");
  esegui(B, "B",
    "print('  B vede segreto: ' "
    ".. tostring(segreto))\n"
    "print('  B vede tabellaCondivisa: ' "
    ".. tostring(tabellaCondivisa))");
  esegui(C, "C",
    "print('  C vede segreto: ' "
    ".. tostring(segreto))");

  printf("=== i contatori sono indipendenti ===\n");
  esegui(A, "A", "app.incrementa(10)");
  esegui(A, "A", "app.incrementa(10)");
  esegui(B, "B", "app.incrementa(1)");
  printf("  A=%d  B=%d  C=%d\n",
         ca.contatore, cb.contatore, cc.contatore);

  printf("=== un errore in uno non tocca gli altri "
         "===\n");
  esegui(A, "A", "error('guasto in A')");
  esegui(B, "B",
    "print('  B funziona ancora, contatore=' "
    ".. app.incrementa(0))");

  printf("=== chiudere uno non tocca gli altri ===\n");
  lua_close(A);
  esegui(B, "B",
    "print('  B ancora vivo: ' .. app.nome())");
  esegui(C, "C",
    "print('  C ancora vivo: ' .. app.nome())");

  lua_close(B);
  lua_close(C);
  printf("tutti chiusi.\n");
  return 0;
}
