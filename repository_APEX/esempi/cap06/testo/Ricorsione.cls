public class Ricorsione {

    public static Long fattoriale(Integer n) {
        if (n <= 1) {
            return 1;
        }
        return n * fattoriale(n - 1);
    }
}
