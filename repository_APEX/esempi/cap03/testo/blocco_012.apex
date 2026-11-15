Date giorno = Date.newInstance(2026, 3, 8);
Datetime istante = Datetime.newInstance(
    giorno.year(), giorno.month(), giorno.day());
System.debug(istante.format('dd/MM/yyyy'));
