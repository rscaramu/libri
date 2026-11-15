Id pianificazione = System.scheduleBatch(
    new BatchRiepilogoContatti(),
    'Riepilogo fra un\'ora', 60, 200);
System.debug(pianificazione != null);
System.abortJob(pianificazione);
