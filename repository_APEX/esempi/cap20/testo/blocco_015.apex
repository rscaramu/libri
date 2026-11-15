try {
    insert new Contact(LastName = 'Irreperibile',
        Description = 'Controllo recapiti');
} catch (DmlException e) {
    System.debug(e.getDmlMessage(0));
}
