program Ordine;

{$APPTYPE CONSOLE}

uses
  SysUtils;

procedure Interna;
begin
  try
    WriteLn('1');
    raise Exception.Create('x');
    WriteLn('2');
  finally
    WriteLn('3');
  end;
  WriteLn('4');
end;

begin
  try
    Interna;
    WriteLn('5');
  except
    WriteLn('6');
  end;
  WriteLn('7');
end.
