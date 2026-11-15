Id lavoro = Database.executeBatch(
    new BatchRiepilogoContatti(), 50);
System.debug(lavoro != null);
