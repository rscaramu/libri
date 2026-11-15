for (Integer a = 1; a <= 20; a++) {
    for (Integer b = a + 1; b <= 20; b++) {
        for (Integer c = b + 1; c <= 20; c++) {
            if (a * a + b * b == c * c) {
                System.debug(a + ', ' + b + ', ' + c);
            }
        }
    }
}
