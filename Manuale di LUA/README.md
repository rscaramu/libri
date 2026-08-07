# Manuale completo di Lua — soluzioni e codice

Archivio di supporto al libro **Manuale completo di Lua — Dai fondamenti al linguaggio che vive dentro ogni cosa**, di Roberto Scaramuzzino.

Qui trovate le soluzioni dei **178 esercizi proposti** al termine dei trentaquattro capitoli, i sorgenti pronti da eseguire e l'errata corrige.

L'accesso è libero e non richiede alcuna registrazione. Non serve possedere il libro per leggere le soluzioni, ma senza il percorso che le giustifica servono a poco.

---

## Prima di aprire una soluzione

**Provate.**

Un esercizio letto è un esercizio non fatto. Nell'ora passata a capire perché un ciclo salta un elemento si impara più che in dieci soluzioni lette, e questo archivio è la cosa più facile del mondo da consultare troppo presto.

Il modo utile di usarlo è questo: provate, arrivate a una versione che funziona, e **solo allora** confrontatela con quella qui. Se la vostra è diversa non è detto che sia sbagliata — dove l'esercizio ammette più risposte corrette, la soluzione lo dice e discute le alternative.

---

## Che cosa c'è dentro

```text
soluzioni/     un file per capitolo, con consegna,
               soluzione commentata e output reale
codice/        i sorgenti pronti da eseguire,
               uno per esercizio, divisi per capitolo
ERRATA.md      le correzioni al testo stampato
```

### `soluzioni/`

Trentaquattro file, uno per capitolo. Ogni soluzione riporta:

- **il testo dell'esercizio**, in corsivo, così che il file si legga da solo;
- **la soluzione**, con il codice commentato dove l'esercizio chiedeva un programma e il ragionamento disteso dove chiedeva un'analisi;
- **l'output reale**, prodotto dall'esecuzione.

[**→ Indice delle soluzioni**](soluzioni/README.md)

### `codice/`

Centonovanta sorgenti, divisi in una cartella per capitolo. I file Lua si eseguono direttamente:

```text
lua codice/cap07/es7.4.lua
```

I sorgenti C dei Capitoli 25 e 26 vanno compilati contro l'interprete. Le istruzioni sono nel [README del codice](codice/README.md).

I sorgenti dei Capitoli 31, 32 e 33 richiedono LÖVE 2D, Neovim e OpenResty rispettivamente: ciascun file lo dichiara in testa.

---

## Gli output sono reali

Ogni programma di questo archivio è stato eseguito durante la preparazione del manuale, su **Lua 5.4.8 compilato dai sorgenti**. Gli output riportati sono quelli prodotti dal calcolatore, non quelli attesi dall'autore.

In diversi casi differivano. Alcuni esempi, tutti documentati nella soluzione corrispondente:

| Dove | Che cosa si scopriva eseguendo |
|---|---|
| ES 7.4 | Il fattoriale trabocca a 21, non a 19 |
| ES 9.7 | La ricorsione ordinaria regge 499 991 livelli |
| ES 22.8 | Il raccoglitore **non** chiude le coroutine abbandonate |
| ES 25.8 | Senza `lua_checkstack` il processo crolla, non solleva un errore |
| ES 27.4 | `2^53 == 2^53+1` è vero anche su Lua 5.4 |
| ES 29.6 | Su otto casi di prova, solo tre intercettano il bug |
| ES 30.5 | L'ordine di `pairs` **cambia a ogni esecuzione** |

E una che vale la pena isolare: nell'**ES 30.8** il codice della soluzione era caduto nella stessa trappola che il manuale spiega per trentaquattro capitoli, l'idioma `cond and a or b` con il ramo vero uguale a `nil`. L'errore è raccontato dove è avvenuto, perché è la lezione più utile dell'intero libro: il ragionamento a tavolino produce codice plausibile, e il plausibile non è il corretto.

---

## Segnalare un errore

Se trovate un errore nel libro o in una soluzione, apritene una segnalazione. È il modo più utile di contribuire, e le correzioni finiscono in [ERRATA.md](ERRATA.md).

Nella segnalazione servono tre cose:

1. **dove**: numero di esercizio o pagina del libro;
2. **che cosa succede**: il messaggio o il comportamento osservato, incollato per esteso;
3. **con che cosa**: l'output di `lua -v`, e il sistema operativo.

Sono utili anche le segnalazioni su una soluzione che **funziona ma è migliorabile**: se avete una versione più chiara o più veloce, mostratela.

---

## Le versioni

La base è **Lua 5.4**, verificata su 5.4.8. Dove una soluzione si comporta diversamente su altre versioni, la differenza è dichiarata nel testo.

- **Lua 5.5** (dicembre 2025): le differenze rilevanti sono segnalate.
- **Lua 5.1 e LuaJIT**: le soluzioni che usano gli interi, `//`, gli operatori bit a bit, `<const>` o `<close>` non funzionano. Il Capitolo 27 del libro spiega perché, e l'ES 34.8 costruisce uno strato di compatibilità.

---

## Licenza

Il **codice** di questo archivio è rilasciato con licenza MIT: usatelo, modificatelo, incorporatelo nei vostri progetti, anche commerciali.

Il **testo delle soluzioni** è materiale del libro ed è riservato: potete leggerlo, citarlo e discuterne, non ripubblicarlo.

Vedi [LICENSE](LICENSE).

---

## Il libro

**Manuale completo di Lua — Dai fondamenti al linguaggio che vive dentro ogni cosa**
Roberto Scaramuzzino

Trentaquattro capitoli in cinque parti, dal primo `print` alla scrittura di moduli C che estendono l'interprete. Sette appendici di consultazione, fra cui un prontuario degli errori organizzato per sintomo e una guida per chi arriva da un altro linguaggio. Quattro progetti reali: un gioco con LÖVE 2D, la configurazione di Neovim, un gateway per API con OpenResty, un'applicazione completa da riga di comando.

Duecentosettantadue esercizi svolti dentro i capitoli, centosettantotto proposti — le cui soluzioni sono qui.

Disponibile in edizione cartacea e Kindle.
