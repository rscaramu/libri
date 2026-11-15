public class RegolaFragile {

    private static Boolean giaEseguito = false;
    public static Integer elaborati = 0;

    public static void applica(List<sObject> record) {
        if (giaEseguito) {
            return;
        }
        giaEseguito = true;
        elaborati += record.size();
    }
}
