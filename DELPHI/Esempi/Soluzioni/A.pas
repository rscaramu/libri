unit A;

interface

uses
  B;

procedure StampaA(N: Integer);

implementation

procedure StampaA(N: Integer);
begin
  WriteLn('A ', N);
  if N > 0 then
    StampaB(N - 1);
end;

end.
