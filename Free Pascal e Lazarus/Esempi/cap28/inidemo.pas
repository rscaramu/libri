{ IniDemo - Manuale completo di Free Pascal e Lazarus }
program IniDemo;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, IniFiles;
var
  Ini: TMemIniFile;
  Sezioni, Chiavi: TStringList;
  S, K: String;
begin
  DeleteFile('server.ini');
  Ini := TMemIniFile.Create('server.ini');
  Sezioni := TStringList.Create;
  Chiavi := TStringList.Create;
  try
    Ini.WriteString('produzione', 'host', 'db.esempio.it');
    Ini.WriteInteger('produzione', 'porta', 5432);
    Ini.WriteBool('produzione', 'ssl', True);
    Ini.WriteString('test', 'host', 'localhost');
    Ini.WriteInteger('test', 'porta', 5433);
    Ini.UpdateFile;
    Ini.ReadSections(Sezioni);
    for S in Sezioni do
    begin
      WriteLn('[', S, ']');
      Ini.ReadSection(S, Chiavi);
      for K in Chiavi do
        WriteLn('  ', K, ' = ', Ini.ReadString(S, K, ''));
      WriteLn('  ssl? ', Ini.ReadBool(S, 'ssl', False));
    end;
  finally
    Chiavi.Free;
    Sezioni.Free;
    Ini.Free;
  end;
end.
