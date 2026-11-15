public class PerPunteggio
        implements Comparator<Candidato> {

    public Integer compare(Candidato a, Candidato b) {
        return a.punteggio - b.punteggio;
    }
}
