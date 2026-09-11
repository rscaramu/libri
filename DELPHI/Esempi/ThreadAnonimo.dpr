program ThreadAnonimo;

{$APPTYPE CONSOLE}

uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  SysUtils, Classes;

var
  T: TThread;
  Risultato: Integer;
begin
  Risultato := 0;
  T := TThread.CreateAnonymousThread(
    procedure
    var
      I: Integer;
    begin
      for I := 1 to 1000 do
        Inc(Risultato);
    end);
  T.FreeOnTerminate := False;
  T.Start;
  T.WaitFor;
  WriteLn(Risultato);
  T.Free;
end.
