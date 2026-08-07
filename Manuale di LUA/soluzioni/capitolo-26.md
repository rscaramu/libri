# Capitolo 26 — Estendere Lua in C e incorporare Lua in un’applicazione

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 25](capitolo-25.md) · [Indice](README.md) · [Capitolo 27 →](capitolo-27.md)

I 9 sorgenti eseguibili di questo capitolo sono in
[`codice/cap26/`](../codice/cap26/).

---

**ES 26.4 — Sostituzione letterale**

*Estendi il modulo `testo` dell’ES 26.1 con una funzione che
sostituisca tutte le occorrenze di una sottostringa letterale con
un’altra, senza usare i pattern, restituendo anche il numero di
sostituzioni.*

```c
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
```

La prova:

```lua
local t = require("testo2")

local casi = {
  {"abcabc", "b", "X"},
  {"abcabc", "abc", "-"},
  {"aaaa", "aa", "b"},
  {"niente", "x", "y"},
  {"a.b.c", ".", "/"},
  {"a%b", "%", "%%"},
  {"prefisso", "pre", ""},
  {"", "x", "y"},
  {"aaa", "a", "aa"},
}

for _, c in ipairs(casi) do
  local r, n = t.sostituisci(c[1], c[2], c[3])
  print(string.format("%-10s %-6s -> %-6s = %-12s (%d)",
    "[" .. c[1] .. "]", "[" .. c[2] .. "]",
    "[" .. c[3] .. "]", "[" .. r .. "]", n))
end

print(t.sostituisci("aaaa", "a", "X", 2))
print(pcall(t.sostituisci, "abc", "", "x"))
```

produce:

```text
[abcabc]   [b]    -> [X]    = [aXcaXc]     (2)
[abcabc]   [abc]  -> [-]    = [--]         (2)
[aaaa]     [aa]   -> [b]    = [bb]         (2)
[niente]   [x]    -> [y]    = [niente]     (0)
[a.b.c]    [.]    -> [/]    = [a/b/c]      (2)
[a%b]      [%]    -> [%%]   = [a%%b]       (1)
[prefisso] [pre]  -> []     = [fisso]      (1)
[]         [x]    -> [y]    = []           (0)
[aaa]      [a]    -> [aa]   = [aaaaaa]     (3)
XXaa	2
false	sottostringa da cercare vuota
```

Il valore di questa funzione rispetto a `string.gsub` sta in due
proprietà.

**Nessun carattere è magico.** Il punto, il percento e le parentesi
quadre si comportano letteralmente sia nella ricerca sia nella
sostituzione: la riga `[a%b]` produce `a%%b`, cioè esattamente i due
caratteri richiesti, mentre `gsub` avrebbe interpretato `%%` come un
percento solo.

**Nessuna corrispondenza vuota.** La lunghezza della sottostringa cercata
è verificata non nulla, quindi il problema del Capitolo 18 non si pone.

L’avanzamento di `nDa` dopo una sostituzione produce corrispondenze
**non sovrapposte**: su `aaaa` cercando `aa` si ottengono due
sostituzioni e non tre. È una scelta, ed è quella dello standard.

Il caso `[aaa]` con sostituzione più lunga dell’originale conferma che
non si rientra nel testo già sostituito: il risultato è `aaaaaa` e non un
ciclo infinito.

**ES 26.5 — Righe della matrice come oggetti**

*Aggiungi al tipo matrice dell’ES 26.2 i metametodi `__index` e
`__newindex` in modo che `m[2][3]` funzioni sia in lettura sia in
scrittura, restituendo un oggetto riga che si comporti come una
sequenza.*

```c
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
```

La prova:

```lua
local matrice = require("matrice2")

local m = matrice.nuova(3, 4)

for i = 1, 3 do
  for j = 1, 4 do
    m[i][j] = i * 10 + j
  end
end

for i = 1, 3 do
  print("riga " .. i .. ": " .. tostring(m[i]))
end

print("m[2][3] = " .. m[2][3])
print("righe: " .. #m .. ", colonne: " .. #m[1])
print("dimensioni: " .. m:dimensioni())

local riga = m[2]
riga[1] = 999
print("dopo modifica via riga: " .. m[2][1])

print(pcall(function() return m[9] end))
print(pcall(function() return m[1][9] end))
print(pcall(function() m[1][0] = 1 end))
```

