program ProdCons;

{$APPTYPE CONSOLE}

uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  SysUtils, Classes, SyncObjs, Generics.Collections;

var
  Coda: TQueue<Integer>;
  Lucchetto: TCriticalSection;
  Disponibile: TEvent;
  Somma: Integer;
  Prod, Cons: TThread;

procedure Accoda(V: Integer);
begin
  Lucchetto.Enter;
  try
    Coda.Enqueue(V);
  finally
    Lucchetto.Leave;
  end;
  Disponibile.SetEvent;
end;

function Estrai: Integer;
begin
  repeat
    Lucchetto.Enter;
    try
      if Coda.Count > 0 then
        Exit(Coda.Dequeue);
      Disponibile.ResetEvent;
    finally
      Lucchetto.Leave;
    end;
    Disponibile.WaitFor(1000);
  until False;
end;

begin
  Coda := TQueue<Integer>.Create;
  Lucchetto := TCriticalSection.Create;
  Disponibile := TEvent.Create(nil, True, False, '');
  try
    Somma := 0;
    Prod := TThread.CreateAnonymousThread(
      procedure
      var
        I: Integer;
      begin
        for I := 1 to 10 do
        begin
          Accoda(I);
          Sleep(1);
        end;
        Accoda(-1);
      end);
    Cons := TThread.CreateAnonymousThread(
      procedure
      var
        V: Integer;
      begin
        repeat
          V := Estrai;
          if V > 0 then
            Somma := Somma + V;
        until V = -1;
      end);
    Prod.FreeOnTerminate := False;
    Cons.FreeOnTerminate := False;
    Prod.Start;
    Cons.Start;
    Prod.WaitFor;
    Cons.WaitFor;
    WriteLn(Somma);
    Prod.Free;
    Cons.Free;
  finally
    Disponibile.Free;
    Lucchetto.Free;
    Coda.Free;
  end;
end.
