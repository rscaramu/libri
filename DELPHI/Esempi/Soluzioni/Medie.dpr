program Medie;

{$APPTYPE CONSOLE}

function Media(A, B, C: Double): Double; overload;
begin
  Result := (A + B + C) / 3;
end;

function Media(A, B, C, D: Double): Double; overload;
begin
  Result := (A + B + C + D) / 4;
end;

procedure StampaMedia(A, B, C: Double);
begin
  WriteLn('media: ', Media(A, B, C):0:2);
end;

begin
  StampaMedia(1, 2, 3);
  WriteLn(Media(1, 2, 3, 4):0:2);
end.
