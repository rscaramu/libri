Decimal prezzo = 80;
Decimal sconto = prezzo * 0.15;
Decimal finale = prezzo - sconto;
System.debug(LoggingLevel.INFO,
    'Prezzo scontato: ' + finale);
