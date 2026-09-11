program Prevedi;

{$APPTYPE CONSOLE}

type
  TA = class
    procedure Statico;
    procedure Virtuale; virtual;
  end;
  TB = class(TA)
    procedure Statico;
    procedure Virtuale; override;
  end;

procedure TA.Statico;
begin
  WriteLn('A.Statico');
end;

procedure TA.Virtuale;
begin
  WriteLn('A.Virtuale');
end;

procedure TB.Statico;
begin
  WriteLn('B.Statico');
end;

procedure TB.Virtuale;
begin
  WriteLn('B.Virtuale');
end;

var
  A: TA;
  B: TB;
begin
  B := TB.Create;
  try
    A := B;
    A.Statico;
    A.Virtuale;
    B.Statico;
    B.Virtuale;
  finally
    B.Free;
  end;
end.
