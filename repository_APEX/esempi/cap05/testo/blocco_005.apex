List<Integer> originale = new List<Integer>{ 1, 2, 3 };
List<Integer> alias = originale;
List<Integer> copia = originale.clone();
alias.add(4);
System.debug(originale);
System.debug(copia);
