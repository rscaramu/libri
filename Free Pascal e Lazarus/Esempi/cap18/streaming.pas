{ Streaming - Manuale completo di Free Pascal e Lazarus }
program Streaming;
{$mode objfpc}{$H+}
uses
  Classes, SysUtils;
type
  TImpostazioni = class(TComponent)
  private
    FLingua: String;
    FLarghezza: Integer;
    FScuro: Boolean;
  published
    property Lingua: String read FLingua write FLingua;
    property Larghezza: Integer read FLarghezza
                                write FLarghezza default 800;
    property Scuro: Boolean read FScuro write FScuro;
  end;

var
  I, J: TImpostazioni;
  Bin, Txt: TMemoryStream;
  L: TStringList;
begin
  RegisterClass(TImpostazioni);
  I := TImpostazioni.Create(nil);
  Bin := TMemoryStream.Create;
  Txt := TMemoryStream.Create;
  L := TStringList.Create;
  try
    I.Name := 'Config';
    I.Lingua := 'it';
    I.Larghezza := 800;    { uguale al default: non salvata }
    I.Scuro := True;
    Bin.WriteComponent(I);
    Bin.Position := 0;
    ObjectBinaryToText(Bin, Txt);
    Txt.Position := 0;
    L.LoadFromStream(Txt);
    WriteLn(L.Text);
    Bin.Position := 0;
    J := TImpostazioni(Bin.ReadComponent(nil));
    WriteLn(J.Name, ': ', J.Lingua, ' ', J.Larghezza, ' ',
            J.Scuro);
    J.Free;
  finally
    L.Free;
    Txt.Free;
    Bin.Free;
    I.Free;
  end;
end.
