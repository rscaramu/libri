try {
    Parametri.leggiIntero('tentativi', 'tre');
} catch (ConfigurazioneException e) {
    System.debug(e.getMessage());
    System.debug(e.getCause().getTypeName());
}
