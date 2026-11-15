public virtual class GestoreConfigurabile {

    protected virtual String nome() {
        return String.valueOf(this).substringBefore(':');
    }

    public Boolean abilitato() {
        Parametro__mdt p =
            Parametro__mdt.getInstance(nome());
        return p == null || p.Attivo__c;
    }
}
