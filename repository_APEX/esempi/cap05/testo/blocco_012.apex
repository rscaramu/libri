Map<String, List<String>> perReparto =
    new Map<String, List<String>>();
List<String> dati = new List<String>{
    'Vendite:Anna', 'Acquisti:Luca', 'Vendite:Piero' };
for (String riga : dati) {
    String reparto = riga.substringBefore(':');
    String persona = riga.substringAfter(':');
    if (!perReparto.containsKey(reparto)) {
        perReparto.put(reparto, new List<String>());
    }
    perReparto.get(reparto).add(persona);
}
System.debug(perReparto.get('Vendite'));
