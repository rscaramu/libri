Opportunity o = [SELECT Id FROM Opportunity
    WHERE Name = 'Portale clienti' LIMIT 1];
AzioneSconto.Richiesta r = new AzioneSconto.Richiesta();
r.trattativa = o.Id;
r.percentuale = 50;
List<AzioneSconto.Risposta> esiti =
    AzioneSconto.applica(
        new List<AzioneSconto.Richiesta>{ r });
System.debug(esiti[0].messaggio);
System.debug(esiti[0].importo);
