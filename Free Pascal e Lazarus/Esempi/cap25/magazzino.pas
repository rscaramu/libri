{ Magazzino - Manuale completo di Free Pascal e Lazarus }
unit Magazzino;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Generics.Collections;

type
  EMagazzino = class(Exception);

  TArticolo = class
  private
    FCodice: String;
    FDescrizione: String;
    FGiacenza: Integer;
    FPrezzo: Currency;
  public
    constructor Create(const ACodice, ADescrizione: String;
                       APrezzo: Currency);
    property Codice: String read FCodice;
    property Descrizione: String read FDescrizione;
    property Giacenza: Integer read FGiacenza;
    property Prezzo: Currency read FPrezzo;
  end;

  TArticoli = specialize TObjectList<TArticolo>;

  TMagazzino = class
  private
    FArticoli: TArticoli;
    FOnCambio: TNotifyEvent;
    procedure Cambiato;
  public
    constructor Create;
    destructor Destroy; override;
    function Aggiungi(const Codice, Descrizione: String;
                      Prezzo: Currency): TArticolo;
    function Trova(const Codice: String): TArticolo;
    procedure Carica(const Codice: String; Quanti: Integer);
    procedure Scarica(const Codice: String; Quanti: Integer);
    function ValoreTotale: Currency;
    property Articoli: TArticoli read FArticoli;
    property OnCambio: TNotifyEvent read FOnCambio
                                    write FOnCambio;
  end;

implementation

constructor TArticolo.Create(const ACodice,
  ADescrizione: String; APrezzo: Currency);
begin
  FCodice := ACodice;
  FDescrizione := ADescrizione;
  FPrezzo := APrezzo;
end;

constructor TMagazzino.Create;
begin
  FArticoli := TArticoli.Create(True);
end;

destructor TMagazzino.Destroy;
begin
  FArticoli.Free;
  inherited;
end;

procedure TMagazzino.Cambiato;
begin
  if Assigned(FOnCambio) then
    FOnCambio(Self);
end;

function TMagazzino.Aggiungi(const Codice,
  Descrizione: String; Prezzo: Currency): TArticolo;
begin
  if Trova(Codice) <> nil then
    raise EMagazzino.CreateFmt('Codice %s duplicato',
                               [Codice]);
  if Prezzo < 0 then
    raise EMagazzino.Create('Prezzo negativo');
  Result := TArticolo.Create(Codice, Descrizione, Prezzo);
  FArticoli.Add(Result);
  Cambiato;
end;

function TMagazzino.Trova(const Codice: String): TArticolo;
var
  A: TArticolo;
begin
  for A in FArticoli do
    if SameText(A.Codice, Codice) then
      Exit(A);
  Result := nil;
end;

procedure TMagazzino.Carica(const Codice: String;
                            Quanti: Integer);
var
  A: TArticolo;
begin
  A := Trova(Codice);
  if A = nil then
    raise EMagazzino.CreateFmt('Codice %s inesistente',
                               [Codice]);
  if Quanti <= 0 then
    raise EMagazzino.Create('Quantita'' non positiva');
  A.FGiacenza := A.FGiacenza + Quanti;
  Cambiato;
end;

procedure TMagazzino.Scarica(const Codice: String;
                             Quanti: Integer);
var
  A: TArticolo;
begin
  A := Trova(Codice);
  if A = nil then
    raise EMagazzino.CreateFmt('Codice %s inesistente',
                               [Codice]);
  if Quanti > A.FGiacenza then
    raise EMagazzino.CreateFmt('Giacenza %d insufficiente',
                               [A.FGiacenza]);
  A.FGiacenza := A.FGiacenza - Quanti;
  Cambiato;
end;

function TMagazzino.ValoreTotale: Currency;
var
  A: TArticolo;
begin
  Result := 0;
  for A in FArticoli do
    Result := Result + A.Giacenza * A.Prezzo;
end;

end.
