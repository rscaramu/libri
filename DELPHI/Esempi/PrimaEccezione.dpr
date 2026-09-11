program PrimaEccezione;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function Dividi(A, B: Integer): Integer;
begin
  Result := A div B;
end;

begin
  try
    WriteLn(Dividi(10, 2));
    WriteLn(Dividi(10, 0));
    WriteLn('non stampato');
  except
    on E: EDivByZero do
      WriteLn('divisione per zero: ', E.Message);
  end;
  WriteLn('il programma continua');
end.
