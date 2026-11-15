public virtual class GestoreTrigger {

    private static Set<String> sospesi = new Set<String>();

    public static void sospendi(String nomeGestore) {
        sospesi.add(nomeGestore);
    }

    public static void riattiva(String nomeGestore) {
        sospesi.remove(nomeGestore);
    }

    public void esegui() {
        if (sospesi.contains(nome())) {
            return;
        }
        switch on Trigger.operationType {
            when BEFORE_INSERT {
                primaInserimento(Trigger.new);
            }
            when BEFORE_UPDATE {
                primaModifica(Trigger.new, Trigger.oldMap);
            }
            when BEFORE_DELETE {
                primaCancellazione(Trigger.old);
            }
            when AFTER_INSERT {
                dopoInserimento(Trigger.new);
            }
            when AFTER_UPDATE {
                dopoModifica(Trigger.new, Trigger.oldMap);
            }
            when AFTER_DELETE {
                dopoCancellazione(Trigger.old);
            }
            when AFTER_UNDELETE {
                dopoRipristino(Trigger.new);
            }
        }
    }

    protected virtual String nome() {
        return String.valueOf(this).substringBefore(':');
    }

    protected virtual void primaInserimento(
        List<sObject> nuovi) {}
    protected virtual void primaModifica(
        List<sObject> nuovi, Map<Id, sObject> vecchi) {}
    protected virtual void primaCancellazione(
        List<sObject> vecchi) {}
    protected virtual void dopoInserimento(
        List<sObject> nuovi) {}
    protected virtual void dopoModifica(
        List<sObject> nuovi, Map<Id, sObject> vecchi) {}
    protected virtual void dopoCancellazione(
        List<sObject> vecchi) {}
    protected virtual void dopoRipristino(
        List<sObject> nuovi) {}
}
