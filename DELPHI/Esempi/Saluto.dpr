program Saluto;

{$APPTYPE CONSOLE}

uses
  SysUtils;

begin
  try
    WriteLn('Benvenuti in Delphi');
    WriteLn('Oggi e'' il ', DateToStr(Date));
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
end.
