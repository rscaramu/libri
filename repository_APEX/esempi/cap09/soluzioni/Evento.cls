public class Evento implements Comparable {

    public String titolo;
    public Date giorno;

    public Evento(String titolo, Date giorno) {
        this.titolo = titolo;
        this.giorno = giorno;
    }

    public Integer compareTo(Object altro) {
        Evento e = (Evento) altro;
        if (giorno == e.giorno) {
            return 0;
        }
        return giorno < e.giorno ? -1 : 1;
    }
}
