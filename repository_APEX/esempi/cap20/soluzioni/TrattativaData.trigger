trigger TrattativaData on Opportunity (before insert) {
    for (Opportunity o : Trigger.new) {
        if (o.CloseDate < Date.today()) {
            o.CloseDate.addError(
                'La data di chiusura e\' nel passato');
        }
    }
}
