Lead l = new Lead(
    LastName = 'Prova', Company = 'Edil Sud');
insert l;
l = [SELECT Rating, Company FROM Lead WHERE Id = :l.Id];
System.debug(l.Rating + ' - ' + l.Company);
delete l;
