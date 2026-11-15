public with sharing class AzioneTrattativeAperte {

    @InvocableMethod(label='Conta trattative aperte'
        description='Conta le trattative aperte.'
        category='Aziende')
    public static List<Integer> conta(List<Id> aziende) {
        Map<Id, Integer> conteggi = new Map<Id, Integer>();
        for (AggregateResult r : [
                SELECT AccountId az, COUNT(Id) n
                FROM Opportunity
                WHERE AccountId IN :aziende
                AND IsClosed = false
                GROUP BY AccountId]) {
            conteggi.put((Id) r.get('az'),
                (Integer) r.get('n'));
        }
        List<Integer> esiti = new List<Integer>();
        for (Id azienda : aziende) {
            esiti.add(conteggi.get(azienda) ?? 0);
        }
        return esiti;
    }
}
