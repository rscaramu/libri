Id a = UserInfo.getUserId();
List<User> io = [SELECT Id FROM User WHERE Id = :a];
System.debug(Passaggi2.nonAncoraTrattati(
    'regola-uno', io).size());
System.debug(Passaggi2.nonAncoraTrattati(
    'regola-uno', io).size());
System.debug(Passaggi2.nonAncoraTrattati(
    'regola-due', io).size());
