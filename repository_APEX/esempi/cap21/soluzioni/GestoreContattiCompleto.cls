public with sharing class GestoreContattiCompleto
        extends GestoreTrigger {

    protected override void dopoInserimento(
            List<sObject> nuovi) {
        List<Contact> titolari = new List<Contact>();
        for (Contact c : (List<Contact>) nuovi) {
            if (c.Title == 'Titolare') {
                titolari.add(c);
            }
        }
        if (!titolari.isEmpty()) {
            ServizioBenvenuto.crea(titolari);
        }
    }
}
