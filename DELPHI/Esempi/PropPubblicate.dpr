program PropPubblicate;

{$APPTYPE CONSOLE}

uses
  SysUtils, TypInfo, Variants;

type
  {$M+}
  TImpostazioni = class
  private
    FServer: string;
    FPorta: Integer;
    FTimeout: Integer;
  published
    property Server: string read FServer write FServer;
    property Porta: Integer read FPorta write FPorta;
    property Timeout: Integer read FTimeout write FTimeout;
  end;
  {$M-}

procedure Stampa(O: TObject);
var
  Lista: PPropList;
  N, I: Integer;
begin
  N := GetPropList(O, Lista);
  try
    for I := 0 to N - 1 do
      WriteLn(Lista^[I]^.Name, ' = ',
        string(GetPropValue(O, Lista^[I]^.Name)));
  finally
    FreeMem(Lista);
  end;
end;

var
  C: TImpostazioni;
begin
  C := TImpostazioni.Create;
  try
    C.Server := 'db.local';
    C.Porta := 5432;
    Stampa(C);
    SetPropValue(C, 'Porta', 5433);
    SetPropValue(C, 'Timeout', '15');
    WriteLn(C.Porta, ' ', C.Timeout);
    WriteLn(IsPublishedProp(C, 'Server'), ' ',
      IsPublishedProp(C, 'Password'));
    WriteLn(PropType(C, 'Porta') = tkInteger);
  finally
    C.Free;
  end;
end.
