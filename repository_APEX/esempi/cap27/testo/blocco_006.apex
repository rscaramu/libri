Id lavoro = Database.executeBatch(
    new BatchConteggio(), 3);
AsyncApexJob stato = [
    SELECT Status, TotalJobItems, JobItemsProcessed,
        NumberOfErrors
    FROM AsyncApexJob WHERE Id = :lavoro
];
System.debug(new Set<String>{ 'Holding', 'Queued' }
    .contains(stato.Status));
System.debug(stato.NumberOfErrors);
