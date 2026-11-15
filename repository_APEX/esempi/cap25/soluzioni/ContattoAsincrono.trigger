trigger ContattoAsincrono on Contact (after insert) {
    MarcaturaContatti.marca(
        new List<Id>(Trigger.newMap.keySet()));
}
