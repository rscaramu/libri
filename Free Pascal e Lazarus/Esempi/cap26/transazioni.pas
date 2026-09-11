{ Transazioni - Manuale completo di Free Pascal e Lazarus }
program Transazioni;
{$mode objfpc}{$H+}
uses
  SysUtils, sqldb, sqlite3conn, db;
var
  Conn: TSQLite3Connection;
  Tr: TSQLTransaction;
  Q: TSQLQuery;

procedure Trasferisci(Da, A: Integer; Importo: Currency);
begin
  Q.SQL.Text := 'UPDATE conti SET saldo = saldo - :i ' +
                'WHERE id = :id AND saldo >= :i';
  Q.Params.ParamByName('i').AsCurrency := Importo;
  Q.Params.ParamByName('id').AsInteger := Da;
  Q.ExecSQL;
  if Q.RowsAffected <> 1 then
    raise Exception.Create('Saldo insufficiente');
  Q.SQL.Text := 'UPDATE conti SET saldo = saldo + :i ' +
                'WHERE id = :id';
  Q.Params.ParamByName('i').AsCurrency := Importo;
  Q.Params.ParamByName('id').AsInteger := A;
  Q.ExecSQL;
end;

procedure Mostra;
begin
  Q.SQL.Text := 'SELECT id, saldo FROM conti ORDER BY id';
  Q.Open;
  while not Q.EOF do
  begin
    Write('conto ', Q.Fields[0].AsInteger, ': ',
          Q.Fields[1].AsCurrency:0:2, '  ');
    Q.Next;
  end;
  WriteLn;
  Q.Close;
end;

begin
  DeleteFile('banca.db');
  Conn := TSQLite3Connection.Create(nil);
  Tr := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);
  try
    Conn.DatabaseName := 'banca.db';
    Conn.Transaction := Tr;
    Tr.Database := Conn;
    Q.Database := Conn;
    Q.Transaction := Tr;
    Conn.Open;
    Conn.ExecuteDirect('CREATE TABLE conti ' +
      '(id INTEGER PRIMARY KEY, saldo REAL)');
    Conn.ExecuteDirect('INSERT INTO conti ' +
      'VALUES (1, 100), (2, 50)');
    Tr.Commit;

    Trasferisci(1, 2, 30);
    Tr.Commit;
    Mostra;
    try
      Trasferisci(1, 2, 500);
      Tr.Commit;
    except
      on E: Exception do
      begin
        Tr.Rollback;
        WriteLn('Annullato: ', E.Message);
      end;
    end;
    Mostra;
  finally
    Q.Free;
    Tr.Free;
    Conn.Free;
  end;
end.
