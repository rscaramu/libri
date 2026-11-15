Id azienda = [SELECT Id FROM Account
    WHERE Name = 'Energia Blu' LIMIT 1].Id;
ControllerRiepilogo.Scheda s =
    ControllerRiepilogo.scheda(azienda);
System.debug(s.nome + ': ' + s.contatti + ' contatti');
System.debug(s.vinto.setScale(0));
System.debug(s.rilevante);
