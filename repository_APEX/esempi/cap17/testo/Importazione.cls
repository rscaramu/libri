public class Importazione {

    public static Integer contatti(List<Contact> lista) {
        Integer salvati = 0;
        List<Database.SaveResult> esiti =
            Database.insert(lista, false);
        for (Integer i = 0; i < esiti.size(); i++) {
            if (esiti[i].isSuccess()) {
                salvati++;
                continue;
            }
            for (Database.Error e
                    : esiti[i].getErrors()) {
                System.debug(LoggingLevel.WARN,
                    'Riga ' + i + ': ' + e.getMessage());
            }
        }
        return salvati;
    }
}
