public class Anagrafe {

    public static String registra(
            String nome, Integer eta) {
        if (eta == null || eta < 0 || eta > 120) {
            throw new EtaNonValidaException(
                'Eta\' non ammessa per ' + nome + ': '
                + eta);
        }
        return nome + ' (' + eta + ')';
    }
}
