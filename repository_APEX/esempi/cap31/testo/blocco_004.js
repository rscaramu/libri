import { LightningElement, api } from 'lwc';
import creaAttivita from
    '@salesforce/apex/ControllerAziende.creaAttivita';

export default class NuovaAttivita
        extends LightningElement {
    @api recordId;
    messaggio;

    async crea() {
        try {
            await creaAttivita({
                azienda: this.recordId,
                oggetto: 'Richiamare il cliente'
            });
            this.messaggio = 'Attivita creata';
        } catch (errore) {
            this.messaggio = errore.body.message;
        }
    }
}
