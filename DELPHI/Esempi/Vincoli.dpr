program Vincoli;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  IDescrivibile = interface
    ['{7C1E4A9B-3D2F-4E5A-8B6C-9D0E1F2A3B4C}']
    function Descrizione: string;
  end;

  TProdotto = class(TInterfacedObject, IDescrivibile)
  private
    FNome: string;
  public
    constructor Create(const ANome: string);
    function Descrizione: string;
  end;

  TStampante<T: IDescrivibile> = class
    class procedure Stampa(const Elementi: array of T);
  end;

  TFabbrica<T: class, constructor> = class
    class function Nuovo: T;
  end;

constructor TProdotto.Create(const ANome: string);
begin
  inherited Create;
  FNome := ANome;
end;

function TProdotto.Descrizione: string;
begin
  Result := 'prodotto ' + FNome;
end;

class procedure TStampante<T>.Stampa(
  const Elementi: array of T);
var
  E: T;
begin
  for E in Elementi do
    WriteLn(E.Descrizione);
end;

class function TFabbrica<T>.Nuovo: T;
begin
  Result := T.Create;
end;

var
  A, B: IDescrivibile;
  O: TObject;
begin
  A := TProdotto.Create('vite');
  B := TProdotto.Create('dado');
  TStampante<IDescrivibile>.Stampa([A, B]);
  O := TFabbrica<TObject>.Nuovo;
  WriteLn(O.ClassName);
  O.Free;
end.
