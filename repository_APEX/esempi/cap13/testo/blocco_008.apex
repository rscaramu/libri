List<Schema.PicklistEntry> valori =
    Account.Rating.getDescribe().getPicklistValues();
for (Schema.PicklistEntry voce : valori) {
    if (voce.isActive()) {
        System.debug(voce.getValue());
    }
}
