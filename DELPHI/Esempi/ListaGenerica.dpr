program ListaGenerica;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TPila<T> = class
  private
    FDati: TArray<T>;
    function GetCount: Integer;
  public
    procedure Push(const V: T);
    function Pop: T;
    function Top: T;
    property Count: Integer read GetCount;
  end;

function TPila<T>.GetCount: Integer;
begin
  Result := Length(FDati);
end;

procedure TPila<T>.Push(const V: T);
begin
  FDati := FDati + [V];
end;

function TPila<T>.Pop: T;
begin
  if Length(FDati) = 0 then
    raise EInvalidOpException.Create('pila vuota');
  Result := FDati[High(FDati)];
  SetLength(FDati, Length(FDati) - 1);
end;

function TPila<T>.Top: T;
begin
  Result := FDati[High(FDati)];
end;

var
  Interi: TPila<Integer>;
  Parole: TPila<string>;
  S: string;
begin
  Interi := TPila<Integer>.Create;
  Parole := TPila<string>.Create;
  try
    Interi.Push(1); Interi.Push(2);
    Parole.Push('uno'); Parole.Push('due');
    WriteLn(Interi.Pop + Interi.Pop);
    S := Parole.Pop;
    S := S + Parole.Pop;
    WriteLn(S);
    WriteLn(Interi.Count, ' ', Parole.Count);
  finally
    Interi.Free;
    Parole.Free;
  end;
end.
