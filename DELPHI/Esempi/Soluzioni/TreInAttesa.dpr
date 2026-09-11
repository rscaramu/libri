program TreInAttesa;

{$APPTYPE CONSOLE}

uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  SysUtils, Classes, SyncObjs;

var
  Via: TEvent;
  Sbloccati: Integer;
  T: array[0..2] of TThread;
  I: Integer;
begin
  Via := TEvent.Create(nil, True, False, '');
  try
    Sbloccati := 0;
    for I := 0 to 2 do
    begin
      T[I] := TThread.CreateAnonymousThread(
        procedure
        begin
          if Via.WaitFor(5000) = wrSignaled then
            AtomicIncrement(Sbloccati);
        end);
      T[I].FreeOnTerminate := False;
      T[I].Start;
    end;
    Sleep(50);
    WriteLn('prima: ', Sbloccati);
    Via.SetEvent;
    for I := 0 to 2 do
    begin
      T[I].WaitFor;
      T[I].Free;
    end;
    WriteLn('dopo: ', Sbloccati);
  finally
    Via.Free;
  end;
end.
