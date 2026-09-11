program Sollevare;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  EPilaVuota = class(Exception);

  TPila = class
  private
    FDati: array of Integer;
  public
    procedure Push(V: Integer);
    function Pop: Integer;
  end;

procedure TPila.Push(V: Integer);
begin
  FDati := FDati + [V];
end;

function TPila.Pop: Integer;
begin
  if Length(FDati) = 0 then
    raise EPilaVuota.Create('Pop su pila vuota');
  Result := FDati[High(FDati)];
  SetLength(FDati, Length(FDati) - 1);
end;

var
  P: TPila;
begin
  P := TPila.Create;
  try
    P.Push(1);
    WriteLn(P.Pop);
    try
      WriteLn(P.Pop);
    except
      on E: EPilaVuota do
        WriteLn('errore: ', E.Message);
    end;
  finally
    P.Free;
  end;
end.
