List<String> indirizzi = new List<String>{
    'Anna@esempio.it', 'luca@esempio.it',
    'anna@esempio.it', 'LUCA@esempio.it',
    'bea@esempio.it' };
Set<String> unici = new Set<String>();
for (String indirizzo : indirizzi) {
    unici.add(indirizzo.toLowerCase());
}
List<String> risultato = new List<String>(unici);
risultato.sort();
System.debug(risultato);
