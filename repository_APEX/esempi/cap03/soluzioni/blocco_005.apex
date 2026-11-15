Datetime inizio =
    Datetime.newInstance(2026, 12, 30, 22, 15, 0);
Datetime fine = inizio.addHours(7).addMinutes(50);
System.debug(fine.format('dd/MM/yyyy HH:mm'));
