public class Occorrenze {

    public static Integer conta(List<String> elenco,
            String cercata) {
        Integer quante = 0;
        if (elenco == null || cercata == null) {
            return quante;
        }
        for (String voce : elenco) {
            if (cercata.equals(voce)) {
                quante++;
            }
        }
        return quante;
    }
}
