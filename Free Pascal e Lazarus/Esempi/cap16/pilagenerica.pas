{ PilaGenerica - Manuale completo di Free Pascal e Lazarus }
program PilaGenerica;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  generic TPila<T> = class
  private
    FDati: array of T;
    FCima: Integer;
  public
    procedure Push(const V: T);
    function Pop: T;
    function Vuota: Boolean;
    property Dimensione: Integer read FCima;
  end;

  TPilaInteri = specialize TPila<Integer>;
  TPilaStringhe = specialize TPila<String>;

procedure TPila.Push(const V: T);
begin
  if FCima = Length(FDati) then
    SetLength(FDati, 4 + Length(FDati) * 2);
  FDati[FCima] := V;
  Inc(FCima);
end;

function TPila.Pop: T;
begin
  if FCima = 0 then
    raise Exception.Create('Pila vuota');
  Dec(FCima);
  Result := FDati[FCima];
end;

function TPila.Vuota: Boolean;
begin
  Result := FCima = 0;
end;

var
  PI: TPilaInteri;
  PS: TPilaStringhe;
  S1, S2: String;
begin
  PI := TPilaInteri.Create;
  PS := TPilaStringhe.Create;
  try
    PI.Push(1);
    PI.Push(2);
    PS.Push('a');
    PS.Push('b');
    WriteLn(PI.Pop + PI.Pop);
    S1 := PS.Pop;
    S2 := PS.Pop;
    WriteLn(S1 + S2);
    { PI.Push('x');  -> errore di compilazione }
  finally
    PI.Free;
    PS.Free;
  end;
end.
