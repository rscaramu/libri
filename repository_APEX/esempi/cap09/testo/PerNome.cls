public class PerNome implements Comparator<Candidato> {

    public Integer compare(Candidato a, Candidato b) {
        return a.nome.compareTo(b.nome);
    }
}
