public class Contatore {

    public Integer valore { get; private set; }

    public Contatore() {
        valore = 0;
    }

    public Contatore avanza() {
        valore++;
        return this;
    }

    public void azzera() {
        valore = 0;
    }
}
