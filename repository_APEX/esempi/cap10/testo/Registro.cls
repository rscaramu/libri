public class Registro {

    private static Registro istanza;
    private List<String> voci = new List<String>();

    private Registro() {
    }

    public static Registro corrente() {
        if (istanza == null) {
            istanza = new Registro();
        }
        return istanza;
    }

    public void annota(String voce) {
        voci.add(voce);
    }

    public Integer quante() {
        return voci.size();
    }
}
