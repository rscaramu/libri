{ ConfigJson - Manuale completo di Free Pascal e Lazarus }
program ConfigJson;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, fpjson, jsonparser, fpjsonrtti;
type
  TConfig = class(TPersistent)
  private
    FLingua: String;
    FLarghezza: Integer;
    FRecenti: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Salva(const NomeFile: String);
    procedure Carica(const NomeFile: String);
  published
    property Lingua: String read FLingua write FLingua;
    property Larghezza: Integer read FLarghezza
                                write FLarghezza;
    property Recenti: TStringList read FRecenti;
  end;

constructor TConfig.Create;
begin
  FLingua := 'it';
  FLarghezza := 800;
  FRecenti := TStringList.Create;
end;

destructor TConfig.Destroy;
begin
  FRecenti.Free;
  inherited;
end;

procedure TConfig.Salva(const NomeFile: String);
var
  S: TJSONStreamer;
  L: TStringList;
begin
  S := TJSONStreamer.Create(nil);
  L := TStringList.Create;
  try
    S.Options := [jsoTStringsAsArray];
    L.Text := S.ObjectToJSON(Self).FormatJSON;
    L.SaveToFile(NomeFile);
  finally
    L.Free;
    S.Free;
  end;
end;

procedure TConfig.Carica(const NomeFile: String);
var
  D: TJSONDeStreamer;
  L: TStringList;
begin
  if not FileExists(NomeFile) then
    Exit;
  D := TJSONDeStreamer.Create(nil);
  L := TStringList.Create;
  try
    L.LoadFromFile(NomeFile);
    D.JSONToObject(L.Text, Self);
  finally
    L.Free;
    D.Free;
  end;
end;

var
  C: TConfig;
begin
  C := TConfig.Create;
  try
    C.Lingua := 'en';
    C.Recenti.Add('a.txt');
    C.Recenti.Add('b.txt');
    C.Salva('config.json');
  finally
    C.Free;
  end;
  C := TConfig.Create;
  try
    C.Carica('config.json');
    WriteLn(C.Lingua, ' ', C.Larghezza, ' ', C.Recenti.Count);
  finally
    C.Free;
  end;
end.
