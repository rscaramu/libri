Type tipo = Type.forName('NessunoSconto');
PoliticaSconto politica =
    (PoliticaSconto) tipo.newInstance();
System.debug(politica.applica(80));
