{ Url - Manuale completo di Free Pascal e Lazarus }
program Url;
{$mode objfpc}{$H+}
uses
  SysUtils, URIParser, httpprotocol, base64;
var
  U: TURI;
begin
  U := ParseURI('https://api.esempio.it:8443/v1/utenti' +
                '?q=ada&n=5');
  WriteLn(U.Protocol, ' ', U.Host, ' ', U.Port, ' ', U.Path,
          U.Document, ' [', U.Params, ']');
  WriteLn(HTTPEncode('nome con spazi & simboli'));
  WriteLn(Length(HTTPDecode('citt%C3%A0')), ' byte');
  WriteLn(EncodeStringBase64('utente:segreto'));
  WriteLn(DecodeStringBase64('dXRlbnRlOnNlZ3JldG8='));
end.
