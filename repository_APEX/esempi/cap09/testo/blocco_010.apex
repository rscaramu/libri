List<Candidato> graduatoria = new List<Candidato>{
    new Candidato('Rizzo', 78),
    new Candidato('Bassi', 91),
    new Candidato('Amato', 78)
};
graduatoria.sort();
for (Candidato c : graduatoria) {
    System.debug(c.nome + ' ' + c.punteggio);
}
