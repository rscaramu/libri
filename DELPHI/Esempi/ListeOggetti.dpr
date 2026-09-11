program ListeOggetti;

{$APPTYPE CONSOLE}

uses
  SysUtils, Generics.Collections;

type
  TArticolo = class
    Nome: string;
    constructor Create(const ANome: string);
    destructor Destroy; override;
  end;

constructor TArticolo.Create(const ANome: string);
begin
  inherited Create;
  Nome := ANome;
end;

destructor TArticolo.Destroy;
begin
  WriteLn('libero ', Nome);
  inherited;
end;

var
  L: TObjectList<TArticolo>;
  A: TArticolo;
begin
  L := TObjectList<TArticolo>.Create(True);
  try
    L.Add(TArticolo.Create('vite'));
    L.Add(TArticolo.Create('dado'));
    L.Add(TArticolo.Create('bullone'));
    L.Delete(0);
    A := L.Extract(L[0]);
    WriteLn('estratto ', A.Nome, ', restano ', L.Count);
    A.Free;
    WriteLn('fine');
  finally
    L.Free;
  end;
end.
