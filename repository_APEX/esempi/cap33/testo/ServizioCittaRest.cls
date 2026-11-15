@RestResource(urlMapping='/v1/citta')
global with sharing class ServizioCittaRest {

    global class Voce {
        global String citta;
        global Integer aziende;
    }

    @HttpGet
    global static List<Voce> elenco() {
        String parametro =
            RestContext.request.params.get('minimo');
        Integer minimo = String.isBlank(parametro)
            ? 1 : Integer.valueOf(parametro);
        List<Voce> voci = new List<Voce>();
        for (AggregateResult r : [
                SELECT BillingCity citta, COUNT(Id) n
                FROM Account
                WHERE BillingCountry = 'Italia'
                WITH USER_MODE
                GROUP BY BillingCity
                ORDER BY BillingCity]) {
            Integer n = (Integer) r.get('n');
            if (n >= minimo) {
                Voce v = new Voce();
                v.citta = (String) r.get('citta');
                v.aziende = n;
                voci.add(v);
            }
        }
        return voci;
    }
}
