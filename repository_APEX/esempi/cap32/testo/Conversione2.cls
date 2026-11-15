public with sharing class Conversione2 {

    public static Decimal daEuro(Decimal importo,
            String valuta) {
        ClienteCambi.Listino listino =
            new ClienteCambi().leggi('EUR');
        Decimal tasso = listino.tassi?.get(valuta);
        if (tasso == null) {
            throw new ClienteCambi.CambiException(
                'Valuta non disponibile: ' + valuta);
        }
        return (importo * tasso).setScale(2);
    }
}
