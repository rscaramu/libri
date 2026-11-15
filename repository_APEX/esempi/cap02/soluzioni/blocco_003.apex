Integer numero = 472;
Integer centinaia = numero / 100;
Integer decine = Math.mod(numero, 100) / 10;
Integer unita = Math.mod(numero, 10);
System.debug(centinaia + decine + unita);
