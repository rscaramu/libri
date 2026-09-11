unit Officina.Dati;

interface

uses
  System.SysUtils, System.Generics.Collections,
  Officina.Dominio, FireDAC.Comp.Client, FireDAC.Stan.Param;

type
  IRepositorio = interface
    function Clienti: TObjectList<TCliente>;
    function Articoli: TObjectList<TArticolo>;
    procedure SalvaPreventivo(P: TPreventivo);
    function CaricaPreventivo(Numero: Integer;
      Clienti: TObjectList<TCliente>;
      Articoli: TObjectList<TArticolo>): TPreventivo;
    function ProssimoNumero: Integer;
  end;

  TRepositorioSQLite = class(TInterfacedObject, IRepositorio)
  private
    FConn: TFDConnection;
    procedure CreaSchema;
  public
    constructor Create(const NomeFile: string);
    destructor Destroy; override;
    function Clienti: TObjectList<TCliente>;
    function Articoli: TObjectList<TArticolo>;
    procedure SalvaPreventivo(P: TPreventivo);
    function CaricaPreventivo(Numero: Integer;
      Clienti: TObjectList<TCliente>;
      Articoli: TObjectList<TArticolo>): TPreventivo;
    function ProssimoNumero: Integer;
  end;

implementation

uses
  FireDAC.Stan.Def, FireDAC.Phys.SQLite, FireDAC.DApt;

constructor TRepositorioSQLite.Create(const NomeFile: string);
begin
  inherited Create;
  FConn := TFDConnection.Create(nil);
  FConn.DriverName := 'SQLite';
  FConn.Params.Database := NomeFile;
  FConn.LoginPrompt := False;
  FConn.Open;
  CreaSchema;
end;

destructor TRepositorioSQLite.Destroy;
begin
  FConn.Free;
  inherited;
end;

procedure TRepositorioSQLite.CreaSchema;
begin
  FConn.ExecSQL('CREATE TABLE IF NOT EXISTS clienti (' +
    'id INTEGER PRIMARY KEY, nome TEXT NOT NULL, ' +
    'email TEXT)');
  FConn.ExecSQL('CREATE TABLE IF NOT EXISTS articoli (' +
    'codice TEXT PRIMARY KEY, descrizione TEXT, ' +
    'prezzo REAL NOT NULL, aliquota INTEGER NOT NULL)');
  FConn.ExecSQL('CREATE TABLE IF NOT EXISTS preventivi (' +
    'numero INTEGER PRIMARY KEY, ' +
    'cliente_id INTEGER NOT NULL, data TEXT NOT NULL, ' +
    'confermato INTEGER NOT NULL DEFAULT 0)');
  FConn.ExecSQL('CREATE TABLE IF NOT EXISTS righe (' +
    'preventivo INTEGER NOT NULL, ' +
    'posizione INTEGER NOT NULL, ' +
    'codice TEXT NOT NULL, quantita INTEGER NOT NULL, ' +
    'sconto INTEGER NOT NULL, ' +
    'PRIMARY KEY (preventivo, posizione))');
end;

function TRepositorioSQLite.Clienti: TObjectList<TCliente>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TCliente>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.Open('SELECT id, nome, email FROM clienti ' +
      'ORDER BY nome');
    while not Q.Eof do
    begin
      Result.Add(TCliente.Create(Q.Fields[0].AsInteger,
        Q.Fields[1].AsString, Q.Fields[2].AsString));
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

function TRepositorioSQLite.Articoli: TObjectList<TArticolo>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TArticolo>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.Open('SELECT codice, descrizione, prezzo, aliquota ' +
      'FROM articoli ORDER BY codice');
    while not Q.Eof do
    begin
      Result.Add(TArticolo.Create(Q.Fields[0].AsString,
        Q.Fields[1].AsString, Q.Fields[2].AsCurrency,
        Q.Fields[3].AsInteger));
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TRepositorioSQLite.SalvaPreventivo(P: TPreventivo);
var
  I: Integer;
begin
  FConn.StartTransaction;
  try
    FConn.ExecSQL('INSERT OR REPLACE INTO preventivi ' +
      '(numero, cliente_id, data, confermato) ' +
      'VALUES (:n, :c, :d, :k)',
      [P.Numero, P.Cliente.Id, DateToISO8601(P.Data),
       Ord(P.Confermato)]);
    FConn.ExecSQL('DELETE FROM righe WHERE preventivo = :n',
      [P.Numero]);
    for I := 0 to P.Righe.Count - 1 do
      FConn.ExecSQL('INSERT INTO righe ' +
        '(preventivo, posizione, codice, quantita, sconto) ' +
        'VALUES (:n, :p, :c, :q, :s)',
        [P.Numero, I, P.Righe[I].Articolo.Codice,
         P.Righe[I].Quantita, P.Righe[I].Sconto]);
    FConn.Commit;
  except
    FConn.Rollback;
    raise;
  end;
end;

function TRepositorioSQLite.CaricaPreventivo(Numero: Integer;
  Clienti: TObjectList<TCliente>;
  Articoli: TObjectList<TArticolo>): TPreventivo;

  function TrovaCliente(Id: Integer): TCliente;
  var
    C: TCliente;
  begin
    for C in Clienti do
      if C.Id = Id then
        Exit(C);
    raise ECommerciale.CreateFmt('cliente %d inesistente',
      [Id]);
  end;

  function TrovaArticolo(const Codice: string): TArticolo;
  var
    A: TArticolo;
  begin
    for A in Articoli do
      if A.Codice = Codice then
        Exit(A);
    raise ECommerciale.CreateFmt('articolo %s inesistente',
      [Codice]);
  end;

var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.Open('SELECT cliente_id, data, confermato ' +
      'FROM preventivi WHERE numero = :n', [Numero]);
    if Q.IsEmpty then
      Exit(nil);
    Result := TPreventivo.Create(Numero,
      TrovaCliente(Q.Fields[0].AsInteger),
      ISO8601ToDate(Q.Fields[1].AsString));
    Q.Close;
    Q.Open('SELECT codice, quantita, sconto FROM righe ' +
      'WHERE preventivo = :n ORDER BY posizione', [Numero]);
    while not Q.Eof do
    begin
      Result.Aggiungi(TrovaArticolo(Q.Fields[0].AsString),
        Q.Fields[1].AsInteger, Q.Fields[2].AsInteger);
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

function TRepositorioSQLite.ProssimoNumero: Integer;
begin
  Result := FConn.ExecSQLScalar(
    'SELECT COALESCE(MAX(numero), 1000) + 1 FROM preventivi');
end;

end.
