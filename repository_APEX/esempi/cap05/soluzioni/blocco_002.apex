List<Integer> dati =
    new List<Integer>{ 5, 3, 9, 3, 7, 5, 1 };
List<Integer> unici =
    new List<Integer>(new Set<Integer>(dati));
unici.sort();
System.debug(unici);
