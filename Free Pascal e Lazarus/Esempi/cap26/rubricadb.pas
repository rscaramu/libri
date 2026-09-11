{ RubricaDb - Manuale completo di Free Pascal e Lazarus }
program RubricaDb;
{$mode objfpc}{$H+}
uses
  SysUtils, sqldb, sqlite3conn, db;
const
  Nomi: array[0..2] of String =
    ('Rossi Mario', 'Bianchi Anna', 'Rossini Carlo');
var
  Conn: TSQLite3Connection;
  Tr: TSQLTransaction;
  Q: TSQLQuery;
  Nome: String;
begin
  DeleteFile('rubrica.db');
  Conn := TSQLite3Connection.Create(nil);
  Tr := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);
  try
    Conn.DatabaseName := 'rubrica.db';
    Conn.Transaction := Tr;
    Tr.Database := Conn;
    Q.Database := Conn;
    Q.Transaction := Tr;
    Conn.Open;
    Conn.ExecuteDirect('CREATE TABLE contatti (' +
      'id INTEGER PRIMARY KEY, nome TEXT, telefono TEXT)');
    Q.SQL.Text := 'INSERT INTO contatti (nome, telefono) ' +
                  'VALUES (:n, :t)';
    for Nome in Nomi do
    begin
      Q.Params.ParamByName('n').AsString := Nome;
      Q.Params.ParamByName('t').AsString :=
        '3' + IntToStr(Length(Nome) * 1000);
      Q.ExecSQL;
    end;
    Tr.Commit;
    Q.SQL.Text := 'SELECT nome, telefono FROM contatti ' +
                  'WHERE nome LIKE :n ORDER BY nome';
    Q.Params.ParamByName('n').AsString := 'Ross%';
    Q.Open;
    while not Q.EOF do
    begin
      WriteLn(Q.Fields[0].AsString:14, '  ',
              Q.Fields[1].AsString);
      Q.Next;
    end;
  finally
    Q.Free;
    Tr.Free;
    Conn.Free;
  end;
end.
