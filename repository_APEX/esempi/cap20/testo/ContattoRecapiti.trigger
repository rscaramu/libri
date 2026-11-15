trigger ContattoRecapiti on Contact (
        before insert, before update) {
    for (Contact c : Trigger.new) {
        if (String.isBlank(c.Email)
                && String.isBlank(c.Phone)
                && c.Description == 'Controllo recapiti') {
            c.addError(
                'Indicare almeno un recapito');
        }
    }
}
