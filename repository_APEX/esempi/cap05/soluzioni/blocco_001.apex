List<Integer> numeri = new List<Integer>();
for (Integer i = 1; i <= 20; i++) {
    numeri.add(i);
}
List<Integer> multipli = new List<Integer>();
for (Integer n : numeri) {
    if (Math.mod(n, 3) == 0) {
        multipli.add(n);
    }
}
System.debug(multipli);
