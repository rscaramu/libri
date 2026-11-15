trigger LeadPredefiniti on Lead (before insert) {
    for (Lead l : Trigger.new) {
        if (String.isBlank(l.Rating)) {
            l.Rating = 'Warm';
        }
        if (l.Company != null) {
            l.Company = l.Company.toUpperCase();
        }
    }
}
