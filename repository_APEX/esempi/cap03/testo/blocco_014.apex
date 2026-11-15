String posta = 'giulia.ferri@esempio.it';
String utente = posta.substringBefore('@');
String nome = utente.substringBefore('.').capitalize();
String cognome = utente.substringAfter('.').capitalize();
System.debug(nome + ' ' + cognome);
