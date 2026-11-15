public with sharing class LeadAsincroni {

    @future
    public static void crea(String nomiJson) {
        List<String> nomi = (List<String>)
            JSON.deserialize(nomiJson, List<String>.class);
        List<Lead> nuovi = new List<Lead>();
        for (String nome : nomi) {
            nuovi.add(new Lead(LastName = nome,
                Company = 'Da qualificare'));
        }
        insert nuovi;
    }
}
