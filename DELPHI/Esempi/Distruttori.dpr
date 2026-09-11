program Distruttori;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TRisorsa = class
  private
    FNome: string;
  public
    constructor Create(const ANome: string);
    destructor Destroy; override;
  end;

  TContenitore = class
  private
    FInterna: TRisorsa;
  public
    constructor Create;
    destructor Destroy; override;
  end;

constructor TRisorsa.Create(const ANome: string);
begin
  inherited Create;
  FNome := ANome;
  WriteLn('creo ', FNome);
end;

destructor TRisorsa.Destroy;
begin
  WriteLn('distruggo ', FNome);
  inherited;
end;

constructor TContenitore.Create;
begin
  inherited;
  WriteLn('creo contenitore');
  FInterna := TRisorsa.Create('interna');
end;

destructor TContenitore.Destroy;
begin
  WriteLn('distruggo contenitore');
  FInterna.Free;
  inherited;
end;

var
  C: TContenitore;
begin
  C := TContenitore.Create;
  C.Free;
end.
