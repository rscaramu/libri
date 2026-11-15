public class Geometria {

    public static Decimal areaRettangolo(
            Decimal base, Decimal altezza) {
        return base * altezza;
    }

    public static Boolean eQuadrato(
            Decimal base, Decimal altezza) {
        return base == altezza;
    }

    public static void descrivi(
            Decimal base, Decimal altezza) {
        System.debug('Area: '
            + areaRettangolo(base, altezza));
        if (eQuadrato(base, altezza)) {
            System.debug('E\' un quadrato');
        }
    }
}
