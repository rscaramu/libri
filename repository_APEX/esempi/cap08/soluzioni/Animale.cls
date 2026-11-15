public virtual class Animale {

    protected String nome;

    public Animale(String nome) {
        this.nome = nome;
    }

    public virtual String verso() {
        return '...';
    }

    public String presentazione() {
        return nome + ': ' + verso();
    }
}
