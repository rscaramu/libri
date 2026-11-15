# Capitolo 30 — I test: dati, simulazioni e copertura

Prompt del paragrafo «Con l’IA».

1. Scrivi una classe Apex FabbricaDati annotata @IsTest con metodi per creare Account, Contact e Opportunity validi. Ogni metodo deve accettare la quantità, inserire in blocco e restituire i record. Questi sono i campi obbligatori e le regole di validità della mia org: [elencateli].

2. Scrivi una classe HttpCalloutMock Apex configurabile con codice di stato e corpo, e tre metodi di test che la usino per collaudare questa classe nei casi di risposta corretta, errore 500 e JSON malformato: [incollate la classe].

3. Questa classe Apex è difficile da collaudare perché crea da sé le proprie dipendenze: [incollate la classe]. Proponi una riscrittura con iniezione tramite interfaccia e mostrami il test con un sostituto scritto a mano.
