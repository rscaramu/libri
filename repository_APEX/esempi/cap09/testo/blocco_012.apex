List<Candidato> elenco = new List<Candidato>{
    new Candidato('Rizzo', 78),
    new Candidato('Bassi', 91),
    new Candidato('Amato', 78)
};
elenco.sort(new PerNome());
for (Candidato c : elenco) {
    System.debug(c.nome);
}
