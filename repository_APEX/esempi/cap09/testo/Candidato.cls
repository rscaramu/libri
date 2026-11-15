public class Candidato implements Comparable {

    public String nome { get; private set; }
    public Integer punteggio { get; private set; }

    public Candidato(String nome, Integer punteggio) {
        this.nome = nome;
        this.punteggio = punteggio;
    }

    public Integer compareTo(Object altro) {
        Candidato c = (Candidato) altro;
        if (punteggio == c.punteggio) {
            return nome.compareTo(c.nome);
        }
        return punteggio > c.punteggio ? -1 : 1;
    }
}
