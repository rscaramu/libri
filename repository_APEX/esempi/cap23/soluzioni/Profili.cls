public with sharing class Profili {

    private static Id idAmministratore;

    public static Id amministratore() {
        if (idAmministratore == null) {
            idAmministratore = [SELECT Id FROM Profile
                WHERE Name = 'System Administrator'
                LIMIT 1].Id;
        }
        return idAmministratore;
    }
}
