{ Portabile - Manuale completo di Free Pascal e Lazarus }
program Portabile;
{$mode objfpc}{$H+}
uses
  SysUtils;
begin
  WriteLn('Sistema: ', {$I %FPCTARGETOS%}, ' su ',
          {$I %FPCTARGETCPU%});
  WriteLn('Separatore: ', DirectorySeparator,
          '  Maschera: ', AllFilesMask);
  WriteLn('Fine riga: ', Length(LineEnding), ' byte');
  WriteLn('Configurazione sotto l''utente? ',
          Pos(GetUserDir, GetAppConfigDir(False)) = 1);
  WriteLn('Temporanea: ', GetTempDir);
  {$IFDEF WINDOWS}
  WriteLn('Compilato per Windows');
  {$ENDIF}
  {$IFDEF DARWIN}
  WriteLn('Compilato per macOS');
  {$ENDIF}
  {$IFDEF LINUX}
  WriteLn('Compilato per Linux');
  {$ENDIF}
end.
