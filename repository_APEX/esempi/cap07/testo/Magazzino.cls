public class Magazzino {

    private String articolo;
    private Integer scorta = 0;

    public Magazzino(String articolo) {
        this.articolo = articolo;
    }

    public void carica(Integer pezzi) {
        if (pezzi > 0) {
            scorta += pezzi;
        }
    }

    public Boolean preleva(Integer pezzi) {
        if (pezzi <= 0 || pezzi > scorta) {
            return false;
        }
        scorta -= pezzi;
        return true;
    }

    public Integer disponibili() {
        return scorta;
    }
}
