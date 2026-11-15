List<Dipendente> personale = new List<Dipendente>{
    new Dipendente('Lia', 1800),
    new Venditore('Teo', 1500, 20000),
    new Venditore('Ada', 1500, 8000)
};
Decimal monte = 0;
for (Dipendente persona : personale) {
    monte += persona.compenso();
}
System.debug(monte);
