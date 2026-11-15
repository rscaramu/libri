Integer scorta = 40;
Integer minimo = 25;
Boolean attivo = true;
Boolean daRiordinare = attivo && scorta < minimo;
Boolean segnalare = !attivo || scorta == 0;
System.debug(daRiordinare);
System.debug(segnalare);
