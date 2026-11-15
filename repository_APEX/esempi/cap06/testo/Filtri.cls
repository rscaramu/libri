public class Filtri {

    public static List<Integer> soloPari(
            List<Integer> numeri) {
        List<Integer> pari = new List<Integer>();
        if (numeri == null) {
            return pari;
        }
        for (Integer n : numeri) {
            if (Math.mod(n, 2) == 0) {
                pari.add(n);
            }
        }
        return pari;
    }
}
