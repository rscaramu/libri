Id lavoro = System.enqueueJob(
    new LavoroRiepilogo(new Set<Id>()));
System.debug(StatoLavori.descrivi(lavoro));
