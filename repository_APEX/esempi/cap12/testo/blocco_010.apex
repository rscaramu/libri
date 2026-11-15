Pattern p = Pattern.compile(
    '(\\d{2})/(\\d{2})/(\\d{4})');
Matcher m = p.matcher('Consegna prevista il 08/03/2026.');
if (m.find()) {
    System.debug(m.group());
    System.debug(m.group(1));
    System.debug(m.group(3));
}
