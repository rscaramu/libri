public class Punto {

    public Integer x { get; private set; }
    public Integer y { get; private set; }

    public Punto(Integer x, Integer y) {
        this.x = x;
        this.y = y;
    }

    public override String toString() {
        return '(' + x + ', ' + y + ')';
    }

    public Boolean equals(Object altro) {
        if (altro instanceof Punto) {
            Punto p = (Punto) altro;
            return x == p.x && y == p.y;
        }
        return false;
    }

    public Integer hashCode() {
        return 31 * x + y;
    }
}
