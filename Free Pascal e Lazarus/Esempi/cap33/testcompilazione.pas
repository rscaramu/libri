{ TestCompilazione - Manuale completo di Free Pascal e Lazarus }
unit TestCompilazione;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, fpcunit, testregistry, Compilazione;

type
  TTestAnalisi = class(TTestCase)
  published
    procedure TestErrore;
    procedure TestWarning;
    procedure TestSenzaPosizione;
    procedure TestParentesiNelTesto;
  end;

implementation

procedure TTestAnalisi.TestErrore;
var
  M: TMessaggioCompilatore;
begin
  AssertTrue(AnalizzaRiga(
    'a.pas(3,7) Error: Identifier not found "x"', M));
  AssertEquals('a.pas', M.NomeFile);
  AssertEquals(3, M.Riga);
  AssertEquals(7, M.Colonna);
  AssertEquals('Error', M.Tipo);
end;

procedure TTestAnalisi.TestWarning;
var
  M: TMessaggioCompilatore;
begin
  AssertTrue(AnalizzaRiga('b.pp(10,2) Warning: unused', M));
  AssertEquals('Warning', M.Tipo);
  AssertEquals('unused', M.Testo);
end;

procedure TTestAnalisi.TestSenzaPosizione;
var
  M: TMessaggioCompilatore;
begin
  AssertFalse(AnalizzaRiga('Fatal: Compilation aborted', M));
  AssertFalse(AnalizzaRiga('', M));
end;

procedure TTestAnalisi.TestParentesiNelTesto;
var
  M: TMessaggioCompilatore;
begin
  AssertTrue(AnalizzaRiga(
    'c.pas(1,1) Hint: Parameter "f(x)" not used', M));
  AssertEquals(1, M.Riga);
  AssertEquals('Parameter "f(x)" not used', M.Testo);
end;

initialization
  RegisterTest(TTestAnalisi);

end.
