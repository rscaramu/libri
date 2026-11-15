public class Geometrie {

    public static Figura massima(List<Figura> figure) {
        Figura migliore;
        for (Figura f : figure) {
            if (migliore == null
                    || f.area() > migliore.area()) {
                migliore = f;
            }
        }
        return migliore;
    }
}
