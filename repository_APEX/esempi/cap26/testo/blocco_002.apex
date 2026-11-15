Set<Id> chiavi = new Map<Id, Account>([
    SELECT Id FROM Account
    WHERE BillingCountry = 'Italia']).keySet();
Id lavoro = System.enqueueJob(
    new LavoroRiepilogo(chiavi));
System.debug(lavoro != null);
System.debug(Limits.getQueueableJobs());
