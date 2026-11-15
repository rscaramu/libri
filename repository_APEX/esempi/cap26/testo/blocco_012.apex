Id lavoro = System.enqueueJob(new LavoroCopia([
    SELECT Name, Industry FROM Account
    WHERE BillingCountry = 'Italia' LIMIT 2]));
System.debug([SELECT Status FROM AsyncApexJob
    WHERE Id = :lavoro].Status);
