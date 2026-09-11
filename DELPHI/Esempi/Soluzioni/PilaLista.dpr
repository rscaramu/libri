program PilaLista;

{$APPTYPE CONSOLE}

type
  PNodo = ^TNodo;
  TNodo = record
    Valore: Integer;
    Sotto: PNodo;
  end;
  TPila = class
  private
    FCima: PNodo;
  public
    destructor Destroy; override;
    procedure Push(V: Integer);
    function Pop: Integer;
  end;

destructor TPila.Destroy;
var
  N: PNodo;
begin
  while FCima <> nil do
  begin
    N := FCima;
    FCima := N^.Sotto;
    Dispose(N);
  end;
  inherited;
end;

procedure TPila.Push(V: Integer);
var
  N: PNodo;
begin
  New(N);
  N^.Valore := V;
  N^.Sotto := FCima;
  FCima := N;
end;

function TPila.Pop: Integer;
var
  N: PNodo;
begin
  N := FCima;
  Result := N^.Valore;
  FCima := N^.Sotto;
  Dispose(N);
end;

var
  P: TPila;
begin
  P := TPila.Create;
  try
    P.Push(1); P.Push(2); P.Push(3);
    WriteLn(P.Pop, P.Pop);
  finally
    P.Free;
  end;
end.
