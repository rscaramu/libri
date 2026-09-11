program Documento;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, Generics.Collections;

type
  TDocumento = class
  private
    FRighe: TStringList;
    FAllegati: TList<TDocumento>;
    FNome: string;
  public
    constructor Create(const ANome: string);
    destructor Destroy; override;
    property Righe: TStringList read FRighe;
    property Allegati: TList<TDocumento> read FAllegati;
  end;

constructor TDocumento.Create(const ANome: string);
begin
  inherited Create;
  FNome := ANome;
  FRighe := TStringList.Create;
  FAllegati := TList<TDocumento>.Create;
end;

destructor TDocumento.Destroy;
begin
  WriteLn('distruggo ', FNome);
  FAllegati.Free;
  FRighe.Free;
  inherited;
end;

var
  Principale, Allegato: TDocumento;
begin
  Principale := TDocumento.Create('principale');
  Allegato := TDocumento.Create('allegato');
  try
    Principale.Righe.Add('testo');
    Principale.Allegati.Add(Allegato);
    WriteLn(Principale.Allegati.Count, ' ',
      Principale.Righe.Count);
  finally
    Principale.Free;
    Allegato.Free;
  end;
end.
