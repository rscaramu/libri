public with sharing class Esenzioni {

    public static Boolean saltaControlli() {
        Automazione__c a = Automazione__c.getInstance();
        return a != null && a.Salta_Controlli__c == true;
    }
}
