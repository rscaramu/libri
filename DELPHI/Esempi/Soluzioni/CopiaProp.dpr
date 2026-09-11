program CopiaProp;

{$APPTYPE CONSOLE}

uses
  SysUtils, TypInfo, Variants;

type
  {$M+}
  TA = class
  private
    FNome: string;
    FEta: Integer;
  published
    property Nome: string read FNome write FNome;
    property Eta: Integer read FEta write FEta;
  end;
  TB = class
  private
    FNome: string;
    FCitta: string;
  published
    property Nome: string read FNome write FNome;
    property Citta: string read FCitta write FCitta;
  end;
  {$M-}

procedure Copia(Da, A: TObject);
var
  Lista: PPropList;
  N, I: Integer;
  Nome: string;
begin
  N := GetPropList(Da, Lista);
  try
    for I := 0 to N - 1 do
    begin
      Nome := Lista^[I]^.Name;
      if IsPublishedProp(A, Nome) then
        SetPropValue(A, Nome, GetPropValue(Da, Nome));
    end;
  finally
    FreeMem(Lista);
  end;
end;

var
  X: TA;
  Y: TB;
begin
  X := TA.Create;
  Y := TB.Create;
  try
    X.Nome := 'Anna'; X.Eta := 30;
    Y.Citta := 'Roma';
    Copia(X, Y);
    WriteLn(Y.Nome, ' ', Y.Citta);
  finally
    X.Free;
    Y.Free;
  end;
end.
