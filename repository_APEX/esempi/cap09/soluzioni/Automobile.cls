public class Automobile implements Tassabile {

    private Integer chilowatt;

    public Automobile(Integer chilowatt) {
        this.chilowatt = chilowatt;
    }

    public Decimal imposta() {
        return chilowatt * 2.58;
    }
}
