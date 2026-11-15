Set<String> ordinati =
    new Set<String>{ 'A1', 'B2', 'C3', 'D4' };
Set<String> consegnati = new Set<String>{ 'B2', 'D4' };
Set<String> inAttesa = ordinati.clone();
inAttesa.removeAll(consegnati);
System.debug(inAttesa);
