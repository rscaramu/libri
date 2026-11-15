Long n = 27;
Integer passi = 0;
while (n != 1) {
    if (Math.mod(n, 2) == 0) {
        n = n / 2;
    } else {
        n = n * 3 + 1;
    }
    passi++;
}
System.debug(passi);
