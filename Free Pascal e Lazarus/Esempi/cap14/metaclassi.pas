{ Metaclassi - Manuale completo di Free Pascal e Lazarus }
program Metaclassi;
{$mode objfpc}{$H+}
type
  TAnimale = class
  public
    class function Verso: String; virtual;
    constructor Create; virtual;
  end;
  TAnimaleClass = class of TAnimale;

  TCane = class(TAnimale)
    class function Verso: String; override;
  end;

  TGatto = class(TAnimale)
    class function Verso: String; override;
  end;

class function TAnimale.Verso: String;
begin
  Result := '...';
end;

constructor TAnimale.Create;
begin
  WriteLn('Creato un ', ClassName, ' che fa ', Verso);
end;

class function TCane.Verso: String;
begin
  Result := 'bau';
end;

class function TGatto.Verso: String;
begin
  Result := 'miao';
end;

procedure Fabbrica(Classe: TAnimaleClass);
var
  A: TAnimale;
begin
  A := Classe.Create;
  A.Free;
end;

var
  C: TAnimaleClass;
begin
  Fabbrica(TCane);
  Fabbrica(TGatto);
  C := TAnimale;
  WriteLn(C.ClassName, ': ', C.Verso);
end.
