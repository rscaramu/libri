{ DataModulo - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit DataModulo;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, sqldb, sqlite3conn, db;

type
  TDmRubrica = class(TDataModule)
    Conn: TSQLite3Connection;
    Tr: TSQLTransaction;
    QContatti: TSQLQuery;
    QGruppi: TSQLQuery;
    DsContatti: TDataSource;
    DsGruppi: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure CreaSchema;
    procedure Popola;
  public
    procedure Cerca(const Testo: String; GruppoId: Integer);
    function SalvaContatto(Id: Integer; const Nome, Cognome,
      Telefono, Email: String; GruppoId: Integer): Integer;
    procedure EliminaContatto(Id: Integer);
    function Leggi(Id: Integer; out Nome, Cognome, Telefono,
                   Email: String;
                   out GruppoId: Integer): Boolean;
    function PercorsoDb: String;
  end;

var
  DmRubrica: TDmRubrica;

implementation

{$R *.lfm}

function TDmRubrica.PercorsoDb: String;
begin
  Result := GetAppConfigDir(False) + 'rubrica.db';
end;

procedure TDmRubrica.DataModuleCreate(Sender: TObject);
var
  Nuovo: Boolean;
begin
  ForceDirectories(GetAppConfigDir(False));
  Nuovo := not FileExists(PercorsoDb);
  Conn.DatabaseName := PercorsoDb;
  Conn.Transaction := Tr;
  Tr.Database := Conn;
  QContatti.Database := Conn;
  QContatti.Transaction := Tr;
  QGruppi.Database := Conn;
  QGruppi.Transaction := Tr;
  DsContatti.DataSet := QContatti;
  DsGruppi.DataSet := QGruppi;
  Conn.Open;
  CreaSchema;
  if Nuovo then
    Popola;
  QGruppi.SQL.Text := 'SELECT id, nome FROM gruppi ' +
                      'ORDER BY nome';
  QGruppi.Open;
  Cerca('', -1);
end;

procedure TDmRubrica.DataModuleDestroy(Sender: TObject);
begin
  if Tr.Active then
    Tr.Commit;
end;

procedure TDmRubrica.CreaSchema;
begin
  Conn.ExecuteDirect('CREATE TABLE IF NOT EXISTS gruppi (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'nome VARCHAR(40) NOT NULL UNIQUE)');
  Conn.ExecuteDirect('CREATE TABLE IF NOT EXISTS contatti (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'nome VARCHAR(60) NOT NULL, ' +
    'cognome VARCHAR(60) NOT NULL, ' +
    'telefono VARCHAR(30), email VARCHAR(120), ' +
    'gruppo_id INTEGER REFERENCES gruppi(id))');
  Conn.ExecuteDirect('CREATE INDEX IF NOT EXISTS ' +
    'idx_contatti_cognome ON contatti(cognome, nome)');
  Tr.Commit;
end;

procedure TDmRubrica.Popola;
begin
  Conn.ExecuteDirect('INSERT INTO gruppi (nome) VALUES ' +
    '(''Famiglia''), (''Lavoro''), (''Amici'')');
  Tr.Commit;
end;

procedure TDmRubrica.Cerca(const Testo: String;
                           GruppoId: Integer);
begin
  QContatti.Close;
  QContatti.SQL.Text :=
    'SELECT c.id, c.cognome, c.nome, c.telefono, c.email, ' +
    ' g.nome AS gruppo ' +
    'FROM contatti c ' +
    'LEFT JOIN gruppi g ON g.id = c.gruppo_id ' +
    'WHERE (c.cognome LIKE :t OR c.nome LIKE :t ' +
    '       OR c.email LIKE :t) ' +
    '  AND (:g < 0 OR c.gruppo_id = :g) ' +
    'ORDER BY c.cognome, c.nome';
  QContatti.Params.ParamByName('t').AsString :=
    '%' + Testo + '%';
  QContatti.Params.ParamByName('g').AsInteger := GruppoId;
  QContatti.ReadOnly := True;
  QContatti.Open;
end;

function TDmRubrica.SalvaContatto(Id: Integer; const Nome,
  Cognome, Telefono, Email: String;
  GruppoId: Integer): Integer;
var
  Q: TSQLQuery;
begin
  Q := TSQLQuery.Create(nil);
  try
    Q.Database := Conn;
    Q.Transaction := Tr;
    if Id = 0 then
      Q.SQL.Text := 'INSERT INTO contatti (nome, cognome, ' +
        'telefono, email, gruppo_id) ' +
        'VALUES (:n, :c, :t, :e, :g)'
    else
      Q.SQL.Text := 'UPDATE contatti SET nome = :n, ' +
        'cognome = :c, telefono = :t, email = :e, ' +
        'gruppo_id = :g WHERE id = :id';
    Q.Params.ParamByName('n').AsString := Nome;
    Q.Params.ParamByName('c').AsString := Cognome;
    Q.Params.ParamByName('t').AsString := Telefono;
    Q.Params.ParamByName('e').AsString := Email;
    if GruppoId > 0 then
      Q.Params.ParamByName('g').AsInteger := GruppoId
    else
      Q.Params.ParamByName('g').Clear;
    if Id <> 0 then
      Q.Params.ParamByName('id').AsInteger := Id;
    Q.ExecSQL;
    if Id = 0 then
    begin
      Q.SQL.Text := 'SELECT last_insert_rowid()';
      Q.Open;
      Result := Q.Fields[0].AsInteger;
      Q.Close;
    end
    else
      Result := Id;
    Tr.CommitRetaining;
  finally
    Q.Free;
  end;
end;

procedure TDmRubrica.EliminaContatto(Id: Integer);
begin
  Conn.ExecuteDirect('DELETE FROM contatti WHERE id = ' +
                     IntToStr(Id));
  Tr.CommitRetaining;
end;

function TDmRubrica.Leggi(Id: Integer; out Nome, Cognome,
  Telefono, Email: String; out GruppoId: Integer): Boolean;
var
  Q: TSQLQuery;
begin
  Q := TSQLQuery.Create(nil);
  try
    Q.Database := Conn;
    Q.Transaction := Tr;
    Q.SQL.Text := 'SELECT * FROM contatti WHERE id = :id';
    Q.Params.ParamByName('id').AsInteger := Id;
    Q.Open;
    Result := not Q.EOF;
    if Result then
    begin
      Nome := Q.FieldByName('nome').AsString;
      Cognome := Q.FieldByName('cognome').AsString;
      Telefono := Q.FieldByName('telefono').AsString;
      Email := Q.FieldByName('email').AsString;
      if Q.FieldByName('gruppo_id').IsNull then
        GruppoId := -1
      else
        GruppoId := Q.FieldByName('gruppo_id').AsInteger;
    end;
  finally
    Q.Free;
  end;
end;

end.
