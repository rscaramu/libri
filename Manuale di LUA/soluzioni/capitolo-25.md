# Capitolo 25 — L’API C: lo stack, i tipi, le chiamate

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 24](capitolo-24.md) · [Indice](README.md) · [Capitolo 26 →](capitolo-26.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap25/`](../codice/cap25/).

---

**ES 25.4 — Profondità di annidamento**

*Scrivi una funzione C che, data una tabella Lua sullo stack, ne
calcoli la profondità massima di annidamento, gestendo i riferimenti
circolari senza ricorsione infinita.*

```c
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
```

Il punto delicato è la gestione dei cicli. La tabella `viste` usa come
chiave il **puntatore** della tabella, ottenuto con `lua_topointer` e
inserito come light userdata: è l’identità dell’oggetto, ed è ciò che
permette di riconoscere una tabella già in esame.

Il segno viene **rimosso** al termine della visita, non lasciato: senza
la rimozione, una tabella condivisa fra due rami verrebbe visitata una
volta sola e la profondità del secondo ramo risulterebbe zero. Con la
rimozione, il segno protegge solo dai cicli lungo il percorso corrente.

`lua_absindex` converte l’indice in assoluto: dopo aver inserito valori
sullo stack, un indice negativo passato dal chiamante non punterebbe più
allo stesso elemento.

`luaL_checkstack` è obbligatorio prima di una ricorsione che inserisce
elementi: la garanzia di venti posizioni si esaurisce in fretta.

Notate anche `lua_tostring` sulla chiave in `lua_next`: qui è sicuro
perché le chiavi sono stringhe, ma su chiavi numeriche
**modificherebbe lo stack** e romperebbe l’iterazione, come avvertito nel
paragrafo 25.4.

**ES 25.5 — Limite di tempo con hook**

*Scrivi un programma C che esegua uno script Lua con un limite di
tempo, usando `lua_sethook` con conteggio di istruzioni, e verifica
che un ciclo infinito venga interrotto.*

```c
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
```

L’hook con maschera `LUA_MASKCOUNT` e conteggio mille viene invocato ogni
mille istruzioni della macchina virtuale. Il conteggio è quindi
approssimato al passo, il che è irrilevante per lo scopo.

`luaL_error` dentro l’hook solleva un errore Lua che si propaga fino al
`lua_pcall` esterno: è il modo corretto di interrompere. Notate che
l’hook viene **disinstallato prima** di sollevare l’errore, altrimenti
scatterebbe di nuovo durante la propagazione.

Il contatore è una variabile globale del C, il che è accettabile in
questo esempio ma inadeguato in una libreria vera: con più stati Lua, o
con più thread, andrebbe conservato nel registro come mostrato nel
paragrafo 26.8.

Questo meccanismo è ciò che manca alla sandbox in Lua puro del Capitolo
24: dal lato C l’hook non è disinstallabile dal codice in sandbox, perché
`debug` non è nemmeno aperto.

**ES 25.6 — Gestione dei valori di ritorno**

*Modifica il programma dell’ES 25.2 perché gestisca il caso in cui lo
script Lua restituisca `nil` più un messaggio d’errore, e quello in
cui restituisca una tabella con campi mancanti o di tipo sbagliato.*

```c
#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

typedef struct {
  char nome[32];
  double valore;
  int valido;
} Voce;

static const char *SCRIPT =
  "function elabora(dati, modalita)\n"
  "  if modalita == 'errore' then\n"
  "    return nil, 'elaborazione rifiutata'\n"
  "  end\n"
  "  if modalita == 'parziale' then\n"
  "    return {{nome = 'solo nome'},\n"
  "            {valore = 3.5},\n"
  "            {nome = 'completo', valore = 1.5}}\n"
  "  end\n"
  "  if modalita == 'tipi' then\n"
  "    return {{nome = 42, valore = 'testo'}}\n"
  "  end\n"
  "  if modalita == 'nontabella' then\n"
  "    return 'non e' .. 'una tabella'\n"
  "  end\n"
  "  local r = {}\n"
  "  for i, v in ipairs(dati) do\n"
  "    r[i] = {nome = v, valore = i * 1.5}\n"
  "  end\n"
  "  return r\n"
  "end\n";

static int leggiVoci(lua_State *L, int indice,
                     Voce *fuori, int massimo,
                     char *avvisi, size_t dimAvvisi) {
  indice = lua_absindex(L, indice);
  avvisi[0] = '\0';

  if (!lua_istable(L, indice)) {
    snprintf(avvisi, dimAvvisi,
             "atteso table, ricevuto %s",
             luaL_typename(L, indice));
    return -1;
  }

  lua_Integer quante = luaL_len(L, indice);
  if (quante > massimo) quante = massimo;

  int prodotte = 0;

  for (lua_Integer i = 1; i <= quante; i++) {
    lua_geti(L, indice, i);
    if (!lua_istable(L, -1)) {
      snprintf(avvisi + strlen(avvisi),
               dimAvvisi - strlen(avvisi),
               "voce %d non e' una tabella; ", (int) i);
      lua_pop(L, 1);
      continue;
    }

    Voce v;
    v.valido = 1;
    v.nome[0] = '\0';
    v.valore = 0.0;

    lua_getfield(L, -1, "nome");
    if (lua_type(L, -1) == LUA_TSTRING) {
      strncpy(v.nome, lua_tostring(L, -1),
              sizeof(v.nome) - 1);
      v.nome[sizeof(v.nome) - 1] = '\0';
    } else {
      snprintf(avvisi + strlen(avvisi),
               dimAvvisi - strlen(avvisi),
               "voce %d: nome %s; ", (int) i,
               lua_isnil(L, -1) ? "mancante"
                                : "di tipo errato");
      v.valido = 0;
    }
    lua_pop(L, 1);

    lua_getfield(L, -1, "valore");
    if (lua_isnumber(L, -1)) {
      v.valore = lua_tonumber(L, -1);
    } else {
      snprintf(avvisi + strlen(avvisi),
               dimAvvisi - strlen(avvisi),
               "voce %d: valore %s; ", (int) i,
               lua_isnil(L, -1) ? "mancante"
                                : "di tipo errato");
      v.valido = 0;
    }
    lua_pop(L, 1);

    fuori[prodotte++] = v;
    lua_pop(L, 1);
  }

  return prodotte;
}

static void prova(lua_State *L, const char *modalita) {
  printf("=== modalita' %s ===\n", modalita);

  lua_getglobal(L, "elabora");
  lua_createtable(L, 2, 0);
  lua_pushstring(L, "alfa");
  lua_seti(L, -2, 1);
  lua_pushstring(L, "beta");
  lua_seti(L, -2, 2);
  lua_pushstring(L, modalita);

  if (lua_pcall(L, 2, 2, 0) != LUA_OK) {
    printf("  chiamata fallita: %s\n",
           lua_tostring(L, -1));
    lua_pop(L, 1);
    return;
  }

  /* convenzione nil + messaggio */
  if (lua_isnil(L, -2)) {
    printf("  lo script ha segnalato: %s\n",
           lua_tostring(L, -1));
    lua_pop(L, 2);
    return;
  }
  lua_pop(L, 1);   /* scartiamo il secondo valore */

  Voce voci[16];
  char avvisi[512];
  int n = leggiVoci(L, -1, voci, 16, avvisi,
                    sizeof(avvisi));
  lua_pop(L, 1);

  if (n < 0) {
    printf("  struttura non valida: %s\n", avvisi);
    return;
  }

  printf("  %d voci lette\n", n);
  for (int i = 0; i < n; i++) {
    printf("    %-14s %8.2f  %s\n", voci[i].nome,
           voci[i].valore,
           voci[i].valido ? "ok" : "INCOMPLETA");
  }
  if (avvisi[0] != '\0') {
    printf("  avvisi: %s\n", avvisi);
  }
}

int main(void) {
  lua_State *L = luaL_newstate();
  luaL_openlibs(L);

  if (luaL_dostring(L, SCRIPT) != LUA_OK) {
    fprintf(stderr, "script: %s\n",
            lua_tostring(L, -1));
    lua_close(L);
    return 1;
  }

  prova(L, "normale");
  prova(L, "errore");
  prova(L, "parziale");
  prova(L, "tipi");
  prova(L, "nontabella");

  printf("stack finale: %d\n", lua_gettop(L));
  lua_close(L);
  return 0;
}
```

Le due situazioni richieste sono trattate separatamente.

La convenzione `nil` più messaggio si riconosce chiedendo **due**
risultati a `lua_pcall` e verificando se il primo è `nil`. Se lo è, il
secondo è il messaggio.

I campi mancanti o di tipo sbagliato non fanno fallire la lettura:
producono una voce marcata come incompleta e un avviso accumulato. È la
stessa scelta del validatore dell’ES 21.1, applicata dal lato C.

Notate `lua_type(L, -1) == LUA_TSTRING` invece di `lua_isstring`:
quest’ultima è vera anche per i numeri, e accetterebbe `nome = 42`
convertendolo. La verifica esatta è quella che rileva l’errore.

Il caso `nontabella` verifica il ramo in cui lo script restituisce
qualcosa che non è una sequenza, e la funzione lo segnala invece di
tentare l’iterazione.

**ES 25.7 — Serializzazione JSON dal C**

*Scrivi una funzione C che serializzi una tabella Lua in formato
JSON, gestendo stringhe con caratteri speciali, numeri interi e in
virgola mobile, booleani, e distinguendo array da oggetti.*

```c
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
```

produce:

```text
numeri         [1,2.5,-3,0]
stringhe       ["a","con \"virgolette\"","con\\nacapo"]
oggetto        {"nome":"Anna","eta":34,"attivo":true}
annidato       {"a":{"b":{"c":[1,2]}}}
vuoto array    []
misto          {"nome":"x"}
booleani       [true,false]
ciclico:       annidamento eccessivo o ciclo
funzione:      tipo non serializzabile: function
```

La riga `misto` merita attenzione: una tabella con sia indici numerici
sia chiavi stringa non è una sequenza, quindi viene codificata come
oggetto, e gli elementi numerici **spariscono** perché il ramo oggetto
salta le chiavi non stringa. È una perdita silenziosa di dati, e un
codificatore serio dovrebbe segnalarla con un errore invece di
tacerla. Il formato JSON non ha modo di rappresentare una struttura
mista, quindi qualcosa va comunque deciso: l’importante è che sia
esplicito.

Tre punti tecnici.

La **distinzione fra array e oggetto** è la decisione centrale di ogni
codificatore JSON per Lua, perché la tabella è la stessa struttura. La
funzione `eSequenza` verifica che tutte le chiavi siano interi da uno a
`n`: la stessa definizione del Capitolo 10. Una tabella vuota viene
codificata come array, il che è una convenzione fra le due possibili e va
dichiarata.

La **copia della chiave** prima di `lua_tolstring` è obbligatoria: senza,
una chiave numerica verrebbe convertita in stringa sul posto e
romperebbe `lua_next`, secondo l’avvertenza del paragrafo 25.4. Nel
codice le chiavi non stringa sono comunque saltate, ma la copia rende il
codice corretto anche se un giorno si decidesse di convertirle.

Il **limite di profondità** è la protezione contro i cicli: senza, una
tabella che contiene sé stessa produrrebbe ricorsione infinita e crollo
del processo. Un codificatore serio userebbe una tabella dei visitati,
come nell’ES 25.4.

**ES 25.8 — Il limite dello stack**

*Verifica sperimentalmente il limite dello stack: scrivi un programma
C che inserisca elementi senza chiamare `lua_checkstack` e osserva a
che punto il comportamento diventa scorretto. Poi correggi con
`lua_checkstack` e verifica la differenza.*

```c
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
```

produce:

```text
entro la garanzia di 20 posizioni:
        5  senza: 6          con: 6
       15  senza: 16         con: 16
       19  senza: 20         con: 20
oltre la garanzia, solo con controllo:
      100  con: 101
     1000  con: 1001
   100000  con: 100001
 10000000  con: impossibile riservare 10000000
           posizioni
```

Il risultato dell’esercizio è più severo di quanto ci si aspetterebbe, ed
è la ragione per cui la versione senza controllo viene provata **solo
entro le venti posizioni garantite**.

Provando `senzaControllo` con cento elementi, il programma non produce un
errore Lua: **termina bruscamente** con un messaggio dell’allocatore di
sistema, del tipo *realloc(): invalid next size*, seguito da `Aborted`.
Non è un’eccezione catturabile con `pcall`: è corruzione della memoria
del processo.

Questo è il comportamento che la documentazione dell’API descrive come
**indefinito**, e la sua manifestazione concreta. Non c’è alcun messaggio
utile, alcuna riga da cui partire, alcun modo di recuperare: il processo
muore. È il bug più difficile da diagnosticare di tutta l’API C, perché
il crollo può avvenire molto dopo l’inserimento che l’ha causato, in una
parte del codice del tutto estranea.

La versione con `lua_checkstack` fallisce invece **in modo pulito e
prevedibile**: con dieci milioni di posizioni restituisce un errore Lua
ordinario, catturabile dal chiamante, con un messaggio che dice esattamente
che cosa è successo.

La regola del paragrafo 25.2 non è quindi un consiglio di stile: se
inserite più di poche posizioni, e in particolare se il numero dipende da
un dato in ingresso, `lua_checkstack` è l’unica cosa che separa un errore
gestibile da un processo morto.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
