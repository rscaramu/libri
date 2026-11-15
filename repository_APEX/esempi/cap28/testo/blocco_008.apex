Pianificazioni.attiva();
System.debug([SELECT COUNT() FROM CronTrigger
    WHERE CronJobDetail.Name LIKE 'APP %']);
Pianificazioni.disattiva();
System.debug([SELECT COUNT() FROM CronTrigger
    WHERE CronJobDetail.Name LIKE 'APP %']);
