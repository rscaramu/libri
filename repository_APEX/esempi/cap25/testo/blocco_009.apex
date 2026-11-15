List<Id> chiavi = new List<Id>(new Map<Id, Contact>([
    SELECT Id FROM Contact
    WHERE MailingCountry = 'Italia']).keySet());
MarcaturaContatti.marca(chiavi);
System.debug(Limits.getFutureCalls());
