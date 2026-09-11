{ DbAccesso - Manuale completo di Free Pascal e Lazarus }
unit DbAccesso;
{$mode objfpc}{$H+}
interface

uses
  SysUtils, Classes, sqldb, sqlite3conn, db;

type
  TDatabase = class
  private
    FConn: TSQLite3Connection;
    FTr: TSQLTransaction;
  public
    constructor Create(const NomeFile: String);
    destructor Destroy; override;
    procedure Esegui(const SQL: String;
                     const Valori: array of const);
    function Seleziona(const SQL: String): TSQLQuery;
    procedure Commit;
  end;

implementation

constructor TDatabase.Create(const NomeFile: String);
begin
  FConn := TSQLite3Connection.Create(nil);
  FTr := TSQLTransaction.Create(nil);
  FConn.Transaction := FTr;
  FTr.Database := FConn;
  FConn.DatabaseName := NomeFile;
  FConn.Open;
end;

destructor TDatabase.Destroy;
begin
  if FTr.Active then
    FTr.Commit;
  FTr.Free;
  FConn.Free;
  inherited;
end;

procedure TDatabase.Esegui(const SQL: String;
                           const Valori: array of const);
var
  Q: TSQLQuery;
  I: Integer;
begin
  Q := TSQLQuery.Create(nil);
  try
    Q.Database := FConn;
    Q.Transaction := FTr;
    Q.SQL.Text := SQL;
    for I := 0 to High(Valori) do
      case Valori[I].VType of
        vtInteger:
          Q.Params[I].AsInteger := Valori[I].VInteger;
        vtExtended:
          Q.Params[I].AsFloat := Valori[I].VExtended^;
        vtAnsiString:
          Q.Params[I].AsString :=
            AnsiString(Valori[I].VAnsiString);
      end;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

function TDatabase.Seleziona(const SQL: String): TSQLQuery;
begin
  Result := TSQLQuery.Create(nil);
  Result.Database := FConn;
  Result.Transaction := FTr;
  Result.SQL.Text := SQL;
  Result.Open;
end;

procedure TDatabase.Commit;
begin
  FTr.Commit;
end;

end.
