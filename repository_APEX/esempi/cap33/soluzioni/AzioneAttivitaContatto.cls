public with sharing class AzioneAttivitaContatto {

    public class Richiesta {
        @InvocableVariable(label='Contatto'
            required=true)
        public Id contatto;
        @InvocableVariable(label='Oggetto'
            required=true)
        public String oggetto;
    }

    public class Risposta {
        @InvocableVariable(label='Attivita')
        public Id attivita;
    }

    @InvocableMethod(label='Crea attivita per contatto'
        category='Contatti')
    public static List<Risposta> crea(
            List<Richiesta> richieste) {
        Set<Id> chiavi = new Set<Id>();
        for (Richiesta r : richieste) {
            chiavi.add(r.contatto);
        }
        Map<Id, Contact> contatti = new Map<Id, Contact>([
            SELECT OwnerId FROM Contact
            WHERE Id IN :chiavi]);
        List<Task> attivita = new List<Task>();
        for (Richiesta r : richieste) {
            attivita.add(new Task(Subject = r.oggetto,
                WhoId = r.contatto,
                OwnerId = contatti.get(r.contatto)
                    ?.OwnerId ?? UserInfo.getUserId()));
        }
        insert attivita;
        List<Risposta> risposte = new List<Risposta>();
        for (Task t : attivita) {
            Risposta esito = new Risposta();
            esito.attivita = t.Id;
            risposte.add(esito);
        }
        return risposte;
    }
}
