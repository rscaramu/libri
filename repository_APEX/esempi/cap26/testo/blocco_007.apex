AsyncOptions opzioni = new AsyncOptions();
opzioni.DuplicateSignature =
    QueueableDuplicateSignature.Builder()
        .addString('riepilogo-italia')
        .build();
try {
    System.enqueueJob(
        new LavoroRiepilogo(new Set<Id>()), opzioni);
    System.enqueueJob(
        new LavoroRiepilogo(new Set<Id>()), opzioni);
} catch (DuplicateMessageException e) {
    System.debug('Gia\' in coda');
}
