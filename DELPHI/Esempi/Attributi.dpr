program Attributi;

{$APPTYPE CONSOLE}

uses
  SysUtils, Rtti;

type
  ColonnaAttribute = class(TCustomAttribute)
  private
    FNome: string;
    FLarghezza: Integer;
  public
    constructor Create(const ANome: string;
      ALarghezza: Integer);
    property Nome: string read FNome;
    property Larghezza: Integer read FLarghezza;
  end;

  ObbligatorioAttribute = class(TCustomAttribute)
  public
    constructor Create;
  end;

  {$M+}
  TCliente = class
  private
    FNome: string;
    FCitta: string;
    FEta: Integer;
  published
    [Colonna('nome_cliente', 30)]
    [Obbligatorio]
    property Nome: string read FNome write FNome;
    [Colonna('citta', 20)]
    property Citta: string read FCitta write FCitta;
    [Colonna('eta', 5)]
    [Obbligatorio]
    property Eta: Integer read FEta write FEta;
  end;
  {$M-}

constructor ColonnaAttribute.Create(const ANome: string;
  ALarghezza: Integer);
begin
  inherited Create;
  FNome := ANome;
  FLarghezza := ALarghezza;
end;

constructor ObbligatorioAttribute.Create;
begin
  inherited Create;
end;

procedure StampaSchema(Classe: TClass);
var
  Ctx: TRttiContext;
  P: TRttiProperty;
  A: TCustomAttribute;
  Obbl: Boolean;
begin
  Ctx := TRttiContext.Create;
  try
    for P in Ctx.GetType(Classe).GetProperties do
    begin
      Obbl := False;
      for A in P.GetAttributes do
        if A is ObbligatorioAttribute then
          Obbl := True;
      for A in P.GetAttributes do
        if A is ColonnaAttribute then
          WriteLn(P.Name:8, ' -> ',
            ColonnaAttribute(A).Nome:14,
            ColonnaAttribute(A).Larghezza:3, ' ', Obbl);
    end;
  finally
    Ctx.Free;
  end;
end;

begin
  StampaSchema(TCliente);
end.
