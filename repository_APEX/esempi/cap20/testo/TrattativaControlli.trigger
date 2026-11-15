trigger TrattativaControlli on Opportunity (
        before insert, before update) {
    for (Opportunity o : Trigger.new) {
        if (o.Amount != null && o.Amount < 0) {
            o.Amount.addError(
                'L\'importo non puo\' essere negativo');
        }
    }
}
