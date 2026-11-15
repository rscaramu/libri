HttpResponse finta = new HttpResponse();
finta.setStatusCode(201);
System.debug(EsitoChiamata.classifica(finta));
finta.setStatusCode(503);
System.debug(EsitoChiamata.classifica(finta));
finta.setStatusCode(404);
System.debug(EsitoChiamata.classifica(finta));
