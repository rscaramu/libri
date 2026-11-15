Map<String, Schema.RecordTypeInfo> tipi =
    Schema.SObjectType.Account
        .getRecordTypeInfosByDeveloperName();
System.debug(tipi.containsKey('Master'));
