public class Parametri {

    public static Integer leggiIntero(
            String nome, String valore) {
        try {
            return Integer.valueOf(valore);
        } catch (TypeException e) {
            throw new ConfigurazioneException(
                'Parametro ' + nome + ' non valido', e);
        }
    }
}
