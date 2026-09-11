program Azzera;

{$APPTYPE CONSOLE}

uses
  SysUtils, TypInfo, Variants;

type
  {$M+}
  TConf = class
  private
    FNome: string;
    FPorta: Integer;
    FAttivo: Boolean;
  published
    property Nome: string read FNome write FNome;
    property Porta: Integer read FPorta write FPorta;
    property Attivo: Boolean read FAttivo write FAttivo;
  end;
  {$M-}

procedure Azzera(O: TObject);
var
  Lista: PPropList;
  N, I: Integer;
  Nome: string;
begin
  N := GetPropList(O, Lista);
  try
    for I := 0 to N - 1 do
    begin
      if Lista^[I]^.SetProc = nil then
        Continue;
      Nome := Lista^[I]^.Name;
      if VarIsStr(GetPropValue(O, Nome)) then
        SetPropValue(O, Nome, '')
      else
        SetPropValue(O, Nome, 0);
    end;
  finally
    FreeMem(Lista);
  end;
end;

var
  C: TConf;
begin
  C := TConf.Create;
  try
    C.Nome := 'x'; C.Porta := 80; C.Attivo := True;
    Azzera(C);
    WriteLn('[', C.Nome, '] ', C.Porta, ' ', C.Attivo);
  finally
    C.Free;
  end;
end.
