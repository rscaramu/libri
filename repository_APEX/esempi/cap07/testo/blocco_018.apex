Ordine o = new Ordine();
o.aggiungi(new RigaOrdine('Viti', 200, 0.12));
o.aggiungi(new RigaOrdine('Dadi', 150, 0.05));
System.debug(o.totale());
