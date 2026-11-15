String primi = '';
for (Integer n = 2; n <= 30; n++) {
    Boolean primo = true;
    for (Integer d = 2; d * d <= n; d++) {
        if (Math.mod(n, d) == 0) {
            primo = false;
            break;
        }
    }
    if (primo) {
        primi += n + ' ';
    }
}
System.debug(primi.trim());
