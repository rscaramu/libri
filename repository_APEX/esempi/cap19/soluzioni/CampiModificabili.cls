public with sharing class CampiModificabili {

    public static List<String> contatto(
            List<String> nomi) {
        Map<String, Schema.SObjectField> campi =
            Contact.sObjectType.getDescribe()
                .fields.getMap();
        List<String> ammessi = new List<String>();
        for (String nome : nomi) {
            if (campi.containsKey(nome) && campi.get(nome)
                    .getDescribe().isUpdateable()) {
                ammessi.add(nome);
            }
        }
        return ammessi;
    }
}
