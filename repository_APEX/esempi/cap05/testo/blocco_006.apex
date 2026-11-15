Set<String> province = new Set<String>();
province.add('RC');
province.add('CS');
Boolean nuovo = province.add('RC');
System.debug(nuovo);
System.debug(province.size());
System.debug(province.contains('CS'));
province.remove('CS');
System.debug(province);
