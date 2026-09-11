{ Elenco - Manuale completo di Free Pascal e Lazarus }
program Elenco;
{$mode objfpc}{$H+}
uses
  SysUtils;
var
  SR: TSearchRec;
  Percorso: String;
  Dir: String;
begin
  Dir := 'prova_dir';
  ForceDirectories(Dir + '/sotto');
  Percorso := IncludeTrailingPathDelimiter(Dir);
  WriteLn('Estensione: ', ExtractFileExt('dati.tar.gz'));
  WriteLn('Nome: ', ExtractFileName(Percorso + 'a/b.txt'));
  WriteLn('Cambio: ', ChangeFileExt('rapporto.txt', '.pdf'));
  if FindFirst(Percorso + '*', faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Name <> '.') and (SR.Name <> '..') then
        if (SR.Attr and faDirectory) <> 0 then
          WriteLn('[DIR] ', SR.Name)
        else
          WriteLn('      ', SR.Name, ' (', SR.Size, ' byte)');
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
  RemoveDir(Dir + '/sotto');
  RemoveDir(Dir);
  WriteLn('Esiste ancora? ', DirectoryExists(Dir));
end.
