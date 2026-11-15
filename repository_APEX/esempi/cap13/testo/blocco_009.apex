Account modello = new Account(
    Name = 'Filiale Nord', Industry = 'Energy');
Account copia = modello.clone();
copia.Name = 'Filiale Sud';
System.debug(modello.Name);
System.debug(copia.Industry);
Map<String, Object> presenti =
    copia.getPopulatedFieldsAsMap();
System.debug(presenti.keySet());
