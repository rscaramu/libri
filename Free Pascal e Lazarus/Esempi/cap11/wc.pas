{ WC - Manuale completo di Free Pascal e Lazarus }
program WC;
{$mode objfpc}{$H+}
var
  F: TextFile;
  Riga: String;
  Righe, Parole, Caratteri, I: Integer;
  InParola: Boolean;
begin
  AssignFile(F, 'prova.txt');
  Rewrite(F);
  WriteLn(F, 'Il Pascal e un linguaggio');
  WriteLn(F, 'chiaro e rigoroso.');
  WriteLn(F, '');
  WriteLn(F, 'Fine.');
  CloseFile(F);

  Righe := 0;
  Parole := 0;
  Caratteri := 0;
  Reset(F);
  while not EOF(F) do
  begin
    ReadLn(F, Riga);
    Inc(Righe);
    Caratteri := Caratteri + Length(Riga);
    InParola := False;
    for I := 1 to Length(Riga) do
      if Riga[I] = ' ' then
        InParola := False
      else if not InParola then
      begin
        InParola := True;
        Inc(Parole);
      end;
  end;
  CloseFile(F);
  WriteLn(Righe, ' righe, ', Parole, ' parole, ',
          Caratteri, ' caratteri');
end.
