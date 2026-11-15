public with sharing class ElencoPianificazioni {

    public static List<String> righe() {
        List<String> esito = new List<String>();
        for (CronTrigger c : [
                SELECT CronJobDetail.Name, NextFireTime
                FROM CronTrigger
                WHERE CronJobDetail.JobType = '7'
                AND NextFireTime != null
                ORDER BY NextFireTime]) {
            esito.add(c.CronJobDetail.Name + ' - '
                + c.NextFireTime.format(
                    'dd/MM/yyyy HH:mm'));
        }
        return esito;
    }
}
