List<Contact> primoGruppo = new List<Contact>{
    new Contact(LastName = 'A'),
    new Contact(LastName = 'B') };
List<Contact> secondoGruppo = new List<Contact>{
    new Contact(LastName = 'C') };
RegolaFragile.applica(primoGruppo);
RegolaFragile.applica(secondoGruppo);
System.debug(RegolaFragile.elaborati);
