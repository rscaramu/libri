program IsAs;

{$APPTYPE CONSOLE}

type
  TAnimale = class
  end;

  TCane = class(TAnimale)
    procedure Abbaia;
  end;

  TGatto = class(TAnimale)
  end;

procedure TCane.Abbaia;
begin
  WriteLn('bau');
end;

var
  Animali: array[0..2] of TAnimale;
  A: TAnimale;
begin
  Animali[0] := TCane.Create;
  Animali[1] := TGatto.Create;
  Animali[2] := TCane.Create;
  try
    for A in Animali do
    begin
      WriteLn(A.ClassName, ' ', A is TCane, ' ',
        A is TAnimale);
      if A is TCane then
        (A as TCane).Abbaia;
    end;
    WriteLn(TCane(Animali[1]) = nil);
  finally
    for A in Animali do
      A.Free;
  end;
end.
