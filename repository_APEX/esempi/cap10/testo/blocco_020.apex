Integer lavorativi = 0;
for (Giorno g : Giorno.values()) {
    if (Calendario.lavorativo(g)) {
        lavorativi++;
    }
}
System.debug(lavorativi);
