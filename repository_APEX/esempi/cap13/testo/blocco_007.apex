Schema.DescribeSObjectResult oggetto =
    Account.sObjectType.getDescribe();
System.debug(oggetto.getName());
System.debug(oggetto.getKeyPrefix());
System.debug(oggetto.isCustom());
Schema.DescribeFieldResult campo =
    Account.Industry.getDescribe();
System.debug(campo.getType());
System.debug(campo.isUpdateable());
