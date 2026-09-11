{ JsonRtti - Manuale completo di Free Pascal e Lazarus }
program JsonRtti;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, fpjson, fpjsonrtti;
type
  TIndirizzo = class(TPersistent)
  private
    FCitta, FVia: String;
  published
    property Via: String read FVia write FVia;
    property Citta: String read FCitta write FCitta;
  end;

  TCliente = class(TPersistent)
  private
    FNome: String;
    FEta: Integer;
    FIndirizzo: TIndirizzo;
    FTag: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Nome: String read FNome write FNome;
    property Eta: Integer read FEta write FEta;
    property Indirizzo: TIndirizzo read FIndirizzo;
    property Tag: TStringList read FTag;
  end;

constructor TCliente.Create;
begin
  FIndirizzo := TIndirizzo.Create;
  FTag := TStringList.Create;
end;

destructor TCliente.Destroy;
begin
  FTag.Free;
  FIndirizzo.Free;
  inherited;
end;

var
  C, D: TCliente;
  Streamer: TJSONStreamer;
  DeStreamer: TJSONDeStreamer;
  S: String;
begin
  C := TCliente.Create;
  D := TCliente.Create;
  Streamer := TJSONStreamer.Create(nil);
  DeStreamer := TJSONDeStreamer.Create(nil);
  try
    C.Nome := 'Linus';
    C.Eta := 56;
    C.Indirizzo.Citta := 'Portland';
    C.Tag.Add('kernel');
    C.Tag.Add('git');
    Streamer.Options := [jsoTStringsAsArray];
    S := Streamer.ObjectToJSONString(C);
    WriteLn(Streamer.ObjectToJSON(C).FormatJSON);
    DeStreamer.Options := [jdoIgnorePropertyErrors];
    DeStreamer.JSONToObject(S, D);
    WriteLn(D.Nome, ', ', D.Eta, ', ', D.Indirizzo.Citta,
            ', ', D.Tag.CommaText);
  finally
    DeStreamer.Free;
    Streamer.Free;
    D.Free;
    C.Free;
  end;
end.
