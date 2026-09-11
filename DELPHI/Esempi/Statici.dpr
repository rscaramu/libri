program Statici;

{$APPTYPE CONSOLE}

type
  TVoti = array[1..5] of Integer;

var
  Voti: TVoti;
  I, Somma: Integer;
  Iniziali: array['A'..'E'] of Integer;
  C: Char;
begin
  for I := Low(Voti) to High(Voti) do
    Voti[I] := I * 2;
  Somma := 0;
  for I in Voti do
    Somma := Somma + I;
  WriteLn(Somma, ' ', Length(Voti), ' ', SizeOf(Voti));
  for C := 'A' to 'E' do
    Iniziali[C] := Ord(C);
  WriteLn(Iniziali['C']);
end.
