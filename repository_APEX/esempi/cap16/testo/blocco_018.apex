List<Contact> letti = LetturaContatti.leggi(
    new List<String>{ 'LastName', 'Title', 'Inventato' });
System.debug(letti.size());
System.debug(letti[0].LastName + ' - ' + letti[0].Title);
