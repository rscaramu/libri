/* ES 26.5 — Righe della matrice come oggetti
   Manuale completo di Lua */

#include <stdlib.h>
#include <lua.h>
#include <lauxlib.h>

#define NOME_MATRICE "algebra2.Matrice"
#define NOME_RIGA    "algebra2.Riga"

typedef struct {
  int righe, colonne;
  double *v;
} Matrice;

typedef struct {
  int riga;
  /* riferimento alla matrice nel registro, per
     impedirne la raccolta finche' la riga vive */
  int riferimento;
} Riga;

static Matrice *matriceDaRiga(lua_State *L, Riga *r) {
  lua_rawgeti(L, LUA_REGISTRYINDEX, r->riferimento);
  Matrice *m = (Matrice *) luaL_checkudata(L, -1,
    NOME_MATRICE);
  lua_pop(L, 1);
  return m;
}

static int riga_index(lua_State *L) {
  Riga *r = (Riga *) luaL_checkudata(L, 1, NOME_RIGA);
  lua_Integer c = luaL_checkinteger(L, 2);
  Matrice *m = matriceDaRiga(L, r);

  luaL_argcheck(L, c >= 1 && c <= m->colonne, 2,
                "colonna fuori intervallo");
  lua_pushnumber(L,
    m->v[(r->riga - 1) * m->colonne + (c - 1)]);
  return 1;
}

static int riga_newindex(lua_State *L) {
  Riga *r = (Riga *) luaL_checkudata(L, 1, NOME_RIGA);
  lua_Integer c = luaL_checkinteger(L, 2);
  double valore = luaL_checknumber(L, 3);
  Matrice *m = matriceDaRiga(L, r);

  luaL_argcheck(L, c >= 1 && c <= m->colonne, 2,
                "colonna fuori intervallo");
  m->v[(r->riga - 1) * m->colonne + (c - 1)] = valore;
  return 0;
}

static int riga_len(lua_State *L) {
  Riga *r = (Riga *) luaL_checkudata(L, 1, NOME_RIGA);
  Matrice *m = matriceDaRiga(L, r);
  lua_pushinteger(L, m->colonne);
  return 1;
}

static int riga_gc(lua_State *L) {
  Riga *r = (Riga *) luaL_checkudata(L, 1, NOME_RIGA);
  if (r->riferimento != LUA_NOREF) {
    luaL_unref(L, LUA_REGISTRYINDEX, r->riferimento);
    r->riferimento = LUA_NOREF;
  }
  return 0;
}

static int riga_tostring(lua_State *L) {
  Riga *r = (Riga *) luaL_checkudata(L, 1, NOME_RIGA);
  Matrice *m = matriceDaRiga(L, r);
  luaL_Buffer b;
  luaL_buffinit(L, &b);
  luaL_addstring(&b, "[");
  for (int j = 0; j < m->colonne; j++) {
    char temp[32];
    snprintf(temp, sizeof(temp), "%s%.2f",
             j > 0 ? " " : "",
             m->v[(r->riga - 1) * m->colonne + j]);
    luaL_addstring(&b, temp);
  }
  luaL_addstring(&b, "]");
  luaL_pushresult(&b);
  return 1;
}

static int matrice_index(lua_State *L) {
  Matrice *m = (Matrice *) luaL_checkudata(L, 1,
    NOME_MATRICE);

  if (lua_type(L, 2) == LUA_TNUMBER) {
    lua_Integer i = luaL_checkinteger(L, 2);
    luaL_argcheck(L, i >= 1 && i <= m->righe, 2,
                  "riga fuori intervallo");

    Riga *r = (Riga *) lua_newuserdatauv(L,
      sizeof(Riga), 0);
    r->riga = (int) i;
    r->riferimento = LUA_NOREF;
    luaL_setmetatable(L, NOME_RIGA);

    lua_pushvalue(L, 1);
    r->riferimento = luaL_ref(L, LUA_REGISTRYINDEX);
    return 1;
  }

  luaL_getmetatable(L, NOME_MATRICE);
  lua_getfield(L, -1, "__metodi");
  lua_pushvalue(L, 2);
  lua_gettable(L, -2);
  return 1;
}

static int matrice_len(lua_State *L) {
  Matrice *m = (Matrice *) luaL_checkudata(L, 1,
    NOME_MATRICE);
  lua_pushinteger(L, m->righe);
  return 1;
}

static int matrice_gc(lua_State *L) {
  Matrice *m = (Matrice *) luaL_checkudata(L, 1,
    NOME_MATRICE);
  if (m->v != NULL) {
    free(m->v);
    m->v = NULL;
  }
  return 0;
}

static int matrice_dimensioni(lua_State *L) {
  Matrice *m = (Matrice *) luaL_checkudata(L, 1,
    NOME_MATRICE);
  lua_pushinteger(L, m->righe);
  lua_pushinteger(L, m->colonne);
  return 2;
}

static int l_nuova(lua_State *L) {
  lua_Integer righe = luaL_checkinteger(L, 1);
  lua_Integer colonne = luaL_checkinteger(L, 2);
  luaL_argcheck(L, righe >= 1, 1, "righe non valide");
  luaL_argcheck(L, colonne >= 1, 2,
                "colonne non valide");

  Matrice *m = (Matrice *) lua_newuserdatauv(L,
    sizeof(Matrice), 0);
  m->righe = (int) righe;
  m->colonne = (int) colonne;
  m->v = NULL;
  luaL_setmetatable(L, NOME_MATRICE);

  m->v = (double *) calloc((size_t) (righe * colonne),
                           sizeof(double));
  if (m->v == NULL) {
    return luaL_error(L, "memoria insufficiente");
  }
  return 1;
}

static const luaL_Reg METODI_MATRICE[] = {
  {"dimensioni", matrice_dimensioni},
  {NULL, NULL}
};

int luaopen_matrice2(lua_State *L) {
  luaL_newmetatable(L, NOME_RIGA);
  lua_pushcfunction(L, riga_index);
  lua_setfield(L, -2, "__index");
  lua_pushcfunction(L, riga_newindex);
  lua_setfield(L, -2, "__newindex");
  lua_pushcfunction(L, riga_len);
  lua_setfield(L, -2, "__len");
  lua_pushcfunction(L, riga_gc);
  lua_setfield(L, -2, "__gc");
  lua_pushcfunction(L, riga_tostring);
  lua_setfield(L, -2, "__tostring");
  lua_pop(L, 1);

  luaL_newmetatable(L, NOME_MATRICE);
  lua_pushcfunction(L, matrice_index);
  lua_setfield(L, -2, "__index");
  lua_pushcfunction(L, matrice_len);
  lua_setfield(L, -2, "__len");
  lua_pushcfunction(L, matrice_gc);
  lua_setfield(L, -2, "__gc");
  luaL_newlib(L, METODI_MATRICE);
  lua_setfield(L, -2, "__metodi");
  lua_pop(L, 1);

  lua_createtable(L, 0, 1);
  lua_pushcfunction(L, l_nuova);
  lua_setfield(L, -2, "nuova");
  return 1;
}
