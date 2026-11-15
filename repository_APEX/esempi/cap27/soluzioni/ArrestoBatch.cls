public with sharing class ArrestoBatch {

    public static Integer ferma(String classe) {
        List<AsyncApexJob> attivi = [
            SELECT Id FROM AsyncApexJob
            WHERE JobType = 'BatchApex'
            AND ApexClass.Name = :classe
            AND Status IN ('Holding', 'Queued',
                'Preparing', 'Processing')];
        for (AsyncApexJob lavoro : attivi) {
            System.abortJob(lavoro.Id);
        }
        return attivi.size();
    }
}
