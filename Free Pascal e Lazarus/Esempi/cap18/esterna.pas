{ Esterna - Manuale completo di Free Pascal e Lazarus }
program Esterna;
{$mode objfpc}{$H+}
uses
  ctypes;

function strlen(S: PChar): csize_t; cdecl;
  external 'c' name 'strlen';
function abs(X: cint): cint; cdecl; external 'c';

begin
  WriteLn('strlen: ', strlen('Free Pascal'));
  WriteLn('abs: ', abs(-42));
end.
