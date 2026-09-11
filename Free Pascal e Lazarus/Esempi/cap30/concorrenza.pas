{ Concorrenza - Manuale completo di Free Pascal e Lazarus }
program Concorrenza;
{$mode objfpc}{$H+}
uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  SysUtils, Classes, SyncObjs;
type
  TIncrementatore = class(TThread)
  private
    FProtetto: Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(AProtetto: Boolean);
  end;

var
  Contatore: Integer;
  Atomico: Integer;
  CS: TCriticalSection;

constructor TIncrementatore.Create(AProtetto: Boolean);
begin
  inherited Create(True);
  FProtetto := AProtetto;
  FreeOnTerminate := False;
end;

procedure TIncrementatore.Execute;
var
  I, V: Integer;
begin
  for I := 1 to 200000 do
  begin
    if FProtetto then
      CS.Enter;
    try
      V := Contatore;               { leggi }
      if I mod 1000 = 0 then
        ThreadSwitch;               { cede il processore }
      Contatore := V + 1;           { scrivi }
    finally
      if FProtetto then
        CS.Leave;
    end;
    InterlockedIncrement(Atomico);
  end;
end;

procedure Prova(Protetto: Boolean);
var
  T: array[0..3] of TIncrementatore;
  I: Integer;
begin
  Contatore := 0;
  Atomico := 0;
  for I := 0 to 3 do
    T[I] := TIncrementatore.Create(Protetto);
  for I := 0 to 3 do
    T[I].Start;
  for I := 0 to 3 do
  begin
    T[I].WaitFor;
    T[I].Free;
  end;
  WriteLn('Protetto=', Protetto, ': contatore corretto? ',
          Contatore = 800000, ', atomico ', Atomico);
end;

begin
  CS := TCriticalSection.Create;
  try
    Prova(False);
    Prova(True);
  finally
    CS.Free;
  end;
end.
