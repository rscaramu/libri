List<String> ordini = new List<String>{
    'Rossi', 'Verdi', 'Rossi', 'Neri', 'Rossi' };
Map<String, Integer> conteggio =
    new Map<String, Integer>();
for (String cliente : ordini) {
    if (conteggio.containsKey(cliente)) {
        conteggio.put(cliente, conteggio.get(cliente) + 1);
    } else {
        conteggio.put(cliente, 1);
    }
}
System.debug(conteggio);
