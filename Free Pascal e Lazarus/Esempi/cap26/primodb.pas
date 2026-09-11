{ PrimoDb - Manuale completo di Free Pascal e Lazarus }
program PrimoDb;
{$mode objfpc}{$H+}
uses
  SysUtils, sqldb, sqlite3conn, db;
var
  Conn: TSQLite3Connection;
  Tr: TSQLTransaction;
  Q: TSQLQuery;
begin
  DeleteFile('libri.db');
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

    Conn.ExecuteDirect(
      'CREATE TABLE libri (' +
      ' id INTEGER PRIMARY KEY AUTOINCREMENT,' +
      ' titolo VARCHAR(100) NOT NULL,' +
      ' autore VARCHAR(60),' +
      ' anno INTEGER,' +
      ' prezzo REAL)');
    Conn.ExecuteDirect(
      'INSERT INTO libri (titolo, autore, anno, prezzo)' +
      ' VALUES' +
      ' (''Algoritmi + Strutture dati'', ''Wirth'',' +
      '  1976, 35.5),' +
      ' (''The Art of Computer Programming'', ''Knuth'',' +
      '  1968, 89.0),' +
      ' (''Clean Code'', ''Martin'', 2008, 42.0)');
    Tr.Commit;

    Q.SQL.Text := 'SELECT id, titolo, anno FROM libri ' +
                  'ORDER BY anno';
    Q.Open;
    while not Q.EOF do
    begin
      WriteLn(Q.FieldByName('id').AsInteger:3, ' ',
              Q.FieldByName('anno').AsInteger, ' ',
              Q.FieldByName('titolo').AsString);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
    Tr.Free;
    Conn.Free;
  end;
end.
