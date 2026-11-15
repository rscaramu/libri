AsyncOptions opzioni = new AsyncOptions();
opzioni.MaximumQueueableStackDepth = 5;
System.enqueueJob(
    new LavoroContoAllaRovescia(3), opzioni);
