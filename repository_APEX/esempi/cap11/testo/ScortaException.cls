public class ScortaException extends Exception {

    public String codice { get; private set; }
    public Integer mancanti { get; private set; }

    public ScortaException(String codice,
            Integer mancanti) {
        setMessage('Scorta insufficiente per ' + codice);
        this.codice = codice;
        this.mancanti = mancanti;
    }
}
