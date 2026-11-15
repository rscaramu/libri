public with sharing class GestoreCasiProtetti
        extends GestoreTrigger {

    protected override void primaCancellazione(
            List<sObject> vecchi) {
        for (Case c : (List<Case>) vecchi) {
            if (c.IsClosed) {
                c.addError(
                    'I casi chiusi non si cancellano');
            }
        }
    }
}
