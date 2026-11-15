List<Contact> prova = new List<Contact>{
    new Contact(LastName = 'Uno', Email = 'UNO@ES.IT') };
GestoreContatti.primaDelSalvataggio(prova);
System.debug(prova[0].Email);
System.debug(prova[0].Title);
