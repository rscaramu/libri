public class Province {

    private static final Map<String, String> NOMI;

    static {
        NOMI = new Map<String, String>();
        NOMI.put('RC', 'Reggio Calabria');
        NOMI.put('CZ', 'Catanzaro');
        NOMI.put('CS', 'Cosenza');
    }

    public static String nome(String sigla) {
        return NOMI.get(sigla?.toUpperCase())
            ?? 'Sconosciuta';
    }
}
