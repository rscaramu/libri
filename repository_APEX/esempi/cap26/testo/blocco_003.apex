Id lavoro = System.enqueueJob(new LavoroRiepilogo(
    new Set<Id>()));
AsyncApexJob stato = [
    SELECT Status, NumberOfErrors, ExtendedStatus,
        ApexClass.Name
    FROM AsyncApexJob WHERE Id = :lavoro
];
System.debug(stato.ApexClass.Name);
System.debug(stato.Status);
