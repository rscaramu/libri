Map<String, Integer> scorte = new Map<String, Integer>();
scorte.put('viti', 500);
scorte.put('dadi', 320);
scorte.put('viti', 450);
System.debug(scorte.get('viti'));
System.debug(scorte.get('chiodi'));
System.debug(scorte.containsKey('dadi'));
System.debug(scorte.size());
