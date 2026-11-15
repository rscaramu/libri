trigger CasoProtezione on Case (before delete) {
    for (Case c : Trigger.old) {
        if (c.IsClosed) {
            c.addError('I casi chiusi non si cancellano');
        }
    }
}
