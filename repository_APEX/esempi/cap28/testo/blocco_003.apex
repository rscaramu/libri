List<CronTrigger> attive = [
    SELECT Id, CronJobDetail.Name, CronExpression,
        State, NextFireTime, TimesTriggered
    FROM CronTrigger
    WHERE CronJobDetail.Name = 'Promemoria scadenze'
];
System.debug(attive.size());
System.debug(attive[0].CronExpression);
System.debug(attive[0].State);
System.debug(attive[0].TimesTriggered);
