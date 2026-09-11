{ Processi - Manuale completo di Free Pascal e Lazarus }
program Processi;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, Process;
var
  P: TProcess;
  Righe: TStringList;
  Output: String;
begin
  { forma breve }
  if RunCommand('fpc', ['-iV'], Output) then
    WriteLn('Compilatore: ', Trim(Output));

  { forma completa, con lettura dell'output }
  P := TProcess.Create(nil);
  Righe := TStringList.Create;
  try
    ForceDirectories('dir_prova');
    FileClose(FileCreate('dir_prova/a.txt'));
    FileClose(FileCreate('dir_prova/b.txt'));
    FileClose(FileCreate('dir_prova/c.txt'));
    {$IFDEF WINDOWS}
    P.Executable := 'cmd';
    P.Parameters.Add('/c');
    P.Parameters.Add('dir');
    P.Parameters.Add('/b');
    {$ELSE}
    P.Executable := 'ls';
    P.Parameters.Add('-1');
    {$ENDIF}
    P.Parameters.Add('dir_prova');
    P.Options := [poWaitOnExit, poUsePipes];
    P.Execute;
    Righe.LoadFromStream(P.Output);
    WriteLn('Uscita: ', P.ExitStatus, ', ', Righe.Count,
            ' righe di output');
  finally
    Righe.Free;
    P.Free;
  end;
end.
