unit ModuloDati;

interface

uses
  System.SysUtils, System.Classes, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TDM = class(TDataModule)
    Conn: TFDConnection;
    DriverSQLite: TFDPhysSQLiteDriverLink;
    WaitCursor: TFDGUIxWaitCursor;
    qryClienti: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  public
    procedure Apri(const NomeFile: string);
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  Conn.LoginPrompt := False;
end;

procedure TDM.Apri(const NomeFile: string);
begin
  Conn.Close;
  Conn.DriverName := 'SQLite';
  Conn.Params.Database := NomeFile;
  Conn.Params.Add('LockingMode=Normal');
  Conn.Open;
  Conn.ExecSQL(
    'CREATE TABLE IF NOT EXISTS clienti (' +
    '  id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  nome TEXT NOT NULL,' +
    '  citta TEXT,' +
    '  saldo REAL NOT NULL DEFAULT 0)');
end;

end.
