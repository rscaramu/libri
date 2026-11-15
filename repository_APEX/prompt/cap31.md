# Capitolo 31 — Apex per l’interfaccia: componenti Lightning e Visualforce

Prompt del paragrafo «Con l’IA».

1. Scrivi un controller Apex per un Lightning Web Component che mostri le opportunità aperte di un Account con nome, importo e data di chiusura. Usa @AuraEnabled(cacheable=true), with sharing, WITH USER_MODE e una classe wrapper. Poi scrivi il file JavaScript del componente che lo chiama con @wire passando recordId.

2. Fai una revisione di sicurezza di questo controller Apex con metodi @AuraEnabled: [incollate la classe]. Considera che ogni metodo può essere chiamato dal browser con parametri arbitrari. Elenca i rischi e le correzioni.

3. Questa è una pagina Visualforce con il suo controller: [incollate entrambi]. Spiegami che cosa fa e proponi la struttura di un Lightning Web Component equivalente, indicando quali metodi del controller diventano @AuraEnabled e quali non servono più.
