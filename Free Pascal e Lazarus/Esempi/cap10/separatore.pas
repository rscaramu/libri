{ Separatore - Manuale completo di Free Pascal e Lazarus }
program Separatore;
{$mode objfpc}{$H+}

function SeparatoreRighe: String;
begin
  {$IFDEF WINDOWS}
  Result := #13#10;
  {$ELSE}
  Result := #10;
  {$ENDIF}
end;

begin
  WriteLn('Lunghezza: ', Length(SeparatoreRighe));
  WriteLn('LineEnding: ', Length(LineEnding));
  WriteLn('Uguali: ', SeparatoreRighe = LineEnding);
end.
