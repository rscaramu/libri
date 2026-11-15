public class CreazioneAziende {

    public static Integer soloNuove(List<String> nomi) {
        Set<String> esistenti = new Set<String>();
        for (Account a : [SELECT Name FROM Account
                WHERE Name IN :nomi]) {
            esistenti.add(a.Name.toLowerCase());
        }
        List<Account> nuove = new List<Account>();
        for (String nome : nomi) {
            if (!esistenti.contains(nome.toLowerCase())) {
                nuove.add(new Account(Name = nome));
                esistenti.add(nome.toLowerCase());
            }
        }
        insert nuove;
        return nuove.size();
    }
}
