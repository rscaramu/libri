public class Calcolatore {

    public static Decimal dividi(String a, String b) {
        try {
            Decimal x = Decimal.valueOf(a);
            Decimal y = Decimal.valueOf(b);
            return x / y;
        } catch (TypeException e) {
            System.debug('Dato non numerico');
        } catch (MathException e) {
            System.debug('Divisione per zero');
        } catch (Exception e) {
            System.debug('Errore imprevisto: '
                + e.getMessage());
        }
        return null;
    }
}
