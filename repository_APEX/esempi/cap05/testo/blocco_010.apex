Map<String, String> sigle = new Map<String, String>{
    'TO' => 'Torino',
    'GE' => 'Genova',
    'BO' => 'Bologna'
};
for (String sigla : sigle.keySet()) {
    System.debug(sigla + ': ' + sigle.get(sigla));
}
System.debug(sigle.values());
