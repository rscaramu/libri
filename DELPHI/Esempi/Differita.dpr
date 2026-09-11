program Differita;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TAlTermine = reference to procedure(const Esito: string);

  TLavoro = class
  private
    FAlTermine: TAlTermine;
    FNome: string;
  public
    constructor Create(const ANome: string;
      AlTermine: TAlTermine);
    procedure Esegui;
  end;

constructor TLavoro.Create(const ANome: string;
  AlTermine: TAlTermine);
begin
  inherited Create;
  FNome := ANome;
  FAlTermine := AlTermine;
end;

procedure TLavoro.Esegui;
begin
  WriteLn('eseguo ', FNome);
  if Assigned(FAlTermine) then
    FAlTermine('ok ' + FNome);
end;

var
  L: TLavoro;
  Registro: string;
begin
  Registro := '';
  L := TLavoro.Create('backup',
    procedure(const Esito: string)
    begin
      Registro := Registro + Esito + '; ';
    end);
  try
    L.Esegui;
    L.Esegui;
  finally
    L.Free;
  end;
  WriteLn(Registro);
end.
