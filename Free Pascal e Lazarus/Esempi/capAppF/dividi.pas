{ Dividi - Manuale completo di Free Pascal e Lazarus }
program Dividi;
{$mode objfpc}{$H+}
uses
  SysUtils;
const
  Blocco = 1024;
var
  F, P: file;
  Buf: array[0..Blocco - 1] of Byte;
  Letti, N, I: Integer;
begin
  AssignFile(F, 'grande.bin');
  Rewrite(F, 1);
  FillChar(Buf, SizeOf(Buf), 7);
  for I := 1 to 3 do
    BlockWrite(F, Buf, 900);           { 2700 byte }
  CloseFile(F);
  Reset(F, 1);
  N := 0;
  repeat
    BlockRead(F, Buf, Blocco, Letti);
    if Letti > 0 then
    begin
      Inc(N);
      AssignFile(P, Format('parte_%.3d.bin', [N]));
      Rewrite(P, 1);
      BlockWrite(P, Buf, Letti);
      CloseFile(P);
    end;
  until Letti < Blocco;
  CloseFile(F);
  WriteLn('Parti: ', N);
  AssignFile(F, 'riunito.bin');
  Rewrite(F, 1);
  for I := 1 to N do
  begin
    AssignFile(P, Format('parte_%.3d.bin', [I]));
    Reset(P, 1);
    BlockRead(P, Buf, Blocco, Letti);
    BlockWrite(F, Buf, Letti);
    CloseFile(P);
  end;
  CloseFile(F);
  Reset(F, 1);
  WriteLn('Riunito: ', FileSize(F), ' byte');
  CloseFile(F);
end.
