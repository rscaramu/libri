String termine = String.escapeSingleQuotes('Energia');
String ricerca = 'FIND \'' + termine + '\''
    + ' IN NAME FIELDS RETURNING Account(Name)';
List<List<sObject>> esiti = Search.query(ricerca);
System.debug(esiti[0].size());
