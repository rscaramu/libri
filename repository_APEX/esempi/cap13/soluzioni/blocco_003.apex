Map<String, Schema.SObjectField> campi =
    Contact.sObjectType.getDescribe().fields.getMap();
for (String nome : new List<String>{ 'LastName',
        'Email', 'Birthdate', 'AccountId',
        'DoNotCall' }) {
    Schema.DescribeFieldResult d =
        campi.get(nome).getDescribe();
    System.debug(d.getLabel() + ' - ' + d.getName()
        + ' - ' + d.getType());
}
