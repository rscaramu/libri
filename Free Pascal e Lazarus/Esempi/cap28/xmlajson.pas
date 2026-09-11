{ XmlAJson - Manuale completo di Free Pascal e Lazarus }
program XmlAJson;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, DOM, XMLRead, fpjson;
var
  Doc: TXMLDocument;
  Nodo: TDOMNode;
  A: TJSONArray;
  O: TJSONObject;
begin
  ReadXMLFile(Doc, 'biblioteca.xml');
  A := TJSONArray.Create;
  try
    Nodo := Doc.DocumentElement.FirstChild;
    while Nodo <> nil do
    begin
      if (Nodo.NodeType = ELEMENT_NODE) and
         (Nodo.NodeName = 'libro') then
      begin
        O := TJSONObject.Create;
        O.Add('id', StrToInt(TDOMElement(Nodo)['id']));
        O.Add('anno', StrToInt(TDOMElement(Nodo)['anno']));
        O.Add('titolo', String(Nodo.TextContent));
        A.Add(O);
      end;
      Nodo := Nodo.NextSibling;
    end;
    WriteLn(A.FormatJSON);
  finally
    A.Free;
    Doc.Free;
  end;
end.
