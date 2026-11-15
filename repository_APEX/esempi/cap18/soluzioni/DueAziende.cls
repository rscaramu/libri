public class DueAziende {

    public static Integer crea(String primo,
            String secondo) {
        insert new Account(Name = primo,
            BillingCountry = 'Prova');
        Savepoint punto = Database.setSavepoint();
        insert new Account(Name = secondo,
            BillingCountry = 'Prova');
        if (primo == secondo) {
            Database.rollback(punto);
            return 1;
        }
        return 2;
    }
}
