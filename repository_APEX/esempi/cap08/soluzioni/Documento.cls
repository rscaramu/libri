public virtual class Documento {

    public virtual String intestazione() {
        return 'Officine Riva S.r.l.';
    }

    public void stampa(String testo) {
        System.debug(intestazione());
        System.debug(testo);
    }
}
