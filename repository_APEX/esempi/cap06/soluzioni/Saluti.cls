public class Saluti {

    public static String saluta(String nome) {
        return saluta(nome, '');
    }

    public static String saluta(String nome,
            String titolo) {
        String intestazione = String.isBlank(titolo)
            ? nome : titolo + ' ' + nome;
        return 'Buongiorno, ' + intestazione;
    }
}
