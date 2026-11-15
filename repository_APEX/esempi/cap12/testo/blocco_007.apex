String ricevuto =
    '{"nome":"Tecno Sud","citta":"Lecce","ordini":7}';
Cliente c = (Cliente) JSON.deserialize(
    ricevuto, Cliente.class);
System.debug(c.nome);
System.debug(c.ordini + 1);
System.debug(c.nota);
