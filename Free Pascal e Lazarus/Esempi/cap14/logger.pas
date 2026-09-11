{ Logger - Manuale completo di Free Pascal e Lazarus }
program Logger;
{$mode objfpc}{$H+}
type
  TLogger = class
  public
    procedure Scrivi(const Msg: String); virtual; abstract;
  end;

  TLoggerConsole = class(TLogger)
    procedure Scrivi(const Msg: String); override;
  end;

  TLoggerMemoria = class(TLogger)
  private
    FTesto: String;
  public
    procedure Scrivi(const Msg: String); override;
    property Testo: String read FTesto;
  end;

procedure TLoggerConsole.Scrivi(const Msg: String);
begin
  WriteLn('[console] ', Msg);
end;

procedure TLoggerMemoria.Scrivi(const Msg: String);
begin
  FTesto := FTesto + Msg + '|';
end;

procedure Elabora(Log: TLogger);
begin
  Log.Scrivi('inizio');
  Log.Scrivi('fine');
end;

var
  M: TLoggerMemoria;
  C: TLoggerConsole;
begin
  C := TLoggerConsole.Create;
  M := TLoggerMemoria.Create;
  try
    Elabora(C);
    Elabora(M);
    WriteLn('In memoria: ', M.Testo);
  finally
    C.Free;
    M.Free;
  end;
end.
