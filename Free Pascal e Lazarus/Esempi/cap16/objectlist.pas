{ ObjectList - Manuale completo di Free Pascal e Lazarus }
program ObjectList;
{$mode objfpc}{$H+}
uses
  SysUtils, Generics.Collections;
type
  TProdotto = class
  public
    Nome: String;
    Prezzo: Currency;
    constructor Create(const ANome: String;
                       APrezzo: Currency);
    destructor Destroy; override;
  end;
  TProdotti = specialize TObjectList<TProdotto>;

constructor TProdotto.Create(const ANome: String;
                             APrezzo: Currency);
begin
  Nome := ANome;
  Prezzo := APrezzo;
end;

destructor TProdotto.Destroy;
begin
  WriteLn('  distrutto ', Nome);
  inherited;
end;

var
  Lista: TProdotti;
  P: TProdotto;
  Totale: Currency;
begin
  Lista := TProdotti.Create(True);
  try
    Lista.Add(TProdotto.Create('penna', 1.5));
    Lista.Add(TProdotto.Create('quaderno', 2.5));
    Lista.Add(TProdotto.Create('zaino', 30));
    Totale := 0;
    for P in Lista do
      Totale := Totale + P.Prezzo;
    WriteLn('Totale: ', Totale:0:2);
    Lista.Delete(0);            { distrugge la penna }
    P := Lista.Extract(Lista[0]); { il quaderno sopravvive }
    WriteLn('Estratto: ', P.Nome, ', restano ', Lista.Count);
    P.Free;
  finally
    Lista.Free;                 { distrugge lo zaino }
  end;
end.
