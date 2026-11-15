public with sharing class GestoreContatti {

    public static void primaDelSalvataggio(
            List<Contact> nuovi) {
        for (Contact c : nuovi) {
            if (c.Email != null) {
                c.Email = c.Email.toLowerCase();
            }
            if (String.isBlank(c.Title)) {
                c.Title = 'Da definire';
            }
        }
    }
}
