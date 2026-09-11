{ TestMagazzino - Manuale completo di Free Pascal e Lazarus }
unit TestMagazzino;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, fpcunit, testregistry, Magazzino;

type
  TTestMagazzino = class(TTestCase)
  private
    FM: TMagazzino;
  private
    procedure ScaricaDue;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCaricoScarico;
    procedure TestScaricoEccessivo;
    procedure TestDuplicato;
  end;

implementation

procedure TTestMagazzino.SetUp;
begin
  FM := TMagazzino.Create;
  FM.Aggiungi('A', 'Articolo A', 2);
end;

procedure TTestMagazzino.TearDown;
begin
  FM.Free;
end;

procedure TTestMagazzino.TestCaricoScarico;
begin
  FM.Carica('A', 10);
  FM.Scarica('A', 3);
  AssertEquals('giacenza', 7, FM.Trova('A').Giacenza);
  AssertEquals('valore', 14.0, FM.ValoreTotale, 0.001);
end;

procedure TTestMagazzino.TestScaricoEccessivo;
begin
  FM.Carica('A', 1);
  AssertException('deve sollevare', EMagazzino,
                  @ScaricaDue);
end;

procedure TTestMagazzino.ScaricaDue;
begin
  FM.Scarica('A', 2);
end;

procedure TTestMagazzino.TestDuplicato;
var
  Sollevata: Boolean;
begin
  Sollevata := False;
  try
    FM.Aggiungi('a', 'minuscolo', 1);
  except
    on EMagazzino do
      Sollevata := True;
  end;
  AssertTrue('codice duplicato ignorando le maiuscole',
             Sollevata);
end;

initialization
  RegisterTest(TTestMagazzino);

end.
