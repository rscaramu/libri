program EventiMulti;

{$APPTYPE CONSOLE}

uses
  Generics.Collections;

type
  TAscoltatore = reference to procedure(const Msg: string);
  TEventi = class
  private
    FLista: TList<TAscoltatore>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Iscrivi(A: TAscoltatore);
    procedure Notifica(const Msg: string);
  end;

constructor TEventi.Create;
begin
  inherited;
  FLista := TList<TAscoltatore>.Create;
end;

destructor TEventi.Destroy;
begin
  FLista.Free;
  inherited;
end;

procedure TEventi.Iscrivi(A: TAscoltatore);
begin
  FLista.Add(A);
end;

procedure TEventi.Notifica(const Msg: string);
var
  A: TAscoltatore;
begin
  for A in FLista do
    A(Msg);
end;

var
  E: TEventi;
  Uno, Due: string;
begin
  E := TEventi.Create;
  try
    E.Iscrivi(procedure(const Msg: string)
      begin
        Uno := Uno + Msg;
      end);
    E.Iscrivi(procedure(const Msg: string)
      begin
        Due := Due + '[' + Msg + ']';
      end);
    E.Notifica('a');
    E.Notifica('b');
    WriteLn(Uno, ' ', Due);
  finally
    E.Free;
  end;
end.
