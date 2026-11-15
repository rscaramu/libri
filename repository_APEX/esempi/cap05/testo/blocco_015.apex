List<String> vendite = new List<String>{
    'Conti:1200', 'Riva:800', 'Conti:450', 'Riva:300',
    'Sala:950' };
Map<String, Decimal> totali = new Map<String, Decimal>();
for (String v : vendite) {
    String agente = v.substringBefore(':');
    Decimal importo =
        Decimal.valueOf(v.substringAfter(':'));
    Decimal parziale = totali.containsKey(agente)
        ? totali.get(agente) : 0;
    totali.put(agente, parziale + importo);
}
for (String agente : totali.keySet()) {
    System.debug(agente + ': ' + totali.get(agente));
}
