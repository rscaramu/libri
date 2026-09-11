{ Eventi - Manuale completo di Free Pascal e Lazarus }
program Eventi;
{$mode objfpc}{$H+}
type
  TSogliaEvento = procedure(Sender: TObject; Valore: Integer)
                  of object;

  TSensore = class
  private
    FValore: Integer;
    FSoglia: Integer;
    FOnSoglia: TSogliaEvento;
  public
    constructor Create(ASoglia: Integer);
    procedure Leggi(V: Integer);
    property OnSoglia: TSogliaEvento read FOnSoglia
                                     write FOnSoglia;
  end;

  TAllarme = class
    procedure SogliaSuperata(Sender: TObject;
                             Valore: Integer);
  end;

constructor TSensore.Create(ASoglia: Integer);
begin
  FSoglia := ASoglia;
end;

procedure TSensore.Leggi(V: Integer);
begin
  FValore := V;
  if (V > FSoglia) and Assigned(FOnSoglia) then
    FOnSoglia(Self, V);
end;

procedure TAllarme.SogliaSuperata(Sender: TObject;
                                  Valore: Integer);
begin
  WriteLn('ALLARME: ', Valore, ' da ', Sender.ClassName);
end;

var
  S: TSensore;
  A: TAllarme;
begin
  S := TSensore.Create(50);
  A := TAllarme.Create;
  try
    S.Leggi(30);
    S.Leggi(70);
    S.OnSoglia := @A.SogliaSuperata;
    S.Leggi(30);
    S.Leggi(80);
  finally
    A.Free;
    S.Free;
  end;
end.
