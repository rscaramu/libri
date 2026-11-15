public class LibroConfrontabile {

    public String titolo;
    public String autore;

    public LibroConfrontabile(String titolo,
            String autore) {
        this.titolo = titolo;
        this.autore = autore;
    }

    public override String toString() {
        return titolo + ' (' + autore + ')';
    }

    public Boolean equals(Object altro) {
        if (!(altro instanceof LibroConfrontabile)) {
            return false;
        }
        LibroConfrontabile l = (LibroConfrontabile) altro;
        return titolo == l.titolo && autore == l.autore;
    }

    public Integer hashCode() {
        return (titolo + '|' + autore).hashCode();
    }
}
