unit Officina.Dominio;

interface

uses
  SysUtils, Generics.Collections;

type
  ECommerciale = class(Exception);

  TCliente = class
  private
    FId: Integer;
    FNome: string;
    FEmail: string;
  public
    constructor Create(AId: Integer;
      const ANome, AEmail: string);
    property Id: Integer read FId;
    property Nome: string read FNome write FNome;
    property Email: string read FEmail write FEmail;
  end;

  TArticolo = class
  private
    FCodice: string;
    FDescrizione: string;
    FPrezzo: Currency;
    FAliquota: Integer;
  public
    constructor Create(const ACodice, ADescrizione: string;
      APrezzo: Currency; AAliquota: Integer);
    property Codice: string read FCodice;
    property Descrizione: string read FDescrizione;
    property Prezzo: Currency read FPrezzo;
    property Aliquota: Integer read FAliquota;
  end;

  TRiga = class
  private
    FArticolo: TArticolo;
    FQuantita: Integer;
    FSconto: Integer;
  public
    constructor Create(AArticolo: TArticolo;
      AQuantita: Integer; ASconto: Integer = 0);
    function Imponibile: Currency;
    function Iva: Currency;
    property Articolo: TArticolo read FArticolo;
    property Quantita: Integer read FQuantita;
    property Sconto: Integer read FSconto;
  end;

  TPreventivo = class
  private
    FNumero: Integer;
    FCliente: TCliente;
    FData: TDate;
    FRighe: TObjectList<TRiga>;
    FConfermato: Boolean;
  public
    constructor Create(ANumero: Integer; ACliente: TCliente;
      AData: TDate);
    destructor Destroy; override;
    function Aggiungi(AArticolo: TArticolo;
      AQuantita: Integer; ASconto: Integer = 0): TRiga;
    procedure Rimuovi(Indice: Integer);
    function Imponibile: Currency;
    function Iva: Currency;
    function Totale: Currency;
    procedure Conferma;
    function Testo: string;
    property Numero: Integer read FNumero;
    property Cliente: TCliente read FCliente;
    property Data: TDate read FData;
    property Righe: TObjectList<TRiga> read FRighe;
    property Confermato: Boolean read FConfermato;
  end;

function Arrotonda(V: Currency): Currency;

implementation

function Arrotonda(V: Currency): Currency;
begin
  Result := Round(V * 100) / 100;
end;

{ TCliente }

constructor TCliente.Create(AId: Integer;
  const ANome, AEmail: string);
begin
  inherited Create;
  if ANome.Trim = '' then
    raise ECommerciale.Create('nome cliente obbligatorio');
  FId := AId;
  FNome := ANome.Trim;
  FEmail := AEmail.Trim;
end;

{ TArticolo }

constructor TArticolo.Create(
  const ACodice, ADescrizione: string; APrezzo: Currency;
  AAliquota: Integer);
begin
  inherited Create;
  if ACodice.Trim = '' then
    raise ECommerciale.Create('codice articolo obbligatorio');
  if APrezzo < 0 then
    raise ECommerciale.Create('prezzo negativo');
  if not (AAliquota in [0, 4, 5, 10, 22]) then
    raise ECommerciale.CreateFmt('aliquota %d non valida',
      [AAliquota]);
  FCodice := ACodice.Trim.ToUpper;
  FDescrizione := ADescrizione;
  FPrezzo := APrezzo;
  FAliquota := AAliquota;
end;

{ TRiga }

constructor TRiga.Create(AArticolo: TArticolo;
  AQuantita: Integer; ASconto: Integer);
begin
  inherited Create;
  if AArticolo = nil then
    raise ECommerciale.Create('articolo mancante');
  if AQuantita <= 0 then
    raise ECommerciale.Create('quantita non valida');
  if (ASconto < 0) or (ASconto > 100) then
    raise ECommerciale.Create('sconto non valido');
  FArticolo := AArticolo;
  FQuantita := AQuantita;
  FSconto := ASconto;
end;

function TRiga.Imponibile: Currency;
begin
  Result := Arrotonda(FArticolo.Prezzo * FQuantita *
    (100 - FSconto) / 100);
end;

function TRiga.Iva: Currency;
begin
  Result := Arrotonda(Imponibile * FArticolo.Aliquota / 100);
end;

{ TPreventivo }

constructor TPreventivo.Create(ANumero: Integer;
  ACliente: TCliente; AData: TDate);
begin
  inherited Create;
  if ACliente = nil then
    raise ECommerciale.Create('cliente mancante');
  FNumero := ANumero;
  FCliente := ACliente;
  FData := AData;
  FRighe := TObjectList<TRiga>.Create(True);
end;

destructor TPreventivo.Destroy;
begin
  FRighe.Free;
  inherited;
end;

function TPreventivo.Aggiungi(AArticolo: TArticolo;
  AQuantita: Integer; ASconto: Integer): TRiga;
begin
  if FConfermato then
    raise ECommerciale.Create('preventivo confermato');
  Result := TRiga.Create(AArticolo, AQuantita, ASconto);
  FRighe.Add(Result);
end;

procedure TPreventivo.Rimuovi(Indice: Integer);
begin
  if FConfermato then
    raise ECommerciale.Create('preventivo confermato');
  FRighe.Delete(Indice);
end;

function TPreventivo.Imponibile: Currency;
var
  R: TRiga;
begin
  Result := 0;
  for R in FRighe do
    Result := Result + R.Imponibile;
end;

function TPreventivo.Iva: Currency;
var
  R: TRiga;
begin
  Result := 0;
  for R in FRighe do
    Result := Result + R.Iva;
end;

function TPreventivo.Totale: Currency;
begin
  Result := Imponibile + Iva;
end;

procedure TPreventivo.Conferma;
begin
  if FRighe.Count = 0 then
    raise ECommerciale.Create('preventivo vuoto');
  FConfermato := True;
end;

function TPreventivo.Testo: string;
var
  SB: TStringBuilder;
  R: TRiga;
begin
  SB := TStringBuilder.Create;
  try
    SB.AppendFormat('PREVENTIVO N. %d DEL %s', [FNumero,
      FormatDateTime('dd"/"mm"/"yyyy', FData)]);
    SB.AppendLine;
    SB.AppendFormat('Cliente: %s', [FCliente.Nome]);
    SB.AppendLine;
    SB.AppendLine(StringOfChar('-', 60));
    for R in FRighe do
    begin
      SB.AppendFormat('%-8s %-20s %4d %9.2f %4d%% %9.2f',
        [R.Articolo.Codice, R.Articolo.Descrizione,
         R.Quantita, R.Articolo.Prezzo, R.Sconto,
         R.Imponibile]);
      SB.AppendLine;
    end;
    SB.AppendLine(StringOfChar('-', 60));
    SB.AppendFormat('Imponibile %49.2f', [Imponibile]);
    SB.AppendLine;
    SB.AppendFormat('IVA        %49.2f', [Iva]);
    SB.AppendLine;
    SB.AppendFormat('TOTALE     %49.2f', [Totale]);
    SB.AppendLine;
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

end.
