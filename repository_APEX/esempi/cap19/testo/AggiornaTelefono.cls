public with sharing class AggiornaTelefono {

    public static String esegui(Id azienda,
            String telefono) {
        try {
            update as user new Account(
                Id = azienda, Phone = telefono);
            return 'Telefono aggiornato';
        } catch (DmlException e) {
            System.debug(LoggingLevel.ERROR,
                e.getMessage());
            return 'Non siete autorizzati a modificare'
                + ' questa azienda';
        }
    }
}
