{ Helpers - Manuale completo di Free Pascal e Lazarus }
program Helpers;
{$mode objfpc}{$H+}
{$modeswitch typehelpers}
uses
  SysUtils, Classes;
type
  TIntHelper = type helper for Integer
    function EPari: Boolean;
    function Quadrato: Integer;
  end;

  TStringsHelper = class helper for TStrings
    function Unisci(const Sep: String): String;
  end;

function TIntHelper.EPari: Boolean;
begin
  Result := Self mod 2 = 0;
end;

function TIntHelper.Quadrato: Integer;
begin
  Result := Self * Self;
end;

function TStringsHelper.Unisci(const Sep: String): String;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Count - 1 do
  begin
    if I > 0 then
      Result := Result + Sep;
    Result := Result + Strings[I];
  end;
end;

var
  N: Integer;
  S: String;
  L: TStringList;
begin
  N := 7;
  WriteLn(N.EPari, ' ', N.Quadrato, ' ', Integer(12).EPari);
  S := '  Free Pascal  ';
  WriteLn('[', S.Trim, '] ', S.Trim.ToUpper, ' ',
          S.Contains('Pascal'), ' ', S.Trim.IndexOf('P'));
  L := TStringList.Create;
  try
    L.Add('a');
    L.Add('b');
    L.Add('c');
    WriteLn(L.Unisci(' - '));
  finally
    L.Free;
  end;
end.
