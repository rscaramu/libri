{ Vincoli - Manuale completo di Free Pascal e Lazarus }
program Vincoli;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes;
type
  generic TContenitore<T: TObject> = class
  private
    FElementi: array of T;
  public
    destructor Destroy; override;
    procedure Aggiungi(E: T);
    function Nomi: String;
  end;

  TContenitoreStringhe = specialize TContenitore<TStringList>;

destructor TContenitore.Destroy;
var
  E: T;
begin
  for E in FElementi do
    E.Free;              { lecito: T e' un TObject }
  inherited;
end;

procedure TContenitore.Aggiungi(E: T);
begin
  SetLength(FElementi, Length(FElementi) + 1);
  FElementi[High(FElementi)] := E;
end;

function TContenitore.Nomi: String;
var
  E: T;
begin
  Result := '';
  for E in FElementi do
    Result := Result + E.ClassName + ' ';
end;

var
  C: TContenitoreStringhe;
begin
  C := TContenitoreStringhe.Create;
  try
    C.Aggiungi(TStringList.Create);
    C.Aggiungi(TStringList.Create);
    WriteLn(C.Nomi);
  finally
    C.Free;
  end;
end.
