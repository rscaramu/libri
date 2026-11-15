public virtual class Dipendente {

    protected String nome;
    protected Decimal stipendioBase;

    public Dipendente(String nome, Decimal stipendioBase) {
        this.nome = nome;
        this.stipendioBase = stipendioBase;
    }

    public virtual Decimal compenso() {
        return stipendioBase;
    }

    public String cedolino() {
        return nome + ': ' + compenso();
    }
}
