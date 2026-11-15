String frase = 'il gatto e il cane e il topo';
Map<String, Integer> conteggio =
    new Map<String, Integer>();
for (String parola : frase.toLowerCase().split(' ')) {
    Integer finora = conteggio.containsKey(parola)
        ? conteggio.get(parola) : 0;
    conteggio.put(parola, finora + 1);
}
System.debug(conteggio.get('il'));
System.debug(conteggio.get('e'));
System.debug(conteggio.get('topo'));
