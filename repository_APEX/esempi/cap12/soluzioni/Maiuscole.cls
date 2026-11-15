public class Maiuscole {

    public static List<String> parole(String testo) {
        List<String> trovate = new List<String>();
        if (testo == null) {
            return trovate;
        }
        Matcher m = Pattern.compile('\\b[A-Z]\\w*')
            .matcher(testo);
        while (m.find()) {
            trovate.add(m.group());
        }
        return trovate;
    }
}
