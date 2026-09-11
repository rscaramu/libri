{ StreamingOk - Manuale completo di Free Pascal e Lazarus }
program StreamingOk;
{$mode objfpc}{$H+}
uses
  Classes, SysUtils;
type
  TImpostazioni = class(TComponent)
  private
    FLingua: String;
    FLarghezza: Integer;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Lingua: String read FLingua write FLingua;
    property Larghezza: Integer read FLarghezza
                                write FLarghezza default 800;
  end;

constructor TImpostazioni.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLarghezza := 800;
end;

procedure Salva(C: TComponent; const NomeFile: String);
var
  Bin: TMemoryStream;
  Txt: TFileStream;
begin
  Bin := TMemoryStream.Create;
  Txt := TFileStream.Create(NomeFile, fmCreate);
  try
    Bin.WriteComponent(C);
    Bin.Position := 0;
    ObjectBinaryToText(Bin, Txt);
  finally
    Txt.Free;
    Bin.Free;
  end;
end;

function Carica(const NomeFile: String): TImpostazioni;
var
  Bin: TMemoryStream;
  Txt: TFileStream;
begin
  Bin := TMemoryStream.Create;
  Txt := TFileStream.Create(NomeFile, fmOpenRead);
  try
    ObjectTextToBinary(Txt, Bin);
    Bin.Position := 0;
    Result := TImpostazioni(Bin.ReadComponent(nil));
  finally
    Txt.Free;
    Bin.Free;
  end;
end;

var
  I: TImpostazioni;
begin
  RegisterClass(TImpostazioni);
  I := TImpostazioni.Create(nil);
  try
    I.Name := 'Config';
    I.Lingua := 'it';
    Salva(I, 'config.lfm');
  finally
    I.Free;
  end;
  I := Carica('config.lfm');
  try
    WriteLn(I.Lingua, ' ', I.Larghezza);
  finally
    I.Free;
  end;
end.
