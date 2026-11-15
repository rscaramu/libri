List<Decimal> carrello = new List<Decimal>{ 40, 25, 35 };
Cassa ordinaria = new Cassa(new NessunoSconto());
Cassa saldi = new Cassa(new ScontoPercentuale(30));
System.debug(ordinaria.totale(carrello));
System.debug(saldi.totale(carrello));
