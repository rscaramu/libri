{ Varianti18 - Manuale completo di Free Pascal e Lazarus }
program Varianti18;
{$mode objfpc}{$H+}
uses
  SysUtils, Variants;

function Descrivi(const V: Variant): String;
begin
  if VarIsEmpty(V) then
    Result := 'non assegnato'
  else if VarIsNull(V) then
    Result := 'Null'
  else if VarIsBool(V) then
    Result := 'booleano ' + VarToStr(V)
  else if VarIsOrdinal(V) then
    Result := 'intero ' + VarToStr(V)
  else if VarIsFloat(V) then
    Result := 'reale ' + VarToStr(V)
  else if VarIsStr(V) then
    Result := 'stringa "' + VarToStr(V) + '"'
  else
    Result := 'tipo ' + IntToStr(VarType(V));
end;

var
  V: Variant;
begin
  WriteLn(Descrivi(V));
  V := 42;
  WriteLn(Descrivi(V));
  V := V + 0.5;
  WriteLn(Descrivi(V));
  V := 'testo';
  WriteLn(Descrivi(V));
  V := V + '!';              { concatena }
  WriteLn(Descrivi(V));
  V := Null;
  WriteLn(Descrivi(V), ', IsNull = ', VarIsNull(V));
  V := True;
  WriteLn(Descrivi(V));
end.
