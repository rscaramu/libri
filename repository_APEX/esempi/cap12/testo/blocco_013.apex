Blob impronta = Crypto.generateDigest(
    'SHA-256', Blob.valueOf('Apex'));
String esadecimale = EncodingUtil.convertToHex(impronta);
System.debug(esadecimale.length());
