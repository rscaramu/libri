List<AsyncApexJob> lavori = [
    SELECT ApexClass.Name, MethodName, Status,
        NumberOfErrors, ExtendedStatus
    FROM AsyncApexJob
    WHERE JobType = 'Future'
    ORDER BY CreatedDate DESC
    LIMIT 1
];
System.debug(lavori[0].ApexClass.Name);
System.debug(lavori[0].MethodName);
System.debug(lavori[0].Status);
