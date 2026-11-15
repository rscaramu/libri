public class PerLunghezza implements Comparator<String> {

    public Integer compare(String a, String b) {
        if (a.length() != b.length()) {
            return a.length() - b.length();
        }
        return a.compareTo(b);
    }
}
