{ XmlDemo - Manuale completo di Free Pascal e Lazarus }
program XmlDemo;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, DOM, XMLRead, XMLWrite;
var
  Doc: TXMLDocument;
  Radice, Libro, Titolo: TDOMElement;
  Nodo: TDOMNode;
  I: Integer;
begin
  Doc := TXMLDocument.Create;
  try
    Radice := Doc.CreateElement('biblioteca');
    Doc.AppendChild(Radice);
    for I := 1 to 2 do
    begin
      Libro := Doc.CreateElement('libro');
      Libro.SetAttribute('id', IntToStr(I));
      Libro.SetAttribute('anno', IntToStr(1970 + I * 10));
      Titolo := Doc.CreateElement('titolo');
      Titolo.AppendChild(Doc.CreateTextNode('Libro ' +
                                            IntToStr(I)));
      Libro.AppendChild(Titolo);
      Radice.AppendChild(Libro);
    end;
    WriteXMLFile(Doc, 'biblioteca.xml');
  finally
    Doc.Free;
  end;

  ReadXMLFile(Doc, 'biblioteca.xml');
  try
    WriteLn('Radice: ', Doc.DocumentElement.NodeName);
    Nodo := Doc.DocumentElement.FirstChild;
    while Nodo <> nil do
    begin
      if Nodo.NodeType = ELEMENT_NODE then
        WriteLn('  ', Nodo.NodeName, ' id=',
                TDOMElement(Nodo).GetAttribute('id'),
                ' anno=', TDOMElement(Nodo)['anno'],
                ': ', Nodo.TextContent);
      Nodo := Nodo.NextSibling;
    end;
    WriteLn('Libri: ',
            Doc.GetElementsByTagName('libro').Count);
  finally
    Doc.Free;
  end;
end.
