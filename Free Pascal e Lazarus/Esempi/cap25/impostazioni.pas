{ Impostazioni - Manuale completo di Free Pascal e Lazarus }
unit Impostazioni;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, IniFiles;

type
  TImpostazioni = class
  private
    FLingua: String;
    FTema: String;
    FUltimoFile: String;
    function Percorso: String;
  public
    constructor Create;
    procedure Carica;
    procedure Salva;
    procedure Cancella;
    property Lingua: String read FLingua write FLingua;
    property Tema: String read FTema write FTema;
    property UltimoFile: String read FUltimoFile
                                write FUltimoFile;
  end;

implementation

constructor TImpostazioni.Create;
begin
  FLingua := 'it';
  FTema := 'chiaro';
end;

function TImpostazioni.Percorso: String;
begin
  Result := GetAppConfigDir(False) + 'impostazioni.ini';
end;

procedure TImpostazioni.Carica;
var
  Ini: TIniFile;
begin
  if not FileExists(Percorso) then
    Exit;
  Ini := TIniFile.Create(Percorso);
  try
    FLingua := Ini.ReadString('Generale', 'Lingua', FLingua);
    FTema := Ini.ReadString('Generale', 'Tema', FTema);
    FUltimoFile := Ini.ReadString('File', 'Ultimo', '');
  finally
    Ini.Free;
  end;
end;

procedure TImpostazioni.Cancella;
begin
  if FileExists(Percorso) then
    DeleteFile(Percorso);
end;

procedure TImpostazioni.Salva;
var
  Ini: TIniFile;
begin
  ForceDirectories(ExtractFilePath(Percorso));
  Ini := TIniFile.Create(Percorso);
  try
    Ini.WriteString('Generale', 'Lingua', FLingua);
    Ini.WriteString('Generale', 'Tema', FTema);
    Ini.WriteString('File', 'Ultimo', FUltimoFile);
  finally
    Ini.Free;
  end;
end;

end.
