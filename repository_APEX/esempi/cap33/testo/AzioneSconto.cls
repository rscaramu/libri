public with sharing class AzioneSconto {

    public class Richiesta {
        @InvocableVariable(label='Trattativa'
            required=true)
        public Id trattativa;
        @InvocableVariable(label='Percentuale'
            required=true)
        public Decimal percentuale;
    }

    public class Risposta {
        @InvocableVariable(label='Nuovo importo')
        public Decimal importo;
        @InvocableVariable(label='Messaggio')
        public String messaggio;
    }

    @InvocableMethod(label='Applica sconto'
        category='Trattative')
    public static List<Risposta> applica(
            List<Richiesta> richieste) {
        Set<Id> chiavi = new Set<Id>();
        for (Richiesta r : richieste) {
            chiavi.add(r.trattativa);
        }
        Map<Id, Opportunity> trattative =
            new Map<Id, Opportunity>([
                SELECT Id, Amount FROM Opportunity
                WHERE Id IN :chiavi]);
        List<Risposta> risposte = new List<Risposta>();
        Map<Id, Opportunity> daScrivere =
            new Map<Id, Opportunity>();
        for (Richiesta r : richieste) {
            Risposta esito = new Risposta();
            Opportunity o = trattative.get(r.trattativa);
            if (o == null || o.Amount == null) {
                esito.messaggio = 'Trattativa non valida';
            } else if (r.percentuale < 0
                    || r.percentuale > 30) {
                esito.messaggio = 'Sconto non ammesso';
            } else {
                o.Amount = (o.Amount
                    * (100 - r.percentuale) / 100)
                    .setScale(2);
                daScrivere.put(o.Id, o);
                esito.importo = o.Amount;
                esito.messaggio = 'Sconto applicato';
            }
            risposte.add(esito);
        }
        update daScrivere.values();
        return risposte;
    }
}
