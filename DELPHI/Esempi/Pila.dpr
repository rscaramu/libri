program Pila;

{$APPTYPE CONSOLE}

type
  TPila = class
  private
    FDati: array of Integer;
    function GetCount: Integer;
    function GetVuota: Boolean;
  public
    procedure Push(V: Integer);
    function Pop: Integer;
    function Top: Integer;
    property Count: Integer read GetCount;
    property Vuota: Boolean read GetVuota;
  end;

function TPila.GetCount: Integer;
begin
  Result := Length(FDati);
end;

function TPila.GetVuota: Boolean;
begin
  Result := Length(FDati) = 0;
end;

procedure TPila.Push(V: Integer);
begin
  SetLength(FDati, Length(FDati) + 1);
  FDati[High(FDati)] := V;
end;

function TPila.Pop: Integer;
begin
  Result := FDati[High(FDati)];
  SetLength(FDati, Length(FDati) - 1);
end;

function TPila.Top: Integer;
begin
  Result := FDati[High(FDati)];
end;

var
  P: TPila;
begin
  P := TPila.Create;
  try
    P.Push(1); P.Push(2); P.Push(3);
    WriteLn(P.Count, ' ', P.Top);
    WriteLn(P.Pop, ' ', P.Pop, ' ', P.Count);
    WriteLn(P.Vuota);
    P.Pop;
    WriteLn(P.Vuota);
  finally
    P.Free;
  end;
end.
