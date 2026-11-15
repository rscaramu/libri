public class LetturaContatti {

    public static List<Contact> leggi(
            List<String> campi) {
        Map<String, Schema.SObjectField> esistenti =
            Contact.sObjectType.getDescribe()
                .fields.getMap();
        Set<String> validi = new Set<String>{ 'Id' };
        for (String campo : campi) {
            if (esistenti.containsKey(campo)) {
                validi.add(esistenti.get(campo)
                    .getDescribe().getName());
            }
        }
        String testo = 'SELECT '
            + String.join(new List<String>(validi), ', ')
            + ' FROM Contact'
            + ' WHERE MailingCountry = \'Italia\''
            + ' ORDER BY LastName';
        return Database.query(testo);
    }
}
