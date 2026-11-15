List<Dipendente> personale = new List<Dipendente>{
    new Dipendente('Lia', 1800),
    new Dirigente('Eva', 3000, 500)
};
for (Dipendente persona : personale) {
    System.debug(persona.cedolino());
}
