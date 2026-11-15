List<Candidato> elenco = new List<Candidato>{
    new Candidato('Rizzo', 78),
    new Candidato('Bassi', 91),
    new Candidato('Amato', 64) };
elenco.sort(new PerPunteggio());
System.debug(elenco[0].nome);
