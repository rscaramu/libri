program Perdita;

{$APPTYPE CONSOLE}

uses
  Classes;

var
  L: TStringList;
begin
  L := TStringList.Create;
  L.Add('mai liberata');
  WriteLn(L.Count);
end.
