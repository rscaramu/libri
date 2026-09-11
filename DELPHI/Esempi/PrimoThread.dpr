program PrimoThread;

{$APPTYPE CONSOLE}

uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  SysUtils, Classes;

type
  TSommatore = class(TThread)
  private
    FDa, FA: Int64;
    FRisultato: Int64;
  protected
    procedure Execute; override;
  public
    constructor Create(ADa, AA: Int64);
    property Risultato: Int64 read FRisultato;
  end;

constructor TSommatore.Create(ADa, AA: Int64);
begin
  inherited Create(True);
  FDa := ADa;
  FA := AA;
  FreeOnTerminate := False;
end;

procedure TSommatore.Execute;
var
  I: Int64;
begin
  FRisultato := 0;
  for I := FDa to FA do
    FRisultato := FRisultato + I;
end;

var
  T1, T2: TSommatore;
begin
  T1 := TSommatore.Create(1, 5000000);
  T2 := TSommatore.Create(5000001, 10000000);
  try
    T1.Start;
    T2.Start;
    T1.WaitFor;
    T2.WaitFor;
    WriteLn(T1.Risultato + T2.Risultato);
  finally
    T1.Free;
    T2.Free;
  end;
end.
