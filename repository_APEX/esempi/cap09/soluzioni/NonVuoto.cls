public class NonVuoto implements Validatore {

    public Boolean valido(String testo) {
        return String.isNotBlank(testo);
    }
}
