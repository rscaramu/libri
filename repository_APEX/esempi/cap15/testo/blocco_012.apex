Opportunity o = [
    SELECT Name, toLabel(StageName), FORMAT(Amount) imp
    FROM Opportunity
    WHERE Name = 'Portale clienti'
    LIMIT 1
];
System.debug(o.StageName != null);
System.debug(o.get('imp') != null);
