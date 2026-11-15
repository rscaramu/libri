public class Guardia {

    public static Boolean restaMargine() {
        return Limits.getQueries()
                < Limits.getLimitQueries() - 10
            && Limits.getCpuTime()
                < Limits.getLimitCpuTime() * 0.8;
    }
}
