{ PropStringhe - Manuale completo di Free Pascal e Lazarus }
program PropStringhe;
{$mode objfpc}{$H+}
uses
  Classes, TypInfo;
type
  TConfig = class(TPersistent)
  private
    FHost, FUtente: String;
    FPorta: Integer;
    FSsl: Boolean;
  published
    property Host: String read FHost write FHost;
    property Porta: Integer read FPorta write FPorta;
    property Utente: String read FUtente write FUtente;
    property Ssl: Boolean read FSsl write FSsl;
  end;

function PropStringa(Obj: TPersistent): String;
var
  Lista: PPropList;
  N, I: Integer;
begin
  Result := '';
  N := GetPropList(Obj, Lista);
  try
    for I := 0 to N - 1 do
      if Lista^[I]^.PropType^.Kind in
         [tkAString, tkString] then
        Result := Result + Lista^[I]^.Name + ' ';
  finally
    FreeMem(Lista);
  end;
end;

var
  C: TConfig;
begin
  C := TConfig.Create;
  try
    WriteLn(PropStringa(C));
  finally
    C.Free;
  end;
end.
