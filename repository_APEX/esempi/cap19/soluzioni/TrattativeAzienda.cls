public with sharing class TrattativeAzienda {

    public static List<Opportunity> aperte(Id azienda) {
        return [
            SELECT Name, StageName, Amount, CloseDate
            FROM Opportunity
            WHERE AccountId = :azienda
                AND IsClosed = false
            WITH USER_MODE
            ORDER BY CloseDate
        ];
    }
}
