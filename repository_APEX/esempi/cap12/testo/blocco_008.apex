String ricevuto = '{"cliente":"Tecno Sud",'
    + '"righe":[{"codice":"V-10","pezzi":200},'
    + '{"codice":"D-08","pezzi":150}]}';
Map<String, Object> radice = (Map<String, Object>)
    JSON.deserializeUntyped(ricevuto);
System.debug(radice.get('cliente'));
List<Object> righe = (List<Object>) radice.get('righe');
Integer totale = 0;
for (Object elemento : righe) {
    Map<String, Object> riga =
        (Map<String, Object>) elemento;
    totale += (Integer) riga.get('pezzi');
}
System.debug(totale);
