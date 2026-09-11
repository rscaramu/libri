program SerializzaOggetti;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Generics.Collections, REST.Json;

type
  TRigaOrdine = class
  private
    FCodice: string;
    FQuantita: Integer;
  public
    property Codice: string read FCodice write FCodice;
    property Quantita: Integer read FQuantita write FQuantita;
  end;

  TOrdine = class
  private
    FCliente: string;
    FImporto: Double;
    FRighe: TObjectList<TRigaOrdine>;
  public
    constructor Create;
    destructor Destroy; override;
    property Cliente: string read FCliente write FCliente;
    property Importo: Double read FImporto write FImporto;
    property Righe: TObjectList<TRigaOrdine> read FRighe;
  end;

constructor TOrdine.Create;
begin
  inherited;
  FRighe := TObjectList<TRigaOrdine>.Create(True);
end;

destructor TOrdine.Destroy;
begin
  FRighe.Free;
  inherited;
end;

var
  O, Copia: TOrdine;
  R: TRigaOrdine;
  S: string;
begin
  O := TOrdine.Create;
  try
    O.Cliente := 'Rossi';
    O.Importo := 99.5;
    R := TRigaOrdine.Create;
    R.Codice := 'A1';
    R.Quantita := 2;
    O.Righe.Add(R);
    S := TJson.ObjectToJsonString(O);
    WriteLn(S);
  finally
    O.Free;
  end;
  Copia := TJson.JsonToObject<TOrdine>(S);
  try
    WriteLn(Copia.Cliente, ' ', Copia.Righe.Count, ' ',
      Copia.Righe[0].Codice);
  finally
    Copia.Free;
  end;
end.
