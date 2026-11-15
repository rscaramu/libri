for (Integer anno = 1896; anno <= 1904; anno++) {
    System.debug(anno + ': ' + (Anni.eBisestile(anno)
        == Date.isLeapYear(anno)));
}
