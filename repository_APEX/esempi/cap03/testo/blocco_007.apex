String elenco = 'viti;dadi;rondelle';
List<String> voci = elenco.split(';');
System.debug(voci.size());
System.debug(voci[1]);
System.debug(String.join(voci, ' - '));
