program ContatoreSicuro;

{$APPTYPE CONSOLE}

uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  SysUtils, Classes, SyncObjs;

type
  TContatoreSicuro = class
  private
    FValore: Integer;
    FLock: TCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Incrementa;
    procedure Decrementa;
    function Valore: Integer;
  end;

constructor TContatoreSicuro.Create;
begin
  inherited;
  FLock := TCriticalSection.Create;
end;

destructor TContatoreSicuro.Destroy;
begin
  FLock.Free;
  inherited;
end;

procedure TContatoreSicuro.Incrementa;
begin
  FLock.Enter;
  try
    Inc(FValore);
  finally
    FLock.Leave;
  end;
end;

procedure TContatoreSicuro.Decrementa;
begin
  FLock.Enter;
  try
    Dec(FValore);
  finally
    FLock.Leave;
  end;
end;

function TContatoreSicuro.Valore: Integer;
begin
  FLock.Enter;
  try
    Result := FValore;
  finally
    FLock.Leave;
  end;
end;

var
  C: TContatoreSicuro;
  T: array[0..7] of TThread;
  I: Integer;
begin
  C := TContatoreSicuro.Create;
  try
    for I := 0 to 7 do
    begin
      T[I] := TThread.CreateAnonymousThread(
        procedure
        var
          K: Integer;
        begin
          for K := 1 to 10000 do
            C.Incrementa;
          for K := 1 to 5000 do
            C.Decrementa;
        end);
      T[I].FreeOnTerminate := False;
    end;
    for I := 0 to 7 do
      T[I].Start;
    for I := 0 to 7 do
    begin
      T[I].WaitFor;
      T[I].Free;
    end;
    WriteLn(C.Valore);
  finally
    C.Free;
  end;
end.
