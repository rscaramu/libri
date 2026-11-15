public class Completezza {

    public static List<String> campiVuoti(
            sObject record, List<String> campi) {
        List<String> vuoti = new List<String>();
        for (String campo : campi) {
            Object valore = record.get(campo);
            String testo = String.valueOf(valore);
            if (String.isBlank(testo)) {
                vuoti.add(campo);
            }
        }
        return vuoti;
    }
}
