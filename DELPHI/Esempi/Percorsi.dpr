program Percorsi;

{$APPTYPE CONSOLE}

uses
  SysUtils;

const
  P = 'dati/2026/report.finale.txt';
begin
  WriteLn(ExtractFileName(P));
  WriteLn(ExtractFileExt(P));
  WriteLn(ExtractFilePath(P));
  WriteLn(ChangeFileExt(P, '.csv'));
  WriteLn(ExtractFileDir(P));
  WriteLn(IncludeTrailingPathDelimiter('cartella') + 'x');
  WriteLn(FileExists('inesistente.txt'), ' ',
    DirectoryExists('.'));
end.
