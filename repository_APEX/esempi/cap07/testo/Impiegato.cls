public class Impiegato {

    public String nome { get; set; }
    public String matricola { get; private set; }
    public Decimal stipendio {
        get;
        set {
            if (value >= 0) {
                stipendio = value;
            }
        }
    }
    public Decimal annuo {
        get { return stipendio * 13; }
    }

    public Impiegato(String matricola, String nome) {
        this.matricola = matricola;
        this.nome = nome;
        this.stipendio = 0;
    }
}
