unit B;

interface

procedure StampaB(N: Integer);

implementation

uses
  A;

procedure StampaB(N: Integer);
begin
  WriteLn('B ', N);
  if N > 0 then
    StampaA(N - 1);
end;

end.
