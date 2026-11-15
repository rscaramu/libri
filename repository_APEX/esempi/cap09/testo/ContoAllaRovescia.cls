public class ContoAllaRovescia implements Iterator<Integer> {

    private Integer corrente;

    public ContoAllaRovescia(Integer partenza) {
        corrente = partenza;
    }

    public Boolean hasNext() {
        return corrente > 0;
    }

    public Integer next() {
        return corrente--;
    }
}
