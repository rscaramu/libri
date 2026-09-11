program GiorniMese;

{$APPTYPE CONSOLE}

type
  TMese = (Gen, Feb, Mar, Apr, Mag, Giu, Lug, Ago, Sett, Ott,
    Nov, Dic);

function GiorniDelMese(M: TMese; Bisestile: Boolean): Integer;
begin
  case M of
    Apr, Giu, Sett, Nov: Result := 30;
    Feb: if Bisestile then Result := 29 else Result := 28;
  else
    Result := 31;
  end;
end;

begin
  WriteLn(GiorniDelMese(Feb, False), ' ',
    GiorniDelMese(Feb, True), ' ',
    GiorniDelMese(Apr, False), ' ',
    GiorniDelMese(Dic, True));
end.