produce:

```text
riga 1: [11.00 12.00 13.00 14.00]
riga 2: [21.00 22.00 23.00 24.00]
riga 3: [31.00 32.00 33.00 34.00]
m[2][3] = 23.0
righe: 3, colonne: 4
dimensioni: 3
dopo modifica via riga: 999.0
false	...:23: bad argument #2 to 'index'
	(riga fuori intervallo)
false	...:24: bad argument #2 to 'index'
	(colonna fuori intervallo)
false	...:25: bad argument #2 to 'newindex'
	(colonna fuori intervallo)
```

Due dettagli dell’output meritano una nota. La riga `dimensioni` mostra
solo il numero delle righe, perché la concatenazione con `..` prende un
solo valore dai due restituiti: è la regola del Capitolo 8, ed è un buon
promemoria di quanto sia facile perdere valori senza accorgersene. E i
messaggi d’errore riportano l’argomento numero due e non uno, perché
`luaL_argcheck` non applica lo spostamento per la chiamata con i due
punti quando la funzione è invocata come metametodo.

La differenza sostanziale rispetto alla versione Lua dell’ES 13.6 è la
**gestione della vita**. Un oggetto riga è un userdata separato che
riferisce la matrice: se la matrice venisse raccolta mentre la riga vive,
la riga punterebbe a memoria liberata.

La soluzione è `luaL_ref`: la riga registra un riferimento alla matrice
nel registro, che la mantiene viva, e lo rilascia con `luaL_unref` nel
proprio `__gc`. È l’uso canonico della coppia descritta nel paragrafo
26.7.

Il costo è che ogni `m[i]` alloca un userdata e registra un riferimento.
In un ciclo `for i, j` questo costa parecchio, e la versione con cache
delle righe dell’ES 13.6 sarebbe preferibile. Il vantaggio è la
correttezza: una riga può sopravvivere alla variabile che conteneva la
matrice.

**ES 26.6 — Contatore ad alta risoluzione**

*Scrivi un modulo C che esponga un contatore di prestazioni basato
sull’orologio ad alta risoluzione del sistema, con metodi per
avviare, fermare e leggere il tempo trascorso in microsecondi.*

```c
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
```

La prova, confrontata con `os.clock`:

```lua
local cronometro = require("cronometro")

print(string.format("risoluzione dell'orologio: %.0f ns",
  cronometro.risoluzione()))

local function lavoro(n)
  local s = 0
  for i = 1, n do s = s + math.sqrt(i) end
  return s
end

print()
print("misura di operazioni molto brevi:")
for _, n in ipairs({10, 100, 1000, 10000}) do
  local t = cronometro.nuovo()
  local c1 = os.clock()
  t:avvia()
  lavoro(n)
  local us = t:ferma()
  local osclock = (os.clock() - c1) * 1e6
  print(string.format("  n=%6d  cronometro %9.2f us"
    .. "   os.clock %9.2f us", n, us, osclock))
end

print()
print("accumulo su piu' intervalli:")
local t = cronometro.nuovo()
for i = 1, 5 do
  t:avvia()
  lavoro(10000)
  t:ferma()
end
print("  totale di 5 misure: "
  .. string.format("%.2f us", t:microsecondi()))
print("  " .. tostring(t))

print()
print(pcall(function() t:ferma() end))
t:azzera()
print("dopo azzera: " .. t:microsecondi())
```

Il confronto con `os.clock` mostra il limite di quest’ultimo: la sua
risoluzione è tipicamente di **microsecondi o peggio**, e su operazioni
che durano meno di dieci microsecondi restituisce spesso zero o valori a
scatti.

`clock_gettime` con `CLOCK_MONOTONIC` ha risoluzione di nanosecondi ed è
**monotono**: non torna indietro se l’orologio di sistema viene
corretto, il che lo rende adatto a misurare intervalli. `CLOCK_REALTIME`
non offre questa garanzia.

Il timer accumula su più intervalli invece di sostituire la misura
precedente: è ciò che serve per sommare il tempo speso in una funzione
chiamata molte volte, come nel profilatore del paragrafo 29.7.

Va segnalato che `clock_gettime` è POSIX: su Windows serve
`QueryPerformanceCounter`, e un modulo portabile richiederebbe la
compilazione condizionale.

**ES 26.7 — Il longjmp che perde memoria**

