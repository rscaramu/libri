List<Integer> voti = new List<Integer>{ 27, 30, 24, 28 };
voti.set(2, 25);
voti.add(1, 18);
Integer tolto = voti.remove(0);
System.debug(voti);
System.debug(tolto);
System.debug(voti.contains(30));
System.debug(voti.indexOf(25));
System.debug(voti.isEmpty());
