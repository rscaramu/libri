Id azienda = [SELECT Id FROM Account
    WHERE Name = 'Tecno Sud' LIMIT 1].Id;
UserRecordAccess accesso = [
    SELECT RecordId, HasReadAccess, HasEditAccess
    FROM UserRecordAccess
    WHERE UserId = :UserInfo.getUserId()
        AND RecordId = :azienda
];
System.debug(accesso.HasEditAccess);
