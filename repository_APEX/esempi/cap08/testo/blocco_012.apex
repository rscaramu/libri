List<Figura> figure = new List<Figura>{
    new Cerchio(2), new Quadrato(3) };
for (Figura f : figure) {
    System.debug(f.descrizione());
}
