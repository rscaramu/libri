{ Modello - Manuale completo di Free Pascal e Lazarus }
unit Modello;
{$mode objfpc}{$H+}
interface

uses
  SysUtils, Classes, Generics.Collections, Generics.Defaults;

type
  EAttivita = class(Exception);
  TPriorita = (prBassa, prNormale, prAlta);

  TAttivita = class
  private
    FId: Integer;
    FTitolo: String;
    FPriorita: TPriorita;
    FScadenza: TDateTime;       { 0 = nessuna }
    FCompletata: Boolean;
    FCreata: TDateTime;
  public
    property Id: Integer read FId write FId;
    property Titolo: String read FTitolo write FTitolo;
    property Priorita: TPriorita read FPriorita
                                 write FPriorita;
    property Scadenza: TDateTime read FScadenza
                                 write FScadenza;
    property Completata: Boolean read FCompletata
                                 write FCompletata;
    property Creata: TDateTime read FCreata write FCreata;
    function Scaduta(Oggi: TDateTime): Boolean;
  end;

  TListaAttivita = specialize TObjectList<TAttivita>;

  TElencoAttivita = class
  private
    FElementi: TListaAttivita;
    FProssimoId: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function Aggiungi(const Titolo: String;
                      Priorita: TPriorita;
                      Scadenza: TDateTime): TAttivita;
    function Trova(Id: Integer): TAttivita;
    procedure Completa(Id: Integer);
    procedure Elimina(Id: Integer);
    function Filtra(SoloAperte: Boolean;
                    Priorita: Integer): TListaAttivita;
    function Conta(Completate: Boolean): Integer;
    procedure Svuota;
    property Elementi: TListaAttivita read FElementi;
    property ProssimoId: Integer read FProssimoId
                                 write FProssimoId;
  end;

function PrioritaDaTesto(const S: String): TPriorita;
function TestoPriorita(P: TPriorita): String;
function DataDaTesto(const S: String): TDateTime;

implementation

const
  NomiPriorita: array[TPriorita] of String =
    ('bassa', 'normale', 'alta');

function PrioritaDaTesto(const S: String): TPriorita;
var
  P: TPriorita;
begin
  for P := Low(TPriorita) to High(TPriorita) do
    if SameText(NomiPriorita[P], S) then
      Exit(P);
  raise EAttivita.CreateFmt('Priorita'' sconosciuta: %s',
                            [S]);
end;

function TestoPriorita(P: TPriorita): String;
begin
  Result := NomiPriorita[P];
end;

function DataDaTesto(const S: String): TDateTime;
var
  A, M, G: Integer;
begin
  { formato yyyy-mm-dd; stringa vuota = nessuna data }
  if S = '' then
    Exit(0);
  if (Length(S) <> 10) or (S[5] <> '-') or (S[8] <> '-') or
     not TryStrToInt(Copy(S, 1, 4), A) or
     not TryStrToInt(Copy(S, 6, 2), M) or
     not TryStrToInt(Copy(S, 9, 2), G) or
     not TryEncodeDate(A, M, G, Result) then
    raise EAttivita.CreateFmt('Data non valida: %s', [S]);
end;

function TAttivita.Scaduta(Oggi: TDateTime): Boolean;
begin
  Result := (not FCompletata) and (FScadenza > 0) and
            (FScadenza < Trunc(Oggi));
end;

constructor TElencoAttivita.Create;
begin
  FElementi := TListaAttivita.Create(True);
  FProssimoId := 1;
end;

destructor TElencoAttivita.Destroy;
begin
  FElementi.Free;
  inherited;
end;

function TElencoAttivita.Aggiungi(const Titolo: String;
  Priorita: TPriorita; Scadenza: TDateTime): TAttivita;
begin
  if Trim(Titolo) = '' then
    raise EAttivita.Create('Il titolo e'' obbligatorio');
  Result := TAttivita.Create;
  Result.Id := FProssimoId;
  Inc(FProssimoId);
  Result.Titolo := Trim(Titolo);
  Result.Priorita := Priorita;
  Result.Scadenza := Scadenza;
  Result.Creata := Now;
  FElementi.Add(Result);
end;

function TElencoAttivita.Trova(Id: Integer): TAttivita;
var
  A: TAttivita;
begin
  for A in FElementi do
    if A.Id = Id then
      Exit(A);
  raise EAttivita.CreateFmt('Attivita'' %d inesistente',
                            [Id]);
end;

procedure TElencoAttivita.Completa(Id: Integer);
var
  A: TAttivita;
begin
  A := Trova(Id);
  if A.Completata then
    raise EAttivita.CreateFmt(
      'Attivita'' %d gia'' completata', [Id]);
  A.Completata := True;
end;

procedure TElencoAttivita.Elimina(Id: Integer);
begin
  FElementi.Remove(Trova(Id));
end;

function ConfrontaAttivita(constref A, B: TAttivita): Integer;
begin
  { aperte prima delle completate, poi priorita' decrescente,
    poi scadenza crescente (0 = nessuna, in fondo) }
  Result := Ord(A.Completata) - Ord(B.Completata);
  if Result = 0 then
    Result := Ord(B.Priorita) - Ord(A.Priorita);
  if Result = 0 then
  begin
    if (A.Scadenza = 0) and (B.Scadenza <> 0) then
      Result := 1
    else if (A.Scadenza <> 0) and (B.Scadenza = 0) then
      Result := -1
    else if A.Scadenza < B.Scadenza then
      Result := -1
    else if A.Scadenza > B.Scadenza then
      Result := 1;
  end;
  if Result = 0 then
    Result := A.Id - B.Id;
end;

function TElencoAttivita.Filtra(SoloAperte: Boolean;
  Priorita: Integer): TListaAttivita;
var
  A: TAttivita;
begin
  Result := TListaAttivita.Create(False);   { non possiede }
  for A in FElementi do
    if (not SoloAperte or not A.Completata) and
       ((Priorita < 0) or (Ord(A.Priorita) = Priorita)) then
      Result.Add(A);
  Result.Sort(specialize TComparer<TAttivita>.Construct(
                @ConfrontaAttivita));
end;

function TElencoAttivita.Conta(Completate: Boolean): Integer;
var
  A: TAttivita;
begin
  Result := 0;
  for A in FElementi do
    if A.Completata = Completate then
      Inc(Result);
end;

procedure TElencoAttivita.Svuota;
begin
  FElementi.Clear;
  FProssimoId := 1;
end;

end.
