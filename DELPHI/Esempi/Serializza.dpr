program Serializza;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, TypInfo, Variants;

type
  {$M+}
  TConfig = class
  private
    FNome: string;
    FTimeout: Integer;
    FLivello: Integer;
  published
    property Nome: string read FNome write FNome;
    property Timeout: Integer read FTimeout write FTimeout;
    property Livello: Integer read FLivello write FLivello;
  end;
  {$M-}

function Salva(O: TObject): string;
var
  Lista: PPropList;
  N, I: Integer;
begin
  Result := '';
  N := GetPropList(O, Lista);
  try
    for I := 0 to N - 1 do
      Result := Result + Lista^[I]^.Name + '=' +
        string(GetPropValue(O, Lista^[I]^.Name)) + ';';
  finally
    FreeMem(Lista);
  end;
end;

procedure Carica(O: TObject; const Testo: string);
var
  Coppia: string;
  P: Integer;
begin
  for Coppia in Testo.Split([';'],
      TStringSplitOptions.ExcludeEmpty) do
  begin
    P := Pos('=', Coppia);
    if (P > 0) and
       IsPublishedProp(O, Copy(Coppia, 1, P - 1)) then
      SetPropValue(O, Copy(Coppia, 1, P - 1),
        Copy(Coppia, P + 1, MaxInt));
  end;
end;

var
  A, B: TConfig;
  S: string;
begin
  A := TConfig.Create;
  B := TConfig.Create;
  try
    A.Nome := 'prod';
    A.Timeout := 30;
    A.Livello := 2;
    S := Salva(A);
    WriteLn(S);
    Carica(B, S);
    WriteLn(B.Nome, ' ', B.Timeout, ' ', B.Livello);
    Carica(B, 'Timeout=99;Inesistente=1');
    WriteLn(B.Timeout);
  finally
    A.Free;
    B.Free;
  end;
end.
