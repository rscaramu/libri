for (Schema.RecordTypeInfo tipo : Schema.SObjectType
        .Opportunity.getRecordTypeInfos()) {
    if (tipo.isAvailable()) {
        System.debug(tipo.getName());
    }
}
