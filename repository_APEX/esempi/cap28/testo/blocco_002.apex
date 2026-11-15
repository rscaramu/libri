Id pianificazione = System.schedule(
    'Promemoria scadenze',
    '0 0 7 ? * MON-FRI',
    new PromemoriaScadenze());
System.debug(pianificazione != null);
