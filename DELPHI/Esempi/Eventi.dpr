program Eventi;

{$APPTYPE CONSOLE}

uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  SysUtils, Classes, SyncObjs;

var
  Pronto: TEvent;
  Dato: string;
  T: TThread;
begin
  Pronto := TEvent.Create(nil, True, False, '');
  try
    T := TThread.CreateAnonymousThread(
      procedure
      begin
        Sleep(30);
        Dato := 'calcolato';
        Pronto.SetEvent;
      end);
    T.FreeOnTerminate := False;
    T.Start;
    WriteLn('aspetto...');
    case Pronto.WaitFor(5000) of
      wrSignaled: WriteLn('ricevuto: ', Dato);
      wrTimeout: WriteLn('timeout');
    end;
    T.WaitFor;
    T.Free;
  finally
    Pronto.Free;
  end;
end.
