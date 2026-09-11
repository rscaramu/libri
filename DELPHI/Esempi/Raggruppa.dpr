program Raggruppa;

{$APPTYPE CONSOLE}

uses
  SysUtils, Generics.Collections;

var
  Gruppi: TObjectDictionary<string, TList<string>>;
  Lista, Citta: TList<string>;
  C: string;
  Coppie: array[0..4, 0..1] of string;
  I: Integer;
begin
  Coppie[0, 0] := 'Anna';  Coppie[0, 1] := 'Roma';
  Coppie[1, 0] := 'Luca';  Coppie[1, 1] := 'Bari';
  Coppie[2, 0] := 'Sara';  Coppie[2, 1] := 'Roma';
  Coppie[3, 0] := 'Marco'; Coppie[3, 1] := 'Bari';
  Coppie[4, 0] := 'Elena'; Coppie[4, 1] := 'Roma';
  Gruppi := TObjectDictionary<string, TList<string>>.Create(
    [doOwnsValues]);
  try
    for I := 0 to 4 do
    begin
      if not Gruppi.TryGetValue(Coppie[I, 1], Lista) then
      begin
        Lista := TList<string>.Create;
        Gruppi.Add(Coppie[I, 1], Lista);
      end;
      Lista.Add(Coppie[I, 0]);
    end;
    Citta := TList<string>.Create(Gruppi.Keys);
    try
      Citta.Sort;
      for C in Citta do
        WriteLn(C, ': ',
          string.Join(', ', Gruppi[C].ToArray));
    finally
      Citta.Free;
    end;
  finally
    Gruppi.Free;
  end;
end.
