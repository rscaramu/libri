program Gerarchia;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  EAppErrore = class(Exception);
  EAppDati = class(EAppErrore);
  EAppRete = class(EAppErrore);

procedure Prova(Quale: Integer);
begin
  try
    case Quale of
      1: raise EAppDati.Create('dati');
      2: raise EAppRete.Create('rete');
      3: raise EConvertError.Create('conversione');
    end;
  except
    on E: EAppDati do WriteLn('specifico dati: ', E.Message);
    on E: EAppRete do WriteLn('specifico rete: ', E.Message);
  end;
end;

procedure ProvaGenerica(Quale: Integer);
begin
  try
    Prova(Quale);
  except
    on E: EAppErrore do WriteLn('applicazione: ', E.Message);
    on E: Exception do WriteLn('altro: ', E.ClassName);
  end;
end;

begin
  ProvaGenerica(1);
  ProvaGenerica(2);
  ProvaGenerica(3);
end.
