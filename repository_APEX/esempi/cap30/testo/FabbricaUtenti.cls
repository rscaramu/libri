@IsTest
public class FabbricaUtenti {

    public static User standard() {
        Profile profilo = [SELECT Id FROM Profile
            WHERE Name = 'Standard User' LIMIT 1];
        String unico = String.valueOf(
            Crypto.getRandomInteger()).remove('-');
        User u = new User(
            LastName = 'Collaudo',
            Alias = 'coll',
            Email = 'collaudo@test.example',
            Username = 'collaudo' + unico
                + '@test.example',
            ProfileId = profilo.Id,
            TimeZoneSidKey = 'Europe/Rome',
            LocaleSidKey = 'it_IT',
            LanguageLocaleKey = 'it',
            EmailEncodingKey = 'UTF-8');
        insert u;
        return u;
    }
}
