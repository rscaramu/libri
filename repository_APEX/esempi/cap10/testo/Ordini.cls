public class Ordini {

    public static String prossimaAzione(
            StatoOrdine stato) {
        switch on stato {
            when BOZZA {
                return 'Completare e confermare';
            }
            when CONFERMATO {
                return 'Preparare la spedizione';
            }
            when SPEDITO {
                return 'Attendere la consegna';
            }
            when else {
                return 'Nessuna';
            }
        }
    }
}
