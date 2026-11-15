public class TotaliVinti {

    public static void scrivi(List<Account> aziende) {
        Map<Id, Decimal> totali = new Map<Id, Decimal>();
        for (AggregateResult r : [
                SELECT AccountId az, SUM(Amount) tot
                FROM Opportunity
                WHERE AccountId IN :aziende
                AND IsWon = true
                GROUP BY AccountId]) {
            totali.put((Id) r.get('az'),
                (Decimal) r.get('tot'));
        }
        List<Account> daScrivere = new List<Account>();
        for (Account a : aziende) {
            Decimal vinto = totali.get(a.Id) ?? 0;
            daScrivere.add(new Account(Id = a.Id,
                Description = 'Vinto: '
                    + vinto.setScale(0)));
        }
        update daScrivere;
    }
}
