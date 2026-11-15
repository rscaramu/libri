Integer numero = 1;
for (Schema.PicklistEntry voce : Opportunity.StageName
        .getDescribe().getPicklistValues()) {
    if (voce.isActive()) {
        System.debug(numero + '. ' + voce.getValue());
        numero++;
    }
}
