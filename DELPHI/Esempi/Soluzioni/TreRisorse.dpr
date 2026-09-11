program TreRisorse;

{$APPTYPE CONSOLE}

uses
  SysUtils;

procedure Lavora;
var
  A, B, C: TStringBuilder;
begin
  A := TStringBuilder.Create;
  try
    B := TStringBuilder.Create;
    try
      raise Exception.Create('guasto');
      C := TStringBuilder.Create;
      try
        WriteLn('mai');
      finally
        C.Free;
        WriteLn('libero C');
      end;
    finally
      B.Free;
      WriteLn('libero B');
    end;
  finally
    A.Free;
    WriteLn('libero A');
  end;
end;

begin
  try
    Lavora;
  except
    on E: Exception do
      WriteLn('gestito: ', E.Message);
  end;
end.
