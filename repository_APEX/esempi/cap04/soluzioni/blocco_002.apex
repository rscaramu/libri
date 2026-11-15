Integer mese = 4;
switch on mese {
    when 1, 3, 5, 7, 8, 10, 12 {
        System.debug(31);
    }
    when 4, 6, 9, 11 {
        System.debug(30);
    }
    when 2 {
        System.debug(28);
    }
    when else {
        System.debug('Mese non valido');
    }
}
