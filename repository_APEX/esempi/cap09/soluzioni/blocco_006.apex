List<Evento> agenda = new List<Evento>{
    new Evento('Fiera', Date.newInstance(2027, 3, 10)),
    new Evento('Corso', Date.newInstance(2026, 12, 1)),
    new Evento('Visita', Date.newInstance(2027, 1, 20)) };
agenda.sort();
for (Evento e : agenda) {
    System.debug(e.titolo);
}
