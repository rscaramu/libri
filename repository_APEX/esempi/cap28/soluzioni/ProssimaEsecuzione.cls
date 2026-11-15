public with sharing class ProssimaEsecuzione {

    public static Datetime di(String nome) {
        List<CronTrigger> trovate = [
            SELECT NextFireTime FROM CronTrigger
            WHERE CronJobDetail.Name = :nome LIMIT 1];
        return trovate.isEmpty()
            ? null : trovate[0].NextFireTime;
    }
}
