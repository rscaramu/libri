Account a = [SELECT Name FROM Account
    WHERE Name = 'Tecno Sud' LIMIT 1];
System.debug(a.Id != null);
try {
    System.debug(a.Phone);
} catch (SObjectException e) {
    System.debug('Campo non letto');
}
