Lead l = new Lead(
    LastName = 'Gestito', Company = 'Prova');
insert l;
System.debug([SELECT Rating FROM Lead
    WHERE Id = :l.Id].Rating);
delete l;
