{ Importa - Manuale completo di Free Pascal e Lazarus }
program Importa;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, sqldb, sqlite3conn, db;

procedure ImportaFile(const NomeFile: String);
var
  Conn: TSQLite3Connection;
  Tr: TSQLTransaction;
  Q: TSQLQuery;
  Righe: TStringList;
  Riga: String;
  P, N: Integer;
begin
  Conn := TSQLite3Connection.Create(nil);
  Tr := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);
  Righe := TStringList.Create;
  try
    Conn.DatabaseName := 'magazzino.db';
    Conn.Transaction := Tr;
    Tr.Database := Conn;
    Q.Database := Conn;
    Q.Transaction := Tr;
    Conn.Open;
    Conn.ExecuteDirect('CREATE TABLE IF NOT EXISTS scorte ' +
                       '(nome TEXT, quanti INTEGER)');
    Tr.Commit;
    Righe.LoadFromFile(NomeFile);
    Q.SQL.Text := 'INSERT INTO scorte VALUES (:n, :q)';
    try
      for Riga in Righe do
      begin
        P := Pos(';', Riga);
        if (P = 0) or
           not TryStrToInt(Copy(Riga, P + 1, 99), N) then
          raise Exception.Create('Riga non valida: ' + Riga);
        Q.Params.ParamByName('n').AsString :=
          Copy(Riga, 1, P - 1);
        Q.Params.ParamByName('q').AsInteger := N;
        Q.ExecSQL;
      end;
      Tr.Commit;
      WriteLn(NomeFile, ': importate ', Righe.Count,
              ' righe');
    except
      on E: Exception do
      begin
        Tr.Rollback;
        WriteLn(NomeFile, ': ', E.Message, ' (annullato)');
      end;
    end;
    Q.SQL.Text := 'SELECT COUNT(*) FROM scorte';
    Q.Open;
    WriteLn('  righe in tabella: ', Q.Fields[0].AsInteger);
  finally
    Righe.Free;
    Q.Free;
    Tr.Free;
    Conn.Free;
  end;
end;

var
  L: TStringList;
begin
  DeleteFile('magazzino.db');
  L := TStringList.Create;
  try
    L.Add('viti;100');
    L.Add('dadi;200');
    L.SaveToFile('buono.txt');
    L.Add('rondelle;molte');
    L.SaveToFile('cattivo.txt');
  finally
    L.Free;
  end;
  ImportaFile('buono.txt');
  ImportaFile('cattivo.txt');
end.
