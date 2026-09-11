{ TestModello - Manuale completo di Free Pascal e Lazarus }
unit TestModello;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, fpcunit, testregistry, Modello;

type
  TTestElenco = class(TTestCase)
  private
    FE: TElencoAttivita;
    procedure CompletaDueVolte;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAggiungiEConta;
    procedure TestOrdinamento;
    procedure TestErrori;
  end;

implementation

procedure TTestElenco.SetUp;
begin
  FE := TElencoAttivita.Create;
end;

procedure TTestElenco.TearDown;
begin
  FE.Free;
end;

procedure TTestElenco.TestAggiungiEConta;
begin
  FE.Aggiungi('a', prNormale, 0);
  FE.Aggiungi('b', prAlta, 0);
  FE.Completa(1);
  AssertEquals(1, FE.Conta(True));
  AssertEquals(1, FE.Conta(False));
  AssertEquals(3, FE.ProssimoId);
end;

procedure TTestElenco.TestOrdinamento;
var
  L: TListaAttivita;
begin
  FE.Aggiungi('bassa', prBassa, 0);
  FE.Aggiungi('alta', prAlta, 0);
  FE.Aggiungi('normale con data', prNormale,
              EncodeDate(2026, 1, 1));
  FE.Aggiungi('normale senza', prNormale, 0);
  L := FE.Filtra(True, -1);
  try
    AssertEquals('alta', L[0].Titolo);
    AssertEquals('normale con data', L[1].Titolo);
    AssertEquals('normale senza', L[2].Titolo);
    AssertEquals('bassa', L[3].Titolo);
  finally
    L.Free;
  end;
end;

procedure TTestElenco.CompletaDueVolte;
begin
  FE.Completa(1);
  FE.Completa(1);
end;

procedure TTestElenco.TestErrori;
begin
  FE.Aggiungi('x', prNormale, 0);
  AssertException(EAttivita, @CompletaDueVolte);
  AssertTrue(PrioritaDaTesto('ALTA') = prAlta);
end;

initialization
  RegisterTest(TTestElenco);

end.
