public with sharing class Ripetizioni {

    public static Boolean daRiprovare(
            Integer stato, Integer tentativo) {
        Set<Integer> passeggeri =
            new Set<Integer>{ 429, 500, 502, 503, 504 };
        return tentativo < 3
            && passeggeri.contains(stato);
    }

    public static Integer minutiDiAttesa(
            Integer tentativo) {
        return Math.min(10,
            Math.pow(2, tentativo).intValue());
    }
}
