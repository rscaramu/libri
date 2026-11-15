public class Libro {

    public String titolo { get; private set; }
    public String autore { get; private set; }
    public Integer pagine { get; private set; }

    public Libro(String titolo, String autore,
            Integer pagine) {
        this.titolo = titolo;
        this.autore = autore;
        this.pagine = pagine;
    }

    public String descrizione() {
        return titolo + ', di ' + autore
            + ' (' + pagine + ' pagine)';
    }
}
