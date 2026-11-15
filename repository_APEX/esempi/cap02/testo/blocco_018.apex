Integer totale = 7384;
Integer ore = totale / 3600;
Integer minuti = Math.mod(totale, 3600) / 60;
Integer secondi = Math.mod(totale, 60);
System.debug(ore + ' h ' + minuti + ' min '
    + secondi + ' s');
