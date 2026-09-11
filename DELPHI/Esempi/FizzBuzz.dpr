program FizzBuzz;

{$APPTYPE CONSOLE}

var
  I: Integer;
begin
  for I := 1 to 15 do
  begin
    if I mod 15 = 0 then
      Write('FizzBuzz')
    else if I mod 3 = 0 then
      Write('Fizz')
    else if I mod 5 = 0 then
      Write('Buzz')
    else
      Write(I);
    Write(' ');
  end;
  WriteLn;
end.
