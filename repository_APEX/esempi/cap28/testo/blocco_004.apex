for (CronTrigger c : [SELECT Id FROM CronTrigger
        WHERE CronJobDetail.Name
            = 'Promemoria scadenze']) {
    System.abortJob(c.Id);
}
System.debug([SELECT COUNT() FROM CronTrigger
    WHERE CronJobDetail.Name = 'Promemoria scadenze']);
