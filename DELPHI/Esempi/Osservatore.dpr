program Osservatore;

{$APPTYPE CONSOLE}

uses
  SysUtils, Generics.Collections;

type
  TNotifica = reference to procedure(const Cosa: string);

  TSoggetto = class
  private
    FOsservatori: TList<TNotifica>;
    FStato: string;
    procedure SetStato(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Iscrivi(N: TNotifica);
    property Stato: string read FStato write SetStato;
  end;

constructor TSoggetto.Create;
begin
  inherited;
  FOsservatori := TList<TNotifica>.Create;
end;

destructor TSoggetto.Destroy;
begin
  FOsservatori.Free;
  inherited;
end;

procedure TSoggetto.Iscrivi(N: TNotifica);
begin
  FOsservatori.Add(N);
end;

procedure TSoggetto.SetStato(const Value: string);
var
  N: TNotifica;
begin
  if Value = FStato then
    Exit;
  FStato := Value;
  for N in FOsservatori do
    N(FStato);
end;

var
  S: TSoggetto;
  Registro: string;
begin
  S := TSoggetto.Create;
  try
    Registro := '';
    S.Iscrivi(procedure(const Cosa: string)
      begin
        WriteLn('cambiato in ', Cosa);
      end);
    S.Iscrivi(procedure(const Cosa: string)
      begin
        Registro := Registro + Cosa + ';';
      end);
    S.Stato := 'aperto';
    S.Stato := 'aperto';
    S.Stato := 'chiuso';
    WriteLn(Registro);
  finally
    S.Free;
  end;
end.
