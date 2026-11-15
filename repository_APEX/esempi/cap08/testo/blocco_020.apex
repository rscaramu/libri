List<Notifica> avvisi = new List<Notifica>{
    new NotificaPosta(), new NotificaSms() };
for (Notifica n : avvisi) {
    n.invia('Ordine spedito');
}
