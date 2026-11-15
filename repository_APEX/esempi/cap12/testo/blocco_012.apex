Blob dati = Blob.valueOf('Apex');
System.debug(dati.size());
String base64 = EncodingUtil.base64Encode(dati);
System.debug(base64);
Blob indietro = EncodingUtil.base64Decode(base64);
System.debug(indietro.toString());
System.debug(EncodingUtil.urlEncode(
    'via Roma 12', 'UTF-8'));
