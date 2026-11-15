public class GestoreTriggerEsteso {

    private static Set<String> sospesi = new Set<String>();

    public static Boolean sospesa(String nome) {
        return sospesi.contains(nome);
    }
}
