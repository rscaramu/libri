program Fabbrica;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  IRegistro = interface
    procedure Scrivi(const Msg: string);
  end;

  TRegistroConsole = class(TInterfacedObject, IRegistro)
    procedure Scrivi(const Msg: string);
  end;

  TRegistroMuto = class(TInterfacedObject, IRegistro)
    procedure Scrivi(const Msg: string);
  end;

procedure TRegistroConsole.Scrivi(const Msg: string);
begin
  WriteLn('[log] ', Msg);
end;

procedure TRegistroMuto.Scrivi(const Msg: string);
begin
end;

function NuovoRegistro(Attivo: Boolean): IRegistro;
begin
  if Attivo then
    Result := TRegistroConsole.Create
  else
    Result := TRegistroMuto.Create;
end;

procedure Lavora(const Log: IRegistro);
begin
  Log.Scrivi('inizio');
  Log.Scrivi('fine');
end;

begin
  Lavora(NuovoRegistro(True));
  Lavora(NuovoRegistro(False));
  WriteLn('nessun Free necessario');
end.
