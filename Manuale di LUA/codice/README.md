# I sorgenti

Centonovanta file, uno per esercizio, divisi in una cartella per capitolo. Ogni file è autonomo: si esegue senza dipendenze e senza altri file dell'archivio.

[← Torna all'archivio](../README.md) · [Indice delle soluzioni](../soluzioni/README.md)

---

## Nomi dei file

```text
codice/cap07/es7.4.lua      esercizio 7.4
codice/cap25/es25.5.c       esercizio 25.5, sorgente C
codice/cap28/es28.7-1.lua   primo di due programmi
codice/cap28/es28.7-2.lua   secondo
```

Il numero è quello del libro: `es7.4` è il quarto esercizio del Capitolo 7. Dove una soluzione contiene più programmi indipendenti, il suffisso li distingue nell'ordine in cui compaiono nel testo.

Manca la cartella del Capitolo 1, e manca qualche esercizio qua e là: sono quelli che chiedevano un'analisi o una discussione invece di un programma. La soluzione c'è comunque, in [`soluzioni/`](../soluzioni/README.md).

---

## Eseguire i file Lua

Serve un interprete Lua 5.4. Se non l'avete, il Capitolo 2 del libro spiega come installarlo su Windows, macOS e Linux; in breve:

```text
# Debian, Ubuntu
sudo apt install lua5.4

# macOS con Homebrew
brew install lua

# dai sorgenti, ovunque ci sia un compilatore C
curl -R -O https://www.lua.org/ftp/lua-5.4.8.tar.gz
tar zxf lua-5.4.8.tar.gz
cd lua-5.4.8 && make all test
```

Poi:

```text
lua codice/cap07/es7.4.lua
```

Molti programmi accettano input da tastiera o stampano semplicemente il proprio risultato. Alcuni misurano tempi di esecuzione: quei numeri **dipendono dalla vostra macchina** e non coincideranno con quelli stampati nel libro. È previsto, e le soluzioni lo dichiarano dove conta.

### Verificare la sintassi senza eseguire

```text
luac -p codice/cap07/es7.4.lua
```

È il modo più rapido di controllare che un file sia integro dopo averlo modificato.

---

## Compilare i sorgenti C

I Capitoli 25 e 26 riguardano l'API C. I sorgenti si dividono in due categorie.

**Programmi autonomi** che incorporano l'interprete: si collegano alla libreria di Lua.

```text
gcc -o prova codice/cap26/es26.3.c \
    -I/percorso/lua-5.4.8/src \
    /percorso/lua-5.4.8/src/liblua.a -lm -ldl
./prova
```

**Moduli condivisi** che estendono l'interprete: si compilano come libreria dinamica e si caricano con `require`.

```text
gcc -shared -fPIC -o mio.so codice/cap25/es25.5.c \
    -I/percorso/lua-5.4.8/src
lua -e 'local m = require("mio"); print(m.versione())'
```

Su macOS sostituite `-shared` con `-bundle -undefined dynamic_lookup`. Su Windows con MinGW usate `-shared` e collegate alla DLL di Lua.

Il nome del modulo deve corrispondere alla funzione di apertura: un file che definisce `luaopen_mio` produce un modulo che si richiede come `mio`, e il file condiviso deve chiamarsi `mio.so`. È l'errore più frequente al primo modulo C, ed è trattato nel Capitolo 26.

---

## I sorgenti che richiedono un ambiente ospite

Tre capitoli riguardano ambienti che incorporano Lua. I loro sorgenti **non si eseguono con l'interprete da solo**, e ciascun file lo dichiara nelle prime righe.

| Cartella | Ambiente | Come si esegue |
|---|---|---|
| `cap31/` | LÖVE 2D | il file va in una cartella con `main.lua`, poi `love .` |
| `cap32/` | Neovim | il file va in `~/.config/nvim/lua/`, poi `require` da `init.lua` |
| `cap33/` | OpenResty | il file va referenziato da `nginx.conf` nella fase opportuna |

Tutti e tre usano **LuaJIT**, cioè Lua 5.1: niente interi, niente `//`, niente operatori bit a bit nativi, niente `<const>` e `<close>`. Il Capitolo 27 spiega che cosa cambia.

Dove è stato possibile, la logica di queste soluzioni è stata scritta contro un'astrazione dell'ambiente, così da poterla provare con l'interprete ordinario iniettando una finta implementazione. Il metodo è spiegato nella soluzione dell'ES 33.1.

---

## Licenza

Il codice di questa cartella è rilasciato con licenza MIT. Usatelo, modificatelo, incorporatelo nei vostri progetti, anche commerciali. Vedi [LICENSE](../LICENSE).

---

[← Torna all'archivio](../README.md) · [Indice delle soluzioni](../soluzioni/README.md)
