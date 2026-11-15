for (AggregateResult r : [
        SELECT Status stato, COUNT(Id) n
        FROM AsyncApexJob
        WHERE JobType = 'Future'
        AND CreatedDate = TODAY
        GROUP BY Status]) {
    System.debug(r.get('stato') + ': ' + r.get('n'));
}
