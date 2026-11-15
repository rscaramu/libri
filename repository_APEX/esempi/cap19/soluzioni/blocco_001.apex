for (Schema.SObjectType tipo : new List<Schema.SObjectType>{
        Account.sObjectType, Contact.sObjectType,
        Opportunity.sObjectType, Case.sObjectType }) {
    Schema.DescribeSObjectResult d = tipo.getDescribe();
    System.debug(d.getName() + ': crea '
        + d.isCreateable() + ', cancella '
        + d.isDeletable());
}
