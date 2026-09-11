program Stipendi;

{$APPTYPE CONSOLE}

type
  TDipendente = class
  private
    FNome: string;
  public
    constructor Create(const ANome: string);
    function Stipendio: Currency; virtual; abstract;
    property Nome: string read FNome;
  end;

  TImpiegato = class(TDipendente)
  private
    FFisso: Currency;
  public
    constructor Create(const ANome: string; AFisso: Currency);
    function Stipendio: Currency; override;
  end;

  TVenditore = class(TImpiegato)
  private
    FVendite: Currency;
  public
    constructor Create(const ANome: string;
      AFisso, AVendite: Currency);
    function Stipendio: Currency; override;
  end;

constructor TDipendente.Create(const ANome: string);
begin
  inherited Create;
  FNome := ANome;
end;

constructor TImpiegato.Create(const ANome: string;
  AFisso: Currency);
begin
  inherited Create(ANome);
  FFisso := AFisso;
end;

function TImpiegato.Stipendio: Currency;
begin
  Result := FFisso;
end;

constructor TVenditore.Create(const ANome: string;
  AFisso, AVendite: Currency);
begin
  inherited Create(ANome, AFisso);
  FVendite := AVendite;
end;

function TVenditore.Stipendio: Currency;
begin
  Result := inherited Stipendio + FVendite * 0.05;
end;

procedure StampaTotale(const Persone: array of TDipendente);
var
  D: TDipendente;
  Totale: Currency;
begin
  Totale := 0;
  for D in Persone do
  begin
    WriteLn(D.Nome, ': ', D.Stipendio:0:2);
    Totale := Totale + D.Stipendio;
  end;
  WriteLn('Totale: ', Totale:0:2);
end;

var
  P: array[0..1] of TDipendente;
begin
  P[0] := TImpiegato.Create('Anna', 1800);
  P[1] := TVenditore.Create('Luca', 1200, 20000);
  try
    StampaTotale(P);
  finally
    P[0].Free;
    P[1].Free;
  end;
end.
