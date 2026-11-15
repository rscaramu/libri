Id lavoro = Database.executeBatch(
    new BatchRiepilogoContatti());
System.debug(lavoro != null);
