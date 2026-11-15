public class Ripetizione {

    private static Integer chiamate = 0;

    private static String operazione() {
        chiamate++;
        if (chiamate < 3) {
            throw new ServizioException(
                'Tentativo ' + chiamate + ' fallito');
        }
        return 'Riuscito al tentativo ' + chiamate;
    }

    public static String conRipetizione() {
        ServizioException ultima;
        for (Integer i = 0; i < 3; i++) {
            try {
                return operazione();
            } catch (ServizioException e) {
                System.debug(e.getMessage());
                ultima = e;
            }
        }
        throw ultima;
    }
}
