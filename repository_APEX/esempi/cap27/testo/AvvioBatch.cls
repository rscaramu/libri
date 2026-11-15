public with sharing class AvvioBatch {

    public static Id revisione() {
        Integer inCorso = [
            SELECT COUNT() FROM AsyncApexJob
            WHERE JobType = 'BatchApex'
            AND ApexClass.Name = 'BatchRevisione'
            AND Status IN ('Holding', 'Queued',
                'Preparing', 'Processing')];
        if (inCorso > 0) {
            return null;
        }
        return Database.executeBatch(
            new BatchRevisione());
    }
}
