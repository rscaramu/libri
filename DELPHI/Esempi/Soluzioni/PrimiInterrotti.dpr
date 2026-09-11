program PrimiInterrotti;

{$APPTYPE CONSOLE}

uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  SysUtils, Classes;

type
  TContaPrimi = class(TThread)
  public
    Trovati, Ultimo: Integer;
  protected
    procedure Execute; override;
  end;

function EPrimo(N: Integer): Boolean;
var
  D: Integer;
begin
  if N < 2 then
    Exit(False);
  D := 2;
  while D * D <= N do
  begin
    if N mod D = 0 then
      Exit(False);
    Inc(D);
  end;
  Result := True;
end;

procedure TContaPrimi.Execute;
var
  N: Integer;
begin
  N := 2;
  while not Terminated do
  begin
    if EPrimo(N) then
      Inc(Trovati);
    Ultimo := N;
    Inc(N);
  end;
end;

var
  T: TContaPrimi;
begin
  T := TContaPrimi.Create(False);
  try
    Sleep(100);
    T.Terminate;
    T.WaitFor;
    WriteLn(T.Trovati > 100, ' ', T.Ultimo > 1000);
  finally
    T.Free;
  end;
end.
