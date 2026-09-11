{ RTTI - Manuale completo di Free Pascal e Lazarus }
program RTTI;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, TypInfo, Variants;
type
  TColore = (cRosso, cVerde, cBlu);
  TProdotto = class(TPersistent)
  private
    FNome: String;
    FPrezzo: Double;
    FQuantita: Integer;
    FColore: TColore;
    FAttivo: Boolean;
  published
    property Nome: String read FNome write FNome;
    property Prezzo: Double read FPrezzo write FPrezzo;
    property Quantita: Integer read FQuantita write FQuantita;
    property Colore: TColore read FColore write FColore;
    property Attivo: Boolean read FAttivo write FAttivo;
  end;

procedure Elenca(Obj: TObject);
var
  Lista: PPropList;
  N, I: Integer;
begin
  N := GetPropList(Obj, Lista);
  try
    for I := 0 to N - 1 do
      WriteLn(Lista^[I]^.Name:10, ' : ',
              Lista^[I]^.PropType^.Name:10, ' = ',
              VarToStr(GetPropValue(Obj, Lista^[I]^.Name,
                                    True)));
  finally
    FreeMem(Lista);
  end;
end;

var
  P: TProdotto;
begin
  P := TProdotto.Create;
  try
    P.Nome := 'Lampada';
    P.Prezzo := 19.9;
    P.Quantita := 3;
    P.Colore := cVerde;
    P.Attivo := True;
    Elenca(P);
    SetPropValue(P, 'Quantita', 10);
    SetPropValue(P, 'Colore', 'cBlu');
    WriteLn('Quantita: ', P.Quantita, ', Colore: ',
            GetEnumName(TypeInfo(TColore), Ord(P.Colore)));
    WriteLn('IsPublishedProp: ', IsPublishedProp(P, 'Nome'),
            ' ', IsPublishedProp(P, 'Peso'));
  finally
    P.Free;
  end;
end.
