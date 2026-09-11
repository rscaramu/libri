{ ProvaApi - Manuale completo di Free Pascal e Lazarus }
program ProvaApi;
{$mode objfpc}{$H+}
uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  SysUtils, Classes, fpjson, ApiClient, ServerAttivita;
type
  TServerThread = class(TThread)
    Server: TServerAttivita;
    procedure Execute; override;
  end;

procedure TServerThread.Execute;
begin
  Server.Avvia;
end;

var
  T: TServerThread;
  C: TApiClient;
  J, Corpo: TJSONData;
  I: Integer;
begin
  T := TServerThread.Create(True);
  T.Server := TServerAttivita.Create(8097, 'segreto');
  T.Start;
  Sleep(300);
  C := TApiClient.Create('http://127.0.0.1:8097/');
  try
    try
      J := C.Get('/attivita');
    except
      on E: EApi do
        WriteLn('Senza token: ', E.Message);
    end;
    C.Token := 'segreto';
    for I := 1 to 3 do
    begin
      Corpo := TJSONObject.Create(['titolo', 'Compito ' +
                                             IntToStr(I)]);
      try
        J := C.Post('/attivita', Corpo);
        WriteLn('Creata: ', J.FindPath('id').AsInteger, ' ',
                J.FindPath('titolo').AsString);
        J.Free;
      finally
        Corpo.Free;
      end;
    end;
    J := C.Put('/attivita/2/completa', nil);
    WriteLn('Completata: ',
            J.FindPath('completata').AsBoolean);
    J.Free;
    C.Delete('/attivita/1');
    J := C.Get('/attivita');
    WriteLn('Rimaste: ', J.Count);
    J.Free;
    try
      C.Delete('/attivita/99');
    except
      on E: EApi do
        WriteLn('Codice ', E.Codice);
    end;
  finally
    C.Free;
    T.Server.Ferma;
    T.WaitFor;
    T.Server.Free;
    T.Free;
  end;
end.
