List<String> dati = new List<String>{
    'RC:Scilla', 'CS:Rende', 'RC:Palmi', 'RC:Bagnara' };
Map<String, List<String>> perProvincia =
    new Map<String, List<String>>();
for (String riga : dati) {
    String provincia = riga.substringBefore(':');
    if (!perProvincia.containsKey(provincia)) {
        perProvincia.put(provincia, new List<String>());
    }
    perProvincia.get(provincia)
        .add(riga.substringAfter(':'));
}
for (String provincia : perProvincia.keySet()) {
    System.debug(provincia + ': '
        + perProvincia.get(provincia).size());
}
