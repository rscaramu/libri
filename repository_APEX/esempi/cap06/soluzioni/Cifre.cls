public class Cifre {

    public static Integer sommaCifre(Integer n) {
        if (n < 10) {
            return n;
        }
        return Math.mod(n, 10) + sommaCifre(n / 10);
    }
}
