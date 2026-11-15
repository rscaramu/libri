public class Verifiche {

    public static Boolean campoValido(
            String oggetto, String campo) {
        Schema.SObjectType tipo =
            Schema.getGlobalDescribe().get(oggetto);
        if (tipo == null) {
            return false;
        }
        return tipo.getDescribe().fields.getMap()
            .containsKey(campo);
    }
}
