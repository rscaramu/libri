Date emissione = Date.newInstance(2026, 11, 15);
Date scadenza = emissione.addDays(30);
System.debug(scadenza);
System.debug(scadenza.year());
System.debug(scadenza.month());
System.debug(scadenza.day());
System.debug(emissione.daysBetween(scadenza));
System.debug(emissione.addMonths(3));
System.debug(emissione.toStartOfMonth());
