Long inizio = System.currentTimeMillis();
Integer somma = 0;
for (Integer i = 0; i < 100000; i++) {
    somma += i;
}
Long durata = System.currentTimeMillis() - inizio;
System.debug(durata >= 0);
