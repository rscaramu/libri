RestRequest richiesta = new RestRequest();
richiesta.addParameter('minimo', '2');
RestContext.request = richiesta;
RestContext.response = new RestResponse();
List<ServizioCittaRest.Voce> voci =
    ServizioCittaRest.elenco();
System.debug(voci.size());
System.debug(voci[0].citta + ': ' + voci[0].aziende);
