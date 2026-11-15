trigger AvvisoOrdineRobusto on Avviso_Ordine__e (
        after insert) {
    try {
        ServizioAvvisi.elabora(Trigger.new);
    } catch (DmlException e) {
        if (EventBus.TriggerContext.currentContext()
                .retries < 4) {
            throw new EventBus.RetryableException(
                'Nuovo tentativo: ' + e.getMessage());
        }
        System.debug(LoggingLevel.ERROR,
            'Rinuncia dopo 4 tentativi');
    }
}
