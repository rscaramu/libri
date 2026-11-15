List<String> conDoppioni =
    new List<String>{ 'blu', 'rosso', 'blu', 'verde' };
Set<String> unici = new Set<String>(conDoppioni);
System.debug(unici.size());
