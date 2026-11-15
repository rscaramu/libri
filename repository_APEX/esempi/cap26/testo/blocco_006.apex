Id lavoro = System.enqueueJob(
    new LavoroRiepilogo(new Set<Id>()), 2);
System.debug(lavoro != null);
