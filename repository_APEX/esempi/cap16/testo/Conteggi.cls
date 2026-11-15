public class Conteggi {

    public static Integer quanti(String oggetto) {
        Schema.SObjectType tipo =
            Schema.getGlobalDescribe().get(oggetto);
        if (tipo == null) {
            return -1;
        }
        String nome = tipo.getDescribe().getName();
        return Database.countQuery(
            'SELECT COUNT() FROM ' + nome);
    }
}
