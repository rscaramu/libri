trigger ContattoDiario on Contact (
        after insert, after update, after delete) {
    switch on Trigger.operationType {
        when AFTER_INSERT {
            System.debug('Creati: ' + Trigger.size);
        }
        when AFTER_UPDATE {
            System.debug('Modificati: ' + Trigger.size);
        }
        when AFTER_DELETE {
            System.debug('Cancellati: ' + Trigger.size);
        }
    }
}
