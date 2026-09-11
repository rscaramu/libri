program Codifiche;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  B: TBytes;
  S: string;
  I: Integer;
begin
  B := TEncoding.UTF8.GetBytes('ab');
  WriteLn(Length(B));
  for I := 0 to High(B) do
    Write(B[I], ' ');
  WriteLn;
  B := TEncoding.Unicode.GetBytes('ab');
  WriteLn(Length(B));
  S := TEncoding.UTF8.GetString(B, 0, 1);
  WriteLn(S);
  B := TEncoding.UTF8.GetPreamble;
  WriteLn(Length(B));
end.
