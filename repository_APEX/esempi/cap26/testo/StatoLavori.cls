public with sharing class StatoLavori {

    public static String descrivi(Id lavoro) {
        List<AsyncApexJob> trovati = [
            SELECT Status, ExtendedStatus
            FROM AsyncApexJob WHERE Id = :lavoro];
        if (trovati.isEmpty()) {
            return 'Lavoro sconosciuto';
        }
        switch on trovati[0].Status {
            when 'Queued', 'Holding', 'Preparing' {
                return 'In attesa';
            }
            when 'Processing' {
                return 'In corso';
            }
            when 'Completed' {
                return 'Terminato';
            }
            when else {
                return 'Fallito: '
                    + trovati[0].ExtendedStatus;
            }
        }
    }
}
