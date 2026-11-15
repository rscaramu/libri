public class ConteggioCitta {

    public static Integer aziende(String citta) {
        return Database.countQuery(
            'SELECT COUNT() FROM Account'
            + ' WHERE BillingCountry = \'Italia\''
            + ' AND BillingCity = :citta');
    }
}
