@IsTest
public class FabbricaLead {

    public static List<Lead> lead(Integer quanti) {
        List<Lead> esito = new List<Lead>();
        for (Integer i = 0; i < quanti; i++) {
            esito.add(new Lead(LastName = 'Lead ' + i,
                Company = 'Azienda ' + i));
        }
        insert esito;
        return esito;
    }
}
