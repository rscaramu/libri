System.debug(ControlloSconti.ammesso(8));
System.debug(ControlloSconti.ammesso(20));
insert new Automazione__c(
    SetupOwnerId = UserInfo.getUserId(),
    Sconto_Massimo__c = 25);
System.debug(ControlloSconti.ammesso(20));
delete [SELECT Id FROM Automazione__c
    WHERE SetupOwnerId = :UserInfo.getUserId()];
