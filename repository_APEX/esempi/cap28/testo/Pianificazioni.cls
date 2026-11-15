public with sharing class Pianificazioni {

    private static final Map<String, String> ORARI =
        new Map<String, String>{
            'APP Promemoria' => '0 0 7 ? * MON-FRI',
            'APP Riepilogo' => '0 0 2 * * ?'
        };

    public static void attiva() {
        disattiva();
        System.schedule('APP Promemoria',
            ORARI.get('APP Promemoria'),
            new PromemoriaScadenze());
        System.schedule('APP Riepilogo',
            ORARI.get('APP Riepilogo'),
            new AvvioNotturno());
    }

    public static void disattiva() {
        for (CronTrigger c : [SELECT Id FROM CronTrigger
                WHERE CronJobDetail.Name
                    IN :ORARI.keySet()]) {
            System.abortJob(c.Id);
        }
    }
}
