public class Fattura extends Documento {

    public override String intestazione() {
        return super.intestazione() + ' - FATTURA';
    }
}
