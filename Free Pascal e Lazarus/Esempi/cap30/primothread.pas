{ PrimoThread - Manuale completo di Free Pascal e Lazarus }
program PrimoThread;
{$mode objfpc}{$H+}
uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  SysUtils, Classes;
type
  TCalcolo = class(TThread)
  private
    FDa, FA: Integer;
    FRisultato: Int64;
  protected
    procedure Execute; override;
  public
    constructor Create(ADa, AA: Integer);
    property Risultato: Int64 read FRisultato;
  end;

constructor TCalcolo.Create(ADa, AA: Integer);
begin
  inherited Create(True);      { sospeso }
  FDa := ADa;
  FA := AA;
  FreeOnTerminate := False;
end;

procedure TCalcolo.Execute;
var
  I: Integer;
begin
  FRisultato := 0;
  for I := FDa to FA do
  begin
    if Terminated then
      Exit;
    FRisultato := FRisultato + I;
  end;
end;

var
  T1, T2: TCalcolo;
begin
  T1 := TCalcolo.Create(1, 5000000);
  T2 := TCalcolo.Create(5000001, 10000000);
  T1.Start;
  T2.Start;
  WriteLn('I thread lavorano...');
  T1.WaitFor;
  T2.WaitFor;
  WriteLn('Somma: ', T1.Risultato + T2.Risultato);
  T1.Free;
  T2.Free;
end.
