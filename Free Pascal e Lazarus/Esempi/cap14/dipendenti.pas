{ Dipendenti - Manuale completo di Free Pascal e Lazarus }
program Dipendenti;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  TDipendente = class
  protected
    FNome: String;
    FBase: Currency;
  public
    constructor Create(const ANome: String; ABase: Currency);
    function Stipendio: Currency; virtual;
    function Riga: String;
  end;

  TManager = class(TDipendente)
  private
    FBonus: Currency;
  public
    constructor Create(const ANome: String; ABase: Currency;
                       ABonus: Currency);
    function Stipendio: Currency; override;
  end;

  TVenditore = class(TDipendente)
  private
    FVendite: Currency;
  public
    constructor Create(const ANome: String; ABase: Currency;
                       AVendite: Currency);
    function Stipendio: Currency; override;
  end;

constructor TDipendente.Create(const ANome: String;
                               ABase: Currency);
begin
  FNome := ANome;
  FBase := ABase;
end;

function TDipendente.Stipendio: Currency;
begin
  Result := FBase;
end;

function TDipendente.Riga: String;
begin
  Result := Format('%-10s %-10s %10.2f',
                   [FNome, ClassName, Stipendio]);
end;

constructor TManager.Create(const ANome: String;
                            ABase: Currency;
                            ABonus: Currency);
begin
  inherited Create(ANome, ABase);
  FBonus := ABonus;
end;

function TManager.Stipendio: Currency;
begin
  Result := inherited Stipendio + FBonus;
end;

constructor TVenditore.Create(const ANome: String;
                              ABase: Currency;
                              AVendite: Currency);
begin
  inherited Create(ANome, ABase);
  FVendite := AVendite;
end;

function TVenditore.Stipendio: Currency;
begin
  Result := inherited Stipendio + FVendite * 0.05;
end;

var
  Personale: array[0..2] of TDipendente;
  D: TDipendente;
  Totale: Currency;
begin
  Personale[0] := TDipendente.Create('Rossi', 1500);
  Personale[1] := TManager.Create('Bianchi', 2500, 800);
  Personale[2] := TVenditore.Create('Verdi', 1200, 20000);
  Totale := 0;
  for D in Personale do
  begin
    WriteLn(D.Riga);
    Totale := Totale + D.Stipendio;
  end;
  WriteLn('Totale: ', Totale:0:2);
  for D in Personale do
    D.Free;
end.
