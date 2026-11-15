public class Intervallo implements Iterator<Integer> {

    private Integer corrente;
    private Integer massimo;
    private Integer passo;

    public Intervallo(Integer minimo, Integer massimo,
            Integer passo) {
        this.corrente = minimo;
        this.massimo = massimo;
        this.passo = passo;
    }

    public Boolean hasNext() {
        return corrente <= massimo;
    }

    public Integer next() {
        Integer valore = corrente;
        corrente += passo;
        return valore;
    }
}
