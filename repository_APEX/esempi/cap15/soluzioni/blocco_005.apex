for (AggregateResult r : [
        SELECT Title ruolo, COUNT(Id) n
        FROM Contact
        WHERE MailingCountry = 'Italia'
        GROUP BY Title
        HAVING COUNT(Id) > 1
        ORDER BY Title]) {
    System.debug(r.get('ruolo') + ': ' + r.get('n'));
}
