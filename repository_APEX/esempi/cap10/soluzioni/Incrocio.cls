public class Incrocio {

    public static Semaforo successivo(Semaforo colore) {
        switch on colore {
            when VERDE {
                return Semaforo.GIALLO;
            }
            when GIALLO {
                return Semaforo.ROSSO;
            }
            when else {
                return Semaforo.VERDE;
            }
        }
    }
}
