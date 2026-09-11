program LeggiIntero;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function LeggiA(const S: string; Default: Integer): Integer;
begin
  try
    Result := StrToInt(S);
  except
    on EConvertError do
      Result := Default;
  end;
end;

function LeggiB(const S: string; Default: Integer): Integer;
begin
  if not TryStrToInt(S, Result) then
    Result := Default;
end;

begin
  WriteLn(LeggiA('42', -1), ' ', LeggiA('x', -1));
  WriteLn(LeggiB('42', -1), ' ', LeggiB('x', -1));
end.
