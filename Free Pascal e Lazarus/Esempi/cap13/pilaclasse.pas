{ PilaClasse - Manuale completo di Free Pascal e Lazarus }
program PilaClasse;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes;
type
  TPila = class
  private
    FDati: array of Integer;
    FCima: Integer;
  public
    constructor Create;
    procedure Push(V: Integer);
    function Pop: Integer;
    function Vuota: Boolean;
    property Dimensione: Integer read FCima;
  end;

constructor TPila.Create;
begin
  inherited Create;
  SetLength(FDati, 4);
  FCima := 0;
end;

procedure TPila.Push(V: Integer);
begin
  if FCima = Length(FDati) then
    SetLength(FDati, Length(FDati) * 2);
  FDati[FCima] := V;
  Inc(FCima);
end;

function TPila.Pop: Integer;
begin
  if FCima = 0 then
    raise EListError.Create('Pila vuota');
  Dec(FCima);
  Result := FDati[FCima];
end;

function TPila.Vuota: Boolean;
begin
  Result := FCima = 0;
end;

var
  P: TPila;
  I: Integer;
begin
  P := TPila.Create;
  try
    for I := 1 to 10 do
      P.Push(I * I);
    WriteLn('Dimensione: ', P.Dimensione);
    while not P.Vuota do
      Write(P.Pop, ' ');
    WriteLn;
    try
      P.Pop;
    except
      on E: EListError do
        WriteLn(E.Message);
    end;
  finally
    P.Free;
  end;
end.
