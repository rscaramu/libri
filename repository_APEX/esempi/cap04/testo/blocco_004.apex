Integer priorita;
switch on priorita {
    when null {
        System.debug('Priorita\' non assegnata');
    }
    when 1, 2 {
        System.debug('Urgente');
    }
    when else {
        System.debug('Ordinaria');
    }
}
