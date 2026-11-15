Contact c = new Contact(
    LastName = 'Conti', Email = 'a.conti@esempio.it');
System.debug(Completezza.campiVuoti(c,
    new List<String>{ 'LastName', 'Email', 'Phone',
        'Title' }));
