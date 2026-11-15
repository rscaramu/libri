public class LunghezzaMassima implements Validatore {

    private Integer massimo;

    public LunghezzaMassima(Integer massimo) {
        this.massimo = massimo;
    }

    public Boolean valido(String testo) {
        return testo == null || testo.length() <= massimo;
    }
}
