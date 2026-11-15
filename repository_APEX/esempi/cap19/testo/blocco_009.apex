Schema.DescribeSObjectResult oggetto =
    Schema.sObjectType.Account;
System.debug(oggetto.isAccessible());
System.debug(oggetto.isCreateable());
System.debug(oggetto.isUpdateable());
System.debug(oggetto.isDeletable());
Schema.DescribeFieldResult campo =
    Schema.sObjectType.Account.fields.AnnualRevenue;
System.debug(campo.isAccessible());
System.debug(campo.isUpdateable());
