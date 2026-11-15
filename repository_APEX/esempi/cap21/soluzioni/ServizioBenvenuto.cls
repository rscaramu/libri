public with sharing class ServizioBenvenuto {

    public static void crea(List<Contact> titolari) {
        List<Task> attivita = new List<Task>();
        for (Contact c : titolari) {
            attivita.add(new Task(Subject = 'Benvenuto',
                WhoId = c.Id, OwnerId = c.OwnerId));
        }
        insert attivita;
    }
}
