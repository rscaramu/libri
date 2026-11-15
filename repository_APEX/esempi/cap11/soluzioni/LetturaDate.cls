public class LetturaDate {

    public static Date leggi(String testo) {
        try {
            return Date.valueOf(testo);
        } catch (Exception e) {
            return null;
        }
    }
}
