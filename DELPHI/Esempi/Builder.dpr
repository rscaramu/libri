program Builder;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  SB: TStringBuilder;
  I: Integer;
begin
  SB := TStringBuilder.Create;
  try
    for I := 1 to 5 do
      SB.Append(I).Append(';');
    SB.AppendLine;
    SB.Append('fine');
    WriteLn(SB.ToString);
    WriteLn(SB.Length);
  finally
    SB.Free;
  end;
end.
