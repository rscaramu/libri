{ Modifiche - Manuale completo di Free Pascal e Lazarus }
program Modifiche;
{$mode objfpc}{$H+}
uses
  SysUtils, sqldb, sqlite3conn, db;
var
  Conn: TSQLite3Connection;
  Tr: TSQLTransaction;
  Q: TSQLQuery;
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
    Q.SQL.Text := 'SELECT id, titolo, prezzo FROM libri';
    Q.Open;
    Q.Locate('titolo', 'Clean Code', []);
    Q.Edit;
    Q.FieldByName('prezzo').AsFloat := 39.9;
    Q.Post;
    Q.Append;
    Q.FieldByName('titolo').AsString := 'Programming Pearls';
    Q.FieldByName('prezzo').AsFloat := 28;
    Q.Post;
    if Q.Locate('titolo', 'Volume 2 dell''opera', []) then
      Q.Delete;
    Q.ApplyUpdates;
    Tr.Commit;
    Q.Close;

    Q.SQL.Text := 'SELECT titolo, prezzo FROM libri ' +
                  'WHERE prezzo < 40 ORDER BY titolo';
    Q.Open;
    while not Q.EOF do
    begin
      WriteLn(Q.Fields[0].AsString:34,
              Q.Fields[1].AsFloat:8:2);
      Q.Next;
    end;
    WriteLn('Record: ', Q.RecordCount);
  finally
    Q.Free;
    Tr.Free;
    Conn.Free;
  end;
end.
