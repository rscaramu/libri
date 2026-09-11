program Caratteri;

{$APPTYPE CONSOLE}

uses
  SysUtils, Character;

var
  C: Char;
  Cifre, Lettere, Spazi: Integer;
begin
  Cifre := 0; Lettere := 0; Spazi := 0;
  for C in 'Via Roma 12, int. 3' do
    if TCharacter.IsDigit(C) then
      Inc(Cifre)
    else if TCharacter.IsLetter(C) then
      Inc(Lettere)
    else if TCharacter.IsWhiteSpace(C) then
      Inc(Spazi);
  WriteLn(Cifre, ' ', Lettere, ' ', Spazi);
  WriteLn(UpCase('q'), ' ', Ord('A'), ' ', Chr(97));
  WriteLn(TCharacter.ToUpper('z'), ' ',
    TCharacter.IsUpper('Z'));
end.
