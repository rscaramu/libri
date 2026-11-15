public class Ricerche {

    public static Contact perPosta(String indirizzo) {
        if (String.isBlank(indirizzo)) {
            return null;
        }
        List<Contact> trovati = [
            SELECT FirstName, LastName, Title
            FROM Contact
            WHERE Email = :indirizzo.trim()
            LIMIT 1
        ];
        return trovati.isEmpty() ? null : trovati[0];
    }
}
