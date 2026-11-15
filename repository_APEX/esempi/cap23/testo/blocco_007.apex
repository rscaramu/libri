insert new Automazione__c(
    SetupOwnerId = UserInfo.getUserId(),
    Sconto_Massimo__c = 25);
System.debug(
    Automazione__c.getInstance().Sconto_Massimo__c);
System.debug(
    Automazione__c.getOrgDefaults().Sconto_Massimo__c);
delete [SELECT Id FROM Automazione__c
    WHERE SetupOwnerId = :UserInfo.getUserId()];
