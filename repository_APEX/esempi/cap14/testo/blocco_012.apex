List<Account> trovate = [SELECT Name FROM Account
    WHERE Name = 'Inesistente' LIMIT 1];
Account risultato = trovate.isEmpty() ? null : trovate[0];
System.debug(risultato);
