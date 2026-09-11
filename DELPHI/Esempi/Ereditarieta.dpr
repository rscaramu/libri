program Ereditarieta;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TVeicolo = class
  private
    FTarga: string;
  public
    constructor Create(const ATarga: string);
    function Descrizione: string; virtual;
    property Targa: string read FTarga;
  end;

  TAuto = class(TVeicolo)
  private
    FPosti: Integer;
  public
    constructor Create(const ATarga: string; APosti: Integer);
    function Descrizione: string; override;
  end;

  TCamion = class(TVeicolo)
  private
    FPortata: Double;
  public
    constructor Create(const ATarga: string;
      APortata: Double);
    function Descrizione: string; override;
  end;

constructor TVeicolo.Create(const ATarga: string);
begin
  inherited Create;
  FTarga := ATarga;
end;

function TVeicolo.Descrizione: string;
begin
  Result := 'veicolo ' + FTarga;
end;

constructor TAuto.Create(const ATarga: string;
  APosti: Integer);
begin
  inherited Create(ATarga);
  FPosti := APosti;
end;

function TAuto.Descrizione: string;
begin
  Result := inherited Descrizione +
    Format(', %d posti', [FPosti]);
end;

constructor TCamion.Create(const ATarga: string;
  APortata: Double);
begin
  inherited Create(ATarga);
  FPortata := APortata;
end;

function TCamion.Descrizione: string;
begin
  Result := Format('camion %s, portata %.1f t',
    [Targa, FPortata]);
end;

var
  Parco: array[0..2] of TVeicolo;
  V: TVeicolo;
begin
  Parco[0] := TVeicolo.Create('AA000AA');
  Parco[1] := TAuto.Create('BB111BB', 5);
  Parco[2] := TCamion.Create('CC222CC', 12.5);
  try
    for V in Parco do
      WriteLn(V.Descrizione);
  finally
    for V in Parco do
      V.Free;
  end;
end.
