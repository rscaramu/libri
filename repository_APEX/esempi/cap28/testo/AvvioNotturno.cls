public with sharing class AvvioNotturno
        implements Schedulable {

    public void execute(SchedulableContext contesto) {
        Database.executeBatch(
            new BatchRiepilogoContatti(), 200);
    }
}
