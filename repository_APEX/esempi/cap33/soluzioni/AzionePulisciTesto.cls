public with sharing class AzionePulisciTesto {

    @InvocableMethod(label='Pulisci testo'
        description='Toglie gli spazi e mette la maiuscola.'
        category='Testi')
    public static List<String> pulisci(
            List<String> testi) {
        List<String> esiti = new List<String>();
        for (String testo : testi) {
            esiti.add(testo == null ? null
                : testo.normalizeSpace().capitalize());
        }
        return esiti;
    }
}
