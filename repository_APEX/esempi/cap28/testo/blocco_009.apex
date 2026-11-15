Id pianificazione = System.schedule(
    'Prova notturna', '0 30 2 * * ?',
    new AvvioNotturno());
CronTrigger c = [SELECT NextFireTime, State
    FROM CronTrigger WHERE Id = :pianificazione];
System.debug(c.NextFireTime.format('HH:mm'));
System.debug(c.State);
System.abortJob(pianificazione);
