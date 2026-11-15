trigger ContattoNormalizza on Contact (
        before insert, before update) {
    for (Contact c : Trigger.new) {
        if (c.Email != null) {
            c.Email = c.Email.toLowerCase();
        }
        if (String.isBlank(c.Title)) {
            c.Title = 'Da definire';
        }
    }
}
