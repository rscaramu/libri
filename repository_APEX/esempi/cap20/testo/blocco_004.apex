List<Contact> prova = new List<Contact>{
    new Contact(LastName = 'Diario Uno'),
    new Contact(LastName = 'Diario Due') };
insert prova;
prova[0].Title = 'Tecnico';
update prova[0];
delete prova;
