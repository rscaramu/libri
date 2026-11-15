trigger AziendaDescrizione on Account (before insert) {
    String oggi = Datetime.now().format('dd/MM/yyyy');
    for (Account a : Trigger.new) {
        if (String.isBlank(a.Description)) {
            a.Description = 'Creato il ' + oggi;
        }
    }
}
