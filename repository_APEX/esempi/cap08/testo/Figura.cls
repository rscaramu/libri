public abstract class Figura {

    protected String nome;

    public Figura(String nome) {
        this.nome = nome;
    }

    public abstract Decimal area();

    public String descrizione() {
        return nome + ' di area ' + area().setScale(2);
    }
}
