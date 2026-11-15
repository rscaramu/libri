Map<String, Decimal> r = Statistiche.riepilogo(
    new List<Decimal>{ 12, 7, 23, 10 });
System.debug(r.get('somma'));
System.debug(r.get('massimo'));
System.debug(r.get('media'));
