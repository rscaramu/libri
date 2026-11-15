String testo =
    '{"citta":"Bari","temperature":[18,21,19,24]}';
Map<String, Object> radice = (Map<String, Object>)
    JSON.deserializeUntyped(testo);
Integer massima;
for (Object t : (List<Object>) radice.get('temperature')) {
    Integer valore = (Integer) t;
    if (massima == null || valore > massima) {
        massima = valore;
    }
}
System.debug(massima);
