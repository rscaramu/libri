public without sharing class AziendeTutte {

    public static Integer quante() {
        return [SELECT COUNT() FROM Account];
    }
}
