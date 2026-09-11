{ Compilazione - Manuale completo di Free Pascal e Lazarus }
unit Compilazione;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Process;

type
  TMessaggioCompilatore = record
    NomeFile: String;
    Riga, Colonna: Integer;
    Tipo: String;      { Error, Warning, Note, Hint, Fatal }
    Testo: String;
  end;
  TMessaggi = array of TMessaggioCompilatore;

function Compila(const Sorgente: String; out Output: String;
                 out Messaggi: TMessaggi): Boolean;
function AnalizzaRiga(const Riga: String;
                      out M: TMessaggioCompilatore): Boolean;

implementation

function AnalizzaRiga(const Riga: String;
                      out M: TMessaggioCompilatore): Boolean;
var
  P1, P2, P3: Integer;
  Dentro: String;
begin
  { formato: file(riga,colonna) Tipo: testo }
  Result := False;
  P1 := Pos('(', Riga);
  P2 := Pos(') ', Riga);
  if (P1 = 0) or (P2 = 0) or (P2 < P1) then
    Exit;
  Dentro := Copy(Riga, P1 + 1, P2 - P1 - 1);
  P3 := Pos(',', Dentro);
  if P3 = 0 then
    Exit;
  if not TryStrToInt(Copy(Dentro, 1, P3 - 1), M.Riga) or
     not TryStrToInt(Copy(Dentro, P3 + 1, 99), M.Colonna) then
    Exit;
  M.NomeFile := Copy(Riga, 1, P1 - 1);
  Dentro := Copy(Riga, P2 + 2, Length(Riga));
  P3 := Pos(': ', Dentro);
  if P3 = 0 then
    Exit;
  M.Tipo := Copy(Dentro, 1, P3 - 1);
  M.Testo := Copy(Dentro, P3 + 2, Length(Dentro));
  Result := True;
end;

function Compila(const Sorgente: String; out Output: String;
                 out Messaggi: TMessaggi): Boolean;
var
  Righe: TStringList;
  R: String;
  M: TMessaggioCompilatore;
begin
  Result := RunCommand('fpc', ['-Mobjfpc', '-Sh', '-vewnh',
                       '-FE' + ExtractFilePath(Sorgente),
                       Sorgente], Output);
  Messaggi := nil;
  Righe := TStringList.Create;
  try
    Righe.Text := Output;
    for R in Righe do
      if AnalizzaRiga(R, M) then
      begin
        SetLength(Messaggi, Length(Messaggi) + 1);
        Messaggi[High(Messaggi)] := M;
      end;
  finally
    Righe.Free;
  end;
end;

end.
