unit Officina.Test.Dominio;

interface

uses
  DUnitX.TestFramework, Officina.Dominio;

type
  [TestFixture]
  TTestPreventivo = class
  private
    FCliente: TCliente;
    FFiltro, FManodopera: TArticolo;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TotaliConSconto;
    [Test]
    procedure ArrotondamentoPerRiga;
    [Test]
    procedure QuantitaZeroRifiutata;
    [Test]
    procedure ConfermatoNonModificabile;
    [Test]
    procedure ConfermaVuotoRifiutata;
    [Test]
    [TestCase('zero', '0')]
    [TestCase('ridotta', '10')]
    [TestCase('ordinaria', '22')]
    procedure AliquoteValide(Aliquota: Integer);
    [Test]
    [TestCase('otto', '8')]
    [TestCase('negativa', '-1')]
    procedure AliquoteNonValide(Aliquota: Integer);
  end;

implementation

uses
  System.SysUtils, System.DateUtils;

procedure TTestPreventivo.Setup;
begin
  FCliente := TCliente.Create(1, 'Rossi', '');
  FFiltro := TArticolo.Create('FIL01', 'Filtro', 12.5, 22);
  FManodopera := TArticolo.Create('MAN02', 'Manodopera', 35,
    22);
end;

procedure TTestPreventivo.TearDown;
begin
  FManodopera.Free;
  FFiltro.Free;
  FCliente.Free;
end;

procedure TTestPreventivo.TotaliConSconto;
var
  P: TPreventivo;
begin
  P := TPreventivo.Create(1, FCliente, Today);
  try
    P.Aggiungi(FFiltro, 2);
    P.Aggiungi(FManodopera, 3, 10);
    Assert.AreEqual<Currency>(119.5, P.Imponibile);
    Assert.AreEqual<Currency>(26.29, P.Iva);
    Assert.AreEqual<Currency>(145.79, P.Totale);
  finally
    P.Free;
  end;
end;

procedure TTestPreventivo.ArrotondamentoPerRiga;
var
  A: TArticolo;
  P: TPreventivo;
begin
  A := TArticolo.Create('X', 'Tre terzi', 0.01, 22);
  P := TPreventivo.Create(1, FCliente, Today);
  try
    P.Aggiungi(A, 1);
    P.Aggiungi(A, 1);
    P.Aggiungi(A, 1);
    Assert.AreEqual<Currency>(0.03, P.Imponibile);
    Assert.AreEqual<Currency>(0, P.Iva);
  finally
    P.Free;
    A.Free;
  end;
end;

procedure TTestPreventivo.QuantitaZeroRifiutata;
var
  P: TPreventivo;
begin
  P := TPreventivo.Create(1, FCliente, Today);
  try
    Assert.WillRaise(
      procedure
      begin
        P.Aggiungi(FFiltro, 0);
      end, ECommerciale);
  finally
    P.Free;
  end;
end;

procedure TTestPreventivo.ConfermatoNonModificabile;
var
  P: TPreventivo;
begin
  P := TPreventivo.Create(1, FCliente, Today);
  try
    P.Aggiungi(FFiltro, 1);
    P.Conferma;
    Assert.WillRaise(
      procedure
      begin
        P.Aggiungi(FFiltro, 1);
      end, ECommerciale);
    Assert.WillRaise(
      procedure
      begin
        P.Rimuovi(0);
      end, ECommerciale);
  finally
    P.Free;
  end;
end;

procedure TTestPreventivo.ConfermaVuotoRifiutata;
var
  P: TPreventivo;
begin
  P := TPreventivo.Create(1, FCliente, Today);
  try
    Assert.WillRaise(
      procedure
      begin
        P.Conferma;
      end, ECommerciale);
  finally
    P.Free;
  end;
end;

procedure TTestPreventivo.AliquoteValide(Aliquota: Integer);
var
  A: TArticolo;
begin
  A := TArticolo.Create('X', 'X', 1, Aliquota);
  try
    Assert.AreEqual(Aliquota, A.Aliquota);
  finally
    A.Free;
  end;
end;

procedure TTestPreventivo.AliquoteNonValide(
  Aliquota: Integer);
begin
  Assert.WillRaise(
    procedure
    begin
      TArticolo.Create('X', 'X', 1, Aliquota).Free;
    end, ECommerciale);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestPreventivo);

end.
