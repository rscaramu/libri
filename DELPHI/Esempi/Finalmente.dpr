program Finalmente;

{$APPTYPE CONSOLE}

uses
  SysUtils;

procedure Lavora(Fallisci: Boolean);
var
  SB: TStringBuilder;
begin
  SB := TStringBuilder.Create;
  try
    SB.Append('inizio');
    if Fallisci then
      raise Exception.Create('guasto');
    SB.Append(' fine');
    WriteLn(SB.ToString);
  finally
    SB.Free;
    WriteLn('risorsa liberata');
  end;
end;

begin
  Lavora(False);
  try
    Lavora(True);
  except
    on E: Exception do
      WriteLn('gestito: ', E.Message);
  end;
end.
