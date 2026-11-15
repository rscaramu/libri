HttpRequest richiesta = new HttpRequest();
richiesta.setEndpoint(
    'callout:Servizio_Cambi/cambi?base=EUR');
richiesta.setMethod('GET');
System.debug(richiesta.getEndpoint().startsWith('callout:'));
