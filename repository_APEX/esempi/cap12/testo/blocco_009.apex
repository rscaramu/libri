String modello = '[A-Z]{2}-\\d{4}';
System.debug(Pattern.matches(modello, 'AB-2026'));
System.debug(Pattern.matches(modello, 'ab-2026'));
System.debug(Pattern.matches(modello, 'AB-20261'));
