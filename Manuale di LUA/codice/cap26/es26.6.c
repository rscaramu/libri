/* ES 26.6 — Contatore ad alta risoluzione
   Manuale completo di Lua */

#include <time.h>
#include <lua.h>
#include <lauxlib.h>

#define NOME_TIMER "prestazioni.Timer"

typedef struct {
  struct timespec inizio;
  long long accumulato;   /* in nanosecondi */
  int attivo;
} Timer;

static long long adesso(void) {
  struct timespec t;
  clock_gettime(CLOCK_MONOTONIC, &t);
  return (long long) t.tv_sec * 1000000000LL
       + (long long) t.tv_nsec;
}

static Timer *controlla(lua_State *L, int i) {
  return (Timer *) luaL_checkudata(L, i, NOME_TIMER);
}

static int l_nuovo(lua_State *L) {
  Timer *t = (Timer *) lua_newuserdatauv(L,
    sizeof(Timer), 0);
  t->accumulato = 0;
  t->attivo = 0;
  luaL_setmetatable(L, NOME_TIMER);
  return 1;
}

static int l_avvia(lua_State *L) {
  Timer *t = controlla(L, 1);
  if (t->attivo) {
    return luaL_error(L, "timer gia' avviato");
  }
  clock_gettime(CLOCK_MONOTONIC, &t->inizio);
  t->attivo = 1;
  lua_pushvalue(L, 1);
  return 1;
}

static int l_ferma(lua_State *L) {
  Timer *t = controlla(L, 1);
  if (!t->attivo) {
    return luaL_error(L, "timer non avviato");
  }
  long long fine = adesso();
  long long partenza =
    (long long) t->inizio.tv_sec * 1000000000LL
    + (long long) t->inizio.tv_nsec;
  t->accumulato += fine - partenza;
  t->attivo = 0;
  lua_pushnumber(L, (double) t->accumulato / 1000.0);
  return 1;
}

static int l_azzera(lua_State *L) {
  Timer *t = controlla(L, 1);
  t->accumulato = 0;
  t->attivo = 0;
  lua_pushvalue(L, 1);
  return 1;
}

static int l_microsecondi(lua_State *L) {
  Timer *t = controlla(L, 1);
  long long totale = t->accumulato;
  if (t->attivo) {
    long long partenza =
      (long long) t->inizio.tv_sec * 1000000000LL
      + (long long) t->inizio.tv_nsec;
    totale += adesso() - partenza;
  }
  lua_pushnumber(L, (double) totale / 1000.0);
  return 1;
}

static int l_tostring(lua_State *L) {
  Timer *t = controlla(L, 1);
  lua_pushfstring(L, "Timer(%f us%s)",
    (double) t->accumulato / 1000.0,
    t->attivo ? ", in corso" : "");
  return 1;
}

static int l_risoluzione(lua_State *L) {
  struct timespec r;
  clock_getres(CLOCK_MONOTONIC, &r);
  lua_pushnumber(L, (double) r.tv_sec * 1e9
                    + (double) r.tv_nsec);
  return 1;
}

static const luaL_Reg METODI[] = {
  {"avvia", l_avvia},
  {"ferma", l_ferma},
  {"azzera", l_azzera},
  {"microsecondi", l_microsecondi},
  {NULL, NULL}
};

static const luaL_Reg MODULO[] = {
  {"nuovo", l_nuovo},
  {"risoluzione", l_risoluzione},
  {NULL, NULL}
};

int luaopen_cronometro(lua_State *L) {
  luaL_newmetatable(L, NOME_TIMER);
  lua_pushcfunction(L, l_tostring);
  lua_setfield(L, -2, "__tostring");
  luaL_newlib(L, METODI);
  lua_setfield(L, -2, "__index");
  lua_pop(L, 1);

  luaL_newlib(L, MODULO);
  return 1;
}
