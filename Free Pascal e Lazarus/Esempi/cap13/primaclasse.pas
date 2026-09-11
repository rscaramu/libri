{ PrimaClasse - Manuale completo di Free Pascal e Lazarus }
program PrimaClasse;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  TContatore = class
  private
    FValore: Integer;
    FPasso: Integer;
  public
    constructor Create(APasso: Integer);
    procedure Incrementa;
    procedure Azzera;
    function Descrizione: String;
    property Valore: Integer read FValore;
    property Passo: Integer read FPasso write FPasso;
  end;

constructor TContatore.Create(APasso: Integer);
begin
  inherited Create;
  FPasso := APasso;
  FValore := 0;
end;

procedure TContatore.Incrementa;
begin
  FValore := FValore + FPasso;
end;

procedure TContatore.Azzera;
begin
  FValore := 0;
end;

function TContatore.Descrizione: String;
begin
  Result := Format('valore %d, passo %d', [FValore, FPasso]);
end;

var
  C: TContatore;
begin
  C := TContatore.Create(5);
  try
    C.Incrementa;
    C.Incrementa;
    WriteLn(C.Descrizione);
    C.Passo := 10;
    C.Incrementa;
    WriteLn('Valore: ', C.Valore);
    C.Azzera;
    WriteLn(C.Descrizione);
  finally
    C.Free;
  end;
end.
