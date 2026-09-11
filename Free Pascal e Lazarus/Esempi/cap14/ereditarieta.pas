{ Ereditarieta - Manuale completo di Free Pascal e Lazarus }
program Ereditarieta;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  TVeicolo = class
  private
    FTarga: String;
  public
    constructor Create(const ATarga: String);
    function Descrizione: String;
    property Targa: String read FTarga;
  end;

  TAuto = class(TVeicolo)
  private
    FPosti: Integer;
  public
    constructor Create(const ATarga: String; APosti: Integer);
    property Posti: Integer read FPosti;
  end;

  TCamion = class(TVeicolo)
  private
    FPortata: Double;
  public
    constructor Create(const ATarga: String;
                       APortata: Double);
    property Portata: Double read FPortata;
  end;

constructor TVeicolo.Create(const ATarga: String);
begin
  inherited Create;
  FTarga := ATarga;
end;

function TVeicolo.Descrizione: String;
begin
  Result := ClassName + ' targato ' + FTarga;
end;

constructor TAuto.Create(const ATarga: String;
                         APosti: Integer);
begin
  inherited Create(ATarga);
  FPosti := APosti;
end;

constructor TCamion.Create(const ATarga: String;
                           APortata: Double);
begin
  inherited Create(ATarga);
  FPortata := APortata;
end;

var
  V: TVeicolo;
  A: TAuto;
begin
  A := TAuto.Create('AB123CD', 5);
  WriteLn(A.Descrizione, ', ', A.Posti, ' posti');
  V := A;                          { un'auto e' un veicolo }
  WriteLn(V.Descrizione);
  WriteLn('V e'' un''auto? ', V is TAuto);
  WriteLn('V e'' un camion? ', V is TCamion);
  WriteLn('TAuto discende da TVeicolo? ',
          TAuto.InheritsFrom(TVeicolo));
  A.Free;
end.
