List<User> io = [SELECT Id FROM User
    WHERE Id = :UserInfo.getUserId()];
System.debug(Passaggi2.nonAncoraTrattati(
    'sconti', io).size());
System.debug(Passaggi2.nonAncoraTrattati(
    'avvisi', io).size());
System.debug(Passaggi2.nonAncoraTrattati(
    'sconti', io).size());
