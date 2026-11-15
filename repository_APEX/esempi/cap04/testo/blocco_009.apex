for (Integer n = 1; n <= 10; n++) {
    if (Math.mod(n, 2) == 0) {
        continue;
    }
    if (n > 7) {
        break;
    }
    System.debug(n);
}
