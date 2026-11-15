public class SommaPrudente {

    public static Long somma(List<Integer> valori) {
        Long totale = 0;
        Integer tetto = Limits.getLimitCpuTime() / 2;
        for (Integer v : valori) {
            if (Limits.getCpuTime() > tetto) {
                break;
            }
            totale += v;
        }
        return totale;
    }
}
