program RttiEstesa;

{$APPTYPE CONSOLE}

{$RTTI EXPLICIT FIELDS([vcPrivate, vcPublic])}

uses
  SysUtils, Rtti;

type
  {$M+}
  TProdotto = class
  private
    FCodice: string;
    FPrezzo: Currency;
  public
    Scorte: Integer;
    constructor Create(const ACodice: string;
      APrezzo: Currency);
    function Descrizione: string;
  published
    property Codice: string read FCodice;
    property Prezzo: Currency read FPrezzo write FPrezzo;
  end;
  {$M-}

constructor TProdotto.Create(const ACodice: string;
  APrezzo: Currency);
begin
  inherited Create;
  FCodice := ACodice;
  FPrezzo := APrezzo;
end;

function TProdotto.Descrizione: string;
begin
  Result := FCodice + ' a ' + CurrToStr(FPrezzo);
end;

var
  Ctx: TRttiContext;
  T: TRttiType;
  P: TRttiProperty;
  F: TRttiField;
  V: TValue;
  Prod: TProdotto;
begin
  Prod := TProdotto.Create('A100', 19.9);
  Ctx := TRttiContext.Create;
  try
    T := Ctx.GetType(TProdotto);
    WriteLn(T.Name);
    for P in T.GetProperties do
    begin
      V := P.GetValue(Prod);
      WriteLn('prop ', P.Name, ' = ', V.ToString,
        ' scrivibile=', P.IsWritable);
    end;
    for F in T.GetFields do
      WriteLn('campo ', F.Name);
    P := T.GetProperty('Prezzo');
    P.SetValue(Prod, TValue.From<Currency>(24.5));
    WriteLn(Prod.Prezzo:0:2);
    V := TValue.From<Integer>(42);
    WriteLn(V.AsInteger + 1, ' ', V.IsType<Integer>, ' ',
      V.IsType<string>);
  finally
    Ctx.Free;
    Prod.Free;
  end;
end.
