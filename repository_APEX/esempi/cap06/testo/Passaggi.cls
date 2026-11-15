public class Passaggi {

    public static void raddoppia(Integer numero) {
        numero = numero * 2;
    }

    public static void aggiungi(List<String> elenco) {
        elenco.add('nuovo');
    }

    public static void sostituisci(List<String> elenco) {
        elenco = new List<String>{ 'altro' };
    }
}
