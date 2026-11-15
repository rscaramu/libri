public class Identificativi {

    public static String descrivi(Id identificativo) {
        if (identificativo == null) {
            return 'Nessuno';
        }
        Schema.SObjectType tipo =
            identificativo.getSObjectType();
        if (tipo == Account.sObjectType) {
            return 'Azienda';
        }
        if (tipo == Contact.sObjectType) {
            return 'Persona';
        }
        if (tipo == Opportunity.sObjectType) {
            return 'Trattativa';
        }
        return tipo.getDescribe().getName();
    }
}
