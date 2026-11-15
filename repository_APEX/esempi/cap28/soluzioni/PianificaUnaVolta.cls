public with sharing class PianificaUnaVolta {

    public static Id fra(Integer minuti, String nome,
            Schedulable classe) {
        Datetime quando = Datetime.now().addMinutes(minuti);
        String cron = quando.second() + ' '
            + quando.minute() + ' ' + quando.hour() + ' '
            + quando.day() + ' ' + quando.month()
            + ' ? ' + quando.year();
        return System.schedule(nome, cron, classe);
    }
}
