program Comunicazione;

{$APPTYPE CONSOLE}

uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  SysUtils, Classes;

var
  Messaggi: TStringList;
  Finito: Boolean;

type
  TLavoratore = class(TThread)
  private
    procedure Notifica(Passo: Integer);
  protected
    procedure Execute; override;
  end;

procedure TLavoratore.Notifica(Passo: Integer);
begin
  TThread.Queue(nil,
    procedure
    begin
      Messaggi.Add('passo ' + IntToStr(Passo));
    end);
end;

procedure TLavoratore.Execute;
var
  I: Integer;
begin
  for I := 1 to 3 do
  begin
    Sleep(10);
    Notifica(I);
  end;
  TThread.Synchronize(nil,
    procedure
    begin
      Messaggi.Add('fine');
      Finito := True;
    end);
end;

var
  T: TLavoratore;
begin
  Messaggi := TStringList.Create;
  try
    Finito := False;
    T := TLavoratore.Create(False);
    try
      while not Finito do
        CheckSynchronize(10);
      T.WaitFor;
    finally
      T.Free;
    end;
    Write(Messaggi.Text);
  finally
    Messaggi.Free;
  end;
end.
