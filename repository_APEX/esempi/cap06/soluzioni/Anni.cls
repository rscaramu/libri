public class Anni {

    public static Boolean eBisestile(Integer anno) {
        return (Math.mod(anno, 4) == 0
                && Math.mod(anno, 100) != 0)
            || Math.mod(anno, 400) == 0;
    }
}
