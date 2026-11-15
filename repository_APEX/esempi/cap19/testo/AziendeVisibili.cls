public with sharing class AziendeVisibili {

    public static Integer quante() {
        return [SELECT COUNT() FROM Account];
    }
}
