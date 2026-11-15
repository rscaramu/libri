public class RicercaGlobale {

    public static Integer quanti(String termine) {
        List<List<sObject>> esiti = [
            FIND :termine IN NAME FIELDS
            RETURNING Account(Id), Contact(Id),
                Opportunity(Id)];
        Integer totale = 0;
        for (List<sObject> gruppo : esiti) {
            totale += gruppo.size();
        }
        return totale;
    }
}
