# Manuale completo di LTspice – materiali per il lettore

Roberto Scaramuzzino

- `netlist/capNN/`: le netlist complete dei capitoli, con il nome usato nel libro
  (per esempio `c32_regime.cir`); `netlist/soluzioni/` contiene quelle
  delle soluzioni degli esercizi proposti (appendice F).
- `netlist/cap34/catena.sub`: il sottocircuito del progetto del capitolo 34,
  incluso dalle netlist di quel capitolo.
- `python/`: i programmi Python del libro.
- `prompt_IA.md`: i prompt delle sezioni «Con l’IA», capitolo per capitolo.

Le netlist sono state verificate con LTspice 26.1.1. Alcune usano file
prodotti da altre netlist dello stesso capitolo (per esempio il file di stato
`buck.state` del capitolo 32), o file di dati citati nel testo: eseguitele
nell’ordine in cui compaiono nel libro.
