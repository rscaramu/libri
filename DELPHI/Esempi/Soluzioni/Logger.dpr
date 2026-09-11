program Logger;

{$APPTYPE CONSOLE}

type
  ILogger = interface
    procedure Scrivi(const Msg: string);
  end;
  TLoggerVideo = class(TInterfacedObject, ILogger)
    procedure Scrivi(const Msg: string);
  end;
  TLoggerMemoria = class(TInterfacedObject, ILogger)
  public
    Testo: string;
    procedure Scrivi(const Msg: string);
  end;
  TServizio = class
  private
    FLog: ILogger;
  public
    constructor Create(const ALog: ILogger);
    procedure Lavora;
  end;

procedure TLoggerVideo.Scrivi(const Msg: string);
begin
  WriteLn('[video] ', Msg);
end;

procedure TLoggerMemoria.Scrivi(const Msg: string);
begin
  Testo := Testo + Msg + ';';
end;

constructor TServizio.Create(const ALog: ILogger);
begin
  inherited Create;
  FLog := ALog;
end;

procedure TServizio.Lavora;
begin
  FLog.Scrivi('inizio');
  FLog.Scrivi('fine');
end;

var
  S: TServizio;
  M: TLoggerMemoria;
  L: ILogger;
begin
  S := TServizio.Create(TLoggerVideo.Create);
  try
    S.Lavora;
  finally
    S.Free;
  end;
  M := TLoggerMemoria.Create;
  L := M;
  S := TServizio.Create(L);
  try
    S.Lavora;
    WriteLn(M.Testo);
  finally
    S.Free;
  end;
end.
