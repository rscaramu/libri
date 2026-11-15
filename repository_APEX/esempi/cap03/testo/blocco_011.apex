Datetime avvio =
    Datetime.newInstance(2026, 11, 15, 9, 30, 0);
Datetime fine = avvio.addHours(2).addMinutes(45);
System.debug(fine.format('dd/MM/yyyy HH:mm'));
System.debug(fine.hour());
System.debug(fine.date());
Long durata = fine.getTime() - avvio.getTime();
System.debug(durata / 60000);
