public class Calendario {

    public static Boolean lavorativo(Giorno g) {
        switch on g {
            when SABATO, DOMENICA {
                return false;
            }
            when else {
                return true;
            }
        }
    }
}
