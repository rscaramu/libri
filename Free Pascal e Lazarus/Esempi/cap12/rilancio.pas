{ Rilancio - Manuale completo di Free Pascal e Lazarus }
program Rilancio;
{$mode objfpc}{$H+}
uses
  SysUtils;

procedure LivelloBasso;
begin
  raise EInOutError.Create('disco non trovato');
end;

procedure LivelloMedio;
begin
  try
    LivelloBasso;
  except
    on E: EInOutError do
    begin
      WriteLn('  medio: registro "', E.Message,
              '" e rilancio');
      raise;
    end;
  end;
end;

procedure LivelloAlto;
begin
  try
    LivelloMedio;
  except
    on E: EInOutError do
      raise Exception.Create('Salvataggio fallito: ' +
                             E.Message);
  end;
end;

begin
  try
    LivelloAlto;
  except
    on E: Exception do
      WriteLn('utente: ', E.Message);
  end;
end.
