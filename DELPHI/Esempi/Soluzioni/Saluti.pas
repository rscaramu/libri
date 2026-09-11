unit Saluti;

interface

procedure Saluta(const Nome: string);

implementation

procedure Saluta(const Nome: string);
begin
  WriteLn('Ciao, ', Nome, '!');
end;

end.
