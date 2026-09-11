# Manuale completo di DELPHI

*Dai fondamenti di Object Pascal alle applicazioni desktop, mobile e database*
Roberto Scaramuzzino — collana di manuali di programmazione, Amazon KDP.

Questo repository contiene il sorgente del manuale, gli esempi di codice, le figure e la toolchain con cui vengono generati i file per la stampa e per Kindle.

## Contenuto

| Cartella / file | Cosa contiene |
|---|---|
| `manuale_delphi.md` | Sorgente unico del libro in Markdown (34 capitoli, appendici A–F, 170 soluzioni) |
| `PIANO_DELPHI.md` | Piano editoriale, specifiche tecniche e stato del progetto |
| `esempi/` | I programmi e le unit del libro estratti dal sorgente, per capitolo (`capNN/`), più `appendici/` e `soluzioni/` |
| `figure/` | Le 30 figure (PNG) e `prompt_figure.txt` con i prompt usati per generarle |
| `tools/` | Script di verifica e di produzione (vedi sotto) |
| `dist/` | File pronti per KDP: `Manuale_Delphi_KDP.docx` (stampa 7×10"), `Manuale_Delphi_ebook.docx` (Kindle), `Marketing_KDP_Delphi.docx`, `Piano_figure_Delphi.docx` |

## Esempi

I file `.dpr` (programmi) e `.pas` (unit) in `esempi/` compilano con Delphi 12/13 e, salvo dove il testo indica diversamente, con Free Pascal 3.2.2 in modalità Delphi:

```bash
fpc -Mdelphi -Sh esempi/cap06/Fattoriali.dpr && ./esempi/cap06/Fattoriali
```

Gli esempi che usano VCL, FireMonkey, FireDAC, REST o DUnitX richiedono l’IDE Delphi (la Community Edition è gratuita). Le unit vanno compilate insieme al programma che le usa, nella stessa cartella.

## Toolchain

Tutti gli script si lanciano dalla cartella che contiene `manuale_delphi.md`.

| Script | Uso |
|---|---|
| `tools/verifica.py manuale_delphi.md` | Compila ed esegue ogni blocco `pascal` con Free Pascal, confronta l’output con il fence `output` successivo, segnala righe oltre 62 caratteri |
| `tools/analisi.py manuale_delphi.md` | Controllo strutturale: numerazione, 3 svolti + 5 proposti + 3 prompt per capitolo, corrispondenza con l’Appendice F, figure |
| `tools/bozze.py manuale_delphi.md` | Correzione di bozze tipografica (apostrofi, ellissi, virgolette) fuori dai blocchi di codice |
| `NODE_PATH=$(npm root -g) node tools/build.js` | Genera i due `.docx` (richiede `docx` ≥ 9 installato globalmente, figure in `figure/`) |
| `tools/postprocess.py <docx> [--mirror]` | Margini speculari e ordine dei bordi per la stampa; sommario Kindle per l’ebook |
| `tools/validate.py <docx> [--ebook]` | Verifica dei requisiti KDP/Kindle sul file prodotto |
| `node tools/marketing.js` | Genera marketing, piano figure e file dei prompt |

Sequenza completa:

```bash
python3 tools/verifica.py manuale_delphi.md
python3 tools/analisi.py manuale_delphi.md
NODE_PATH=$(npm root -g) node tools/build.js
python3 tools/postprocess.py Manuale_Delphi_KDP.docx --mirror
python3 tools/postprocess.py Manuale_Delphi_ebook.docx
python3 tools/validate.py Manuale_Delphi_KDP.docx
python3 tools/validate.py Manuale_Delphi_ebook.docx --ebook
```

`tools/fpc-trunk` è un wrapper per un compilatore Free Pascal 3.3.1 compilato dai sorgenti (metodi anonimi e attributi): il percorso al suo interno va adattato.

## Licenza

Il testo del manuale e le figure sono © Roberto Scaramuzzino, tutti i diritti riservati. Il codice degli esempi può essere usato liberamente nei propri progetti.

Delphi, RAD Studio, FireMonkey e FireDAC sono marchi di Embarcadero Technologies.
