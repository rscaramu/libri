{ Parametri26 - Manuale completo di Free Pascal e Lazarus }
program Parametri26;
{$mode objfpc}{$H+}
uses
  SysUtils, sqldb, sqlite3conn, db;
var
  Conn: TSQLite3Connection;
  Tr: TSQLTransaction;
  Q: TSQLQuery;
  I: Integer;
begin
  Conn := TSQLite3Connection.Create(nil);
  Tr := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);
  try
    Conn.DatabaseName := 'libri.db';
    Conn.Transaction := Tr;
    Tr.Database := Conn;
    Q.Database := Conn;
    Q.Transaction := Tr;
    Conn.Open;

    Q.SQL.Text := 'INSERT INTO libri (titolo, autore, ' +
                  'anno, prezzo) VALUES (:t, :a, :anno, :p)';
    for I := 1 to 3 do
    begin
      Q.Params.ParamByName('t').AsString :=
        Format('Volume %d dell''opera', [I]);
      Q.Params.ParamByName('a').AsString := 'O''Brien';
      Q.Params.ParamByName('anno').AsInteger := 2000 + I;
      Q.Params.ParamByName('p').AsFloat := 10 * I;
      Q.ExecSQL;
    end;
    Tr.Commit;

    Q.SQL.Text := 'SELECT COUNT(*) AS n, AVG(prezzo) ' +
                  'AS media FROM libri WHERE autore = :a';
    Q.Params.ParamByName('a').AsString := 'O''Brien';
    Q.Open;
    WriteLn('Libri di O''Brien: ',
            Q.FieldByName('n').AsInteger, ', prezzo medio ',
            Q.FieldByName('media').AsFloat:0:2);
    Q.Close;

    Q.SQL.Text := 'SELECT titolo FROM libri ' +
                  'WHERE anno > :da ORDER BY anno';
    Q.Params.ParamByName('da').AsInteger := 2000;
    Q.Open;
    while not Q.EOF do
    begin
      WriteLn('  ', Q.Fields[0].AsString);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
    Tr.Free;
    Conn.Free;
  end;
end.
