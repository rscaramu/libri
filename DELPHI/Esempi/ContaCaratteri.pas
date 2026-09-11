unit ContaCaratteri;

interface

type
  TConteggio = array['a'..'z'] of Integer;

procedure Conta(const Frase: string; out C: TConteggio);
procedure Stampa(const C: TConteggio);

implementation

procedure Conta(const Frase: string; out C: TConteggio);
var
  L: Char;
  I: Integer;
begin
  for L := 'a' to 'z' do
    C[L] := 0;
  for I := 1 to Length(Frase) do
  begin
    L := Frase[I];
    if (L >= 'a') and (L <= 'z') then
      Inc(C[L]);
  end;
end;

procedure Stampa(const C: TConteggio);
var
  L: Char;
begin
  for L := 'a' to 'z' do
    if C[L] > 0 then
      WriteLn(L, ': ', C[L]);
end;

end.
