unit TestFinanziamenti;

interface

uses
  DUnitX.TestFramework, Finanziamenti;

type
  [TestFixture]
  TTestRata = class
  private
    FCalc: TCalcolatoreRate;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TassoZero;

    [Test]
    [TestCase('un anno al 6%', '1000,0.06,12,86.07')]
    [TestCase('dieci anni al 4%', '10000,0.04,120,101.25')]
    [TestCase('una rata', '1000,0.6,1,1050')]
    procedure RataStandard(Capitale, Tasso: Double;
      Mesi: Integer; Attesa: Double);

    [Test]
    procedure MesiNonValidi;

    [Test]
    [Ignore('in attesa della specifica sul differimento')]
    procedure RataDifferita;
  end;

implementation

uses
  System.SysUtils;

procedure TTestRata.Setup;
begin
  FCalc := TCalcolatoreRate.Create;
end;

procedure TTestRata.TearDown;
begin
  FCalc.Free;
end;

procedure TTestRata.TassoZero;
begin
  Assert.AreEqual(100.0, FCalc.Rata(1200, 0, 12), 0.005);
end;

procedure TTestRata.RataStandard(Capitale, Tasso: Double;
  Mesi: Integer; Attesa: Double);
begin
  Assert.AreEqual(Attesa, FCalc.Rata(Capitale, Tasso, Mesi),
    0.005);
end;

procedure TTestRata.MesiNonValidi;
begin
  Assert.WillRaise(
    procedure
    begin
      FCalc.Rata(1000, 0.05, 0);
    end,
    EArgumentException);
end;

procedure TTestRata.RataDifferita;
begin
  Assert.Fail('non implementato');
end;

initialization
  TDUnitX.RegisterTestFixture(TTestRata);

end.
