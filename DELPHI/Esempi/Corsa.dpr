program Corsa;

{$APPTYPE CONSOLE}

uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  SysUtils, Classes, SyncObjs;

var
  Senza, ConAtomico, ConSezione: Integer;
  Sezione: TCriticalSection;

type
  TIncrementatore = class(TThread)
  protected
    procedure Execute; override;
  end;

procedure TIncrementatore.Execute;
var
  I, V: Integer;
begin
  for I := 1 to 500000 do
  begin
    V := Senza;          // leggi
    if I mod 100 = 0 then
      TThread.Yield;     // cedi il processore
    Senza := V + 1;      // scrivi
  end;
  for I := 1 to 500000 do
    AtomicIncrement(ConAtomico);
  for I := 1 to 500000 do
  begin
    Sezione.Enter;
    try
      ConSezione := ConSezione + 1;
    finally
      Sezione.Leave;
    end;
  end;
end;

var
  T: array[0..3] of TIncrementatore;
  I: Integer;
begin
  Sezione := TCriticalSection.Create;
  try
    for I := 0 to 3 do
      T[I] := TIncrementatore.Create(True);
    for I := 0 to 3 do
      T[I].Start;
    for I := 0 to 3 do
    begin
      T[I].WaitFor;
      T[I].Free;
    end;
    WriteLn('senza protezione: ', Senza < 2000000);
    WriteLn('atomico: ', ConAtomico);
    WriteLn('sezione critica: ', ConSezione);
  finally
    Sezione.Free;
  end;
end.
