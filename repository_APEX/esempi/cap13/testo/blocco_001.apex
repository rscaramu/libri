Account azienda = new Account(
    Name = 'Officine Riva',
    Industry = 'Manufacturing',
    AnnualRevenue = 2500000);
azienda.Phone = '0965 123456';
azienda.NumberOfEmployees = 48;
System.debug(azienda.Name);
System.debug(azienda.AnnualRevenue);
System.debug(azienda.Id);
System.debug(new Account(Name = 'Alfa', Phone = '02 555'));
