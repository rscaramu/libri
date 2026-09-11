{ UsaDbAccesso - Manuale completo di Free Pascal e Lazarus }
program UsaDbAccesso;
{$mode objfpc}{$H+}
uses
  SysUtils, sqldb, DbAccesso;
var
  Db: TDatabase;
  Q: TSQLQuery;
begin
  DeleteFile('prodotti.db');
  Db := TDatabase.Create('prodotti.db');
  try
    Db.Esegui('CREATE TABLE prodotti ' +
              '(nome TEXT, prezzo REAL)', []);
    Db.Esegui('INSERT INTO prodotti VALUES (:n, :p)',
              ['Tastiera', 45.0]);
    Db.Esegui('INSERT INTO prodotti VALUES (:n, :p)',
              ['Mouse', 19.5]);
    Db.Commit;
    Q := Db.Seleziona('SELECT nome, prezzo FROM prodotti ' +
                      'ORDER BY prezzo');
    try
      while not Q.EOF do
      begin
        WriteLn(Q.Fields[0].AsString, ': ',
                Q.Fields[1].AsFloat:0:2);
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  finally
    Db.Free;
  end;
end.
