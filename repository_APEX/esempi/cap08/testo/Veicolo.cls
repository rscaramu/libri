public virtual class Veicolo {

    protected String targa;
    protected Integer posti;

    public Veicolo(String targa, Integer posti) {
        this.targa = targa;
        this.posti = posti;
    }

    public String scheda() {
        return targa + ' (' + posti + ' posti)';
    }
}
