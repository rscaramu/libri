public class RicercaIngenua {

    public static Integer conta(String nome) {
        String testo = 'SELECT COUNT() FROM Account'
            + ' WHERE Name = \'' + nome + '\'';
        return Database.countQuery(testo);
    }
}
