import { LightningElement, wire } from 'lwc';
import italiane from
    '@salesforce/apex/ControllerAziende.italiane';

export default class ElencoAziende
        extends LightningElement {
    @wire(italiane)
    aziende;
}
