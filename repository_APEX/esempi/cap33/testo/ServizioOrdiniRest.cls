@RestResource(urlMapping='/v1/ordini')
global with sharing class ServizioOrdiniRest {

    global class Ordine {
        global String cliente;
        global List<Riga> righe;
    }

    global class Riga {
        global String codice;
        global Integer pezzi;
    }

    @HttpPost
    global static Integer ricevi() {
        Ordine o = (Ordine) JSON.deserialize(
            RestContext.request.requestBody.toString(),
            Ordine.class);
        Integer pezzi = 0;
        for (Riga r : o.righe) {
            pezzi += r.pezzi;
        }
        return pezzi;
    }
}
