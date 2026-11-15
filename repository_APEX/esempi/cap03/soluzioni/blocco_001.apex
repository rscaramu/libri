String grezza = '  manuale COMPLETO di apex  ';
String pulita = grezza.normalizeSpace()
    .toLowerCase().capitalize();
System.debug(pulita);
