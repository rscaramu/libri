public class Terrazzo implements Misurabile {

    private Decimal metriQuadri;

    public Terrazzo(Decimal metriQuadri) {
        this.metriQuadri = metriQuadri;
    }

    public Decimal superficie() {
        return metriQuadri;
    }
}
