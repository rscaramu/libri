public with sharing class PuliziaAttivita
        implements Schedulable,
            Database.Batchable<sObject> {

    public void execute(SchedulableContext contesto) {
        Database.executeBatch(this, 200);
    }

    public Database.QueryLocator start(
            Database.BatchableContext contesto) {
        return Database.getQueryLocator([
            SELECT Id FROM Task
            WHERE Status = 'Completed'
            AND CreatedDate < LAST_N_DAYS:365]);
    }

    public void execute(
            Database.BatchableContext contesto,
            List<Task> lotto) {
        Database.delete(lotto, false);
    }

    public void finish(
            Database.BatchableContext contesto) {
    }
}
