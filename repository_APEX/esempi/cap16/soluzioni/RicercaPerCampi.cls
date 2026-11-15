public class RicercaPerCampi {

    public static List<Account> cerca(
            Map<String, Object> filtri) {
        Map<String, Schema.SObjectField> campi =
            Account.sObjectType.getDescribe()
                .fields.getMap();
        List<String> condizioni = new List<String>();
        Map<String, Object> valori =
            new Map<String, Object>();
        Integer n = 0;
        for (String campo : filtri.keySet()) {
            if (!campi.containsKey(campo)) {
                continue;
            }
            String nome = campi.get(campo)
                .getDescribe().getName();
            condizioni.add(nome + ' = :v' + n);
            valori.put('v' + n, filtri.get(campo));
            n++;
        }
        String testo = 'SELECT Name FROM Account';
        if (!condizioni.isEmpty()) {
            testo += ' WHERE '
                + String.join(condizioni, ' AND ');
        }
        return Database.queryWithBinds(testo + ' LIMIT 100',
            valori, AccessLevel.USER_MODE);
    }
}
