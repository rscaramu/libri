program Descrizioni;

{$APPTYPE CONSOLE}

uses
  SysUtils, Rtti;

type
  DescrizioneAttribute = class(TCustomAttribute)
  private
    FTesto: string;
  public
    constructor Create(const ATesto: string);
    property Testo: string read FTesto;
  end;

  {$M+}
  TServer = class
  private
    FHost: string;
    FPorta: Integer;
    FNote: string;
  published
    [Descrizione('nome o indirizzo del server')]
    property Host: string read FHost write FHost;
    [Descrizione('porta TCP')]
    property Porta: Integer read FPorta write FPorta;
    property Note: string read FNote write FNote;
  end;
  {$M-}

constructor DescrizioneAttribute.Create(const ATesto: string);
begin
  inherited Create;
  FTesto := ATesto;
end;

procedure Stampa(Classe: TClass);
var
  Ctx: TRttiContext;
  P: TRttiProperty;
  A: TCustomAttribute;
  D: string;
begin
  Ctx := TRttiContext.Create;
  try
    for P in Ctx.GetType(Classe).GetProperties do
    begin
      D := '-';
      for A in P.GetAttributes do
        if A is DescrizioneAttribute then
          D := DescrizioneAttribute(A).Testo;
      WriteLn(P.Name, ': ', D);
    end;
  finally
    Ctx.Free;
  end;
end;

begin
  Stampa(TServer);
end.
