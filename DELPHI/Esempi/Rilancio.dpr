program Rilancio;

{$APPTYPE CONSOLE}

uses
  SysUtils;

procedure Livello2;
begin
  raise EArgumentException.Create('dato errato');
end;

procedure Livello1;
begin
  try
    Livello2;
  except
    on E: Exception do
    begin
      WriteLn('livello 1 registra: ', E.Message);
      raise;
    end;
  end;
end;

begin
  try
    Livello1;
  except
    on E: EArgumentException do
      WriteLn('programma gestisce: ', E.ClassName);
  end;
end.
