Punto p1 = new Punto(3, 4);
Punto p2 = new Punto(3, 4);
System.debug(p1);
System.debug(p1 == p2);
System.debug(p1 === p2);
Set<Punto> punti = new Set<Punto>{ p1, p2 };
System.debug(punti.size());