*Dimostra sperimentalmente il problema del `longjmp` con `malloc`:
scrivi una funzione C che allochi memoria e poi sollevi un errore
Lua, e verifica con uno strumento di analisi che la memoria venga
persa. Poi correggila.*

```c
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
```

La prova:

```lua
local p = require("perdita")

local function mostra(etichetta)
  local a, l, differenza = p.statistiche()
  print(string.format("%-28s alloc=%d free=%d "
    .. "perse=%d", etichetta, a, l, differenza))
end

mostra("stato iniziale")

for i = 1, 100 do
  p.perde("prova", 3)
end
mostra("100 chiamate corrette")

for i = 1, 100 do
  pcall(p.perde, 42, "non un numero")
end
mostra("100 chiamate con errore")

for i = 1, 100 do
  pcall(p.validaPrima, 42, "non un numero")
end
mostra("100 con validaPrima")

for i = 1, 100 do
  pcall(p.conUserdata, 42, "non un numero")
end
collectgarbage("collect")
mostra("100 con userdata")

print()
print("le tre versioni sono equivalenti in uso normale:")
print("  " .. p.perde("x", 1))
print("  " .. p.validaPrima("x", 1))
print("  " .. p.conUserdata("x", 1))
```

produce:

```text
stato iniziale               alloc=0 free=0 perse=0
100 chiamate corrette        alloc=100 free=100 perse=0
100 chiamate con errore      alloc=200 free=100 perse=100
100 con validaPrima          alloc=200 free=100 perse=100
100 con userdata             alloc=200 free=100 perse=100
```

La dimostrazione è netta. Le cento chiamate corrette allocano e liberano
in pari. Le cento chiamate che falliscono la validazione allocano e
**non liberano mai**: cento buffer da un kilobyte, centomila byte persi
in modo permanente.

Le due correzioni non aggiungono allocazioni, perché non arrivano mai ad
allocare: `validaPrima` fallisce prima del `malloc`, e `conUserdata` non
usa `malloc` affatto.

Il contatore non aumenta più in nessuna delle due righe successive, che è
esattamente la prova richiesta.

Delle due correzioni, la **validazione anticipata** è la più semplice e
va preferita quando è possibile. L’**userdata** è necessaria quando la
dimensione da allocare dipende da un argomento che va prima validato, o
quando fra l’allocazione e il rilascio ci sono più punti in cui un errore
può scattare.

Con `valgrind` la stessa perdita apparirebbe come *definitely lost*,
con la traccia di allocazione: è il modo di trovarla in un modulo vero,
dove non c’è un contatore predisposto.

**ES 26.8 — Stati Lua indipendenti**

*Scrivi un’applicazione C che carichi più script Lua in stati
separati, esponga a ciascuno la stessa API, e verifichi che le
variabili globali di uno script non siano visibili dagli altri.*

```c
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
```

produce:

```text
=== ogni stato vede il proprio contesto ===
  io sono stato-A
  io sono stato-B
  io sono stato-C
=== le globali non sono condivise ===
  B vede segreto: nil
  B vede tabellaCondivisa: nil
  C vede segreto: nil
=== i contatori sono indipendenti ===
  A=20  B=1  C=0
=== un errore in uno non tocca gli altri ===
  [A] errore: [string "error('guasto in A')"]:1:
  guasto in A
  B funziona ancora, contatore=1
=== chiudere uno non tocca gli altri ===
  B ancora vivo: stato-B
  C ancora vivo: stato-C
tutti chiusi.
```

La verifica richiesta è nella seconda sezione: una variabile globale
creata in A **non esiste** in B né in C. Ogni stato Lua ha la propria
tabella globale, la propria tabella delle stringhe, il proprio garbage
collector e il proprio stack.

L’elemento che rende funzionante questa architettura è la conservazione
del contesto nel **registro** invece che in una variabile globale del C.
Con una variabile globale del C, tutti e tre gli stati vedrebbero lo
stesso contesto e le funzioni `app.nome` restituirebbero lo stesso
valore, come segnalato nel paragrafo 26.4.

L’isolamento non è però totale: gli stati condividono il **processo**.
Un modulo C caricato in due stati ha le proprie variabili statiche
condivise, e un ciclo infinito o un crollo in uno stato blocca o abbatte
tutti gli altri. Per l’isolamento vero servono processi separati.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
