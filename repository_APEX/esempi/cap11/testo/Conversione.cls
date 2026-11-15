public class Conversione {

    public static List<Integer> inInteri(
            List<String> testi) {
        List<Integer> numeri = new List<Integer>();
        Integer scartati = 0;
        for (String t : testi) {
            try {
                numeri.add(Integer.valueOf(t.trim()));
            } catch (TypeException e) {
                scartati++;
            }
        }
        System.debug('Scartati: ' + scartati);
        return numeri;
    }
}
