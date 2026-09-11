{ Tracciamento - Manuale completo di Free Pascal e Lazarus }
unit Tracciamento;
{$mode objfpc}{$H+}

interface

procedure Traccia(const Msg: String);

implementation

var
  Righe: Integer;

procedure Traccia(const Msg: String);
begin
  Inc(Righe);
  WriteLn('[', Righe, '] ', Msg);
end;

initialization
  Righe := 0;
  WriteLn('Tracciamento avviato');

finalization
  WriteLn('Tracciamento chiuso dopo ', Righe, ' righe');
  Flush(Output);

end.
