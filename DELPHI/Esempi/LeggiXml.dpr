program LeggiXml;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, Xml.XMLDoc, Xml.XMLIntf, Winapi.ActiveX;

const
  Testo = '<?xml version="1.0" encoding="UTF-8"?>' +
    '<ordine numero="42" urgente="true">' +
    '<cliente>Rossi, Bianchi &amp; C.</cliente>' +
    '<righe>' +
    '<riga codice="A1" quantita="3"/>' +
    '<riga codice="B7" quantita="1"/>' +
    '</righe></ordine>';

var
  Doc: IXMLDocument;
  Radice, Righe, Riga: IXMLNode;
  I: Integer;
begin
  CoInitialize(nil);
  try
    Doc := TXMLDocument.Create(nil);
    Doc.LoadFromXML(Testo);
    Doc.Active := True;
    Radice := Doc.DocumentElement;
    WriteLn(Radice.NodeName, ' n. ',
      Radice.Attributes['numero']);
    WriteLn(Radice.ChildNodes['cliente'].Text);
    Righe := Radice.ChildNodes['righe'];
    for I := 0 to Righe.ChildNodes.Count - 1 do
    begin
      Riga := Righe.ChildNodes[I];
      WriteLn(Riga.Attributes['codice'], ' x ',
        Riga.Attributes['quantita']);
    end;
    Radice.Attributes['urgente'] := 'false';
    Righe.AddChild('riga').Attributes['codice'] := 'C3';
    WriteLn(Doc.XML.Text);
  finally
    CoUninitialize;
  end;
end.
