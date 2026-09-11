{ ProduttoreConsumatore - Manuale completo di Free Pascal e Lazarus }
program ProduttoreConsumatore;
{$mode objfpc}{$H+}
uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  SysUtils, Classes, SyncObjs;
type
  TMessaggio = class
    Testo: String;
  end;

  TProduttore = class(TThread)
  protected
    procedure Execute; override;
  end;

  TConsumatore = class(TThread)
  private
    FRicevuti: Integer;
  protected
    procedure Execute; override;
  public
    property Ricevuti: Integer read FRicevuti;
  end;

var
  Coda: TThreadList;
  Segnale: TEvent;
  Finito: Boolean = False;

procedure TProduttore.Execute;
var
  I: Integer;
  M: TMessaggio;
begin
  for I := 1 to 10 do
  begin
    M := TMessaggio.Create;
    M.Testo := 'messaggio ' + IntToStr(I);
    Coda.Add(M);
    Segnale.SetEvent;
    Sleep(10);
  end;
  Finito := True;
  Segnale.SetEvent;
end;

procedure TConsumatore.Execute;
var
  L: TList;
  M: TMessaggio;
begin
  repeat
    Segnale.WaitFor(1000);
    repeat
      M := nil;
      L := Coda.LockList;
      try
        if L.Count > 0 then
        begin
          M := TMessaggio(L[0]);
          L.Delete(0);
        end;
      finally
        Coda.UnlockList;
      end;
      if M <> nil then
      begin
        Inc(FRicevuti);
        M.Free;
      end;
    until M = nil;
  until Finito;
end;

var
  P: TProduttore;
  C: TConsumatore;
begin
  Coda := TThreadList.Create;
  Segnale := TEvent.Create(nil, False, False, '');
  try
    C := TConsumatore.Create(False);
    P := TProduttore.Create(False);
    P.WaitFor;
    C.WaitFor;
    WriteLn('Ricevuti: ', C.Ricevuti);
    P.Free;
    C.Free;
  finally
    Segnale.Free;
    Coda.Free;
  end;
end.
