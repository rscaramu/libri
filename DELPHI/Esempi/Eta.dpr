program Eta;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  EEtaNonValida = class(Exception)
  private
    FEta: Integer;
  public
    constructor Create(AEta: Integer);
    property Eta: Integer read FEta;
  end;

constructor EEtaNonValida.Create(AEta: Integer);
begin
  inherited CreateFmt('eta non valida: %d', [AEta]);
  FEta := AEta;
end;

procedure Verifica(Eta: Integer);
begin
  if (Eta < 0) or (Eta > 150) then
    raise EEtaNonValida.Create(Eta);
  WriteLn(Eta, ' ok');
end;

begin
  Verifica(30);
  try
    Verifica(200);
  except
    on E: EEtaNonValida do
      WriteLn(E.Message, ' (valore ', E.Eta, ')');
  end;
end.
