trigger ContattoTrigger on Contact (
        before insert, before update) {
    GestoreContatti.primaDelSalvataggio(Trigger.new);
}
