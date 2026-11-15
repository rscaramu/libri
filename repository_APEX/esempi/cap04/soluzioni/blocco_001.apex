Integer voto = 82;
String giudizio;
if (voto < 60) {
    giudizio = 'insufficiente';
} else if (voto < 75) {
    giudizio = 'sufficiente';
} else if (voto < 90) {
    giudizio = 'buono';
} else {
    giudizio = 'ottimo';
}
System.debug(giudizio);
