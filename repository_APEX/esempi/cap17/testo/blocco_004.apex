Id bersaglio = [SELECT Id FROM Account
    WHERE Name = 'Prova Uno' LIMIT 1].Id;
update new Account(Id = bersaglio, Phone = '0965 000111');
System.debug([SELECT Phone FROM Account
    WHERE Id = :bersaglio].Phone);
