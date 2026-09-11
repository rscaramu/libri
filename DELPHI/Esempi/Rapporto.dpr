program Rapporto;

{$APPTYPE CONSOLE}

uses
  SysUtils;

procedure Riga(const Nome: string; Q: Integer; P: Double);
begin
  WriteLn(Format('%-12s%5d%9.2f', [Nome, Q, P]));
end;

begin
  Riga('Viti', 120, 0.05);
  Riga('Bulloni M8', 40, 0.32);
  Riga('Dadi', 1000, 0.02);
end.
