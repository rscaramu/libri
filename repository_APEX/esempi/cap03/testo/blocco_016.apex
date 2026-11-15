Date emissione = Date.newInstance(2026, 1, 20);
Date scadenza = emissione.addDays(30);
Datetime dt = Datetime.newInstance(scadenza.year(),
    scadenza.month(), scadenza.day());
System.debug(dt.format('dd/MM/yyyy'));
Integer ultimo = Date.daysInMonth(2026, 2);
Date fineMese = Date.newInstance(2026, 2, ultimo);
System.debug(scadenza.daysBetween(fineMese));
