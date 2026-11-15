AsyncOptions opzioni = new AsyncOptions();
opzioni.MaximumQueueableStackDepth = 10;
Id lavoro = System.enqueueJob(
    new LavoroMarcatura(new List<Id>()), opzioni);
System.debug(lavoro != null);
