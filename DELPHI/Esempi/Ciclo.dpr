program Ciclo;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  INodo = interface
    procedure SetAltro(const A: INodo);
  end;

  TNodo = class(TInterfacedObject, INodo)
  private
    FNome: string;
    FAltro: INodo;
  public
    constructor Create(const ANome: string);
    destructor Destroy; override;
    procedure SetAltro(const A: INodo);
  end;

constructor TNodo.Create(const ANome: string);
begin
  inherited Create;
  FNome := ANome;
end;

destructor TNodo.Destroy;
begin
  WriteLn('distruggo ', FNome);
  inherited;
end;

procedure TNodo.SetAltro(const A: INodo);
begin
  FAltro := A;
end;

procedure SenzaCiclo;
var
  A: INodo;
begin
  A := TNodo.Create('solo');
end;

procedure ConCiclo;
var
  A, B: INodo;
begin
  A := TNodo.Create('primo');
  B := TNodo.Create('secondo');
  A.SetAltro(B);
  B.SetAltro(A);
end;

procedure CicloRotto;
var
  A, B: INodo;
begin
  A := TNodo.Create('terzo');
  B := TNodo.Create('quarto');
  A.SetAltro(B);
  B.SetAltro(A);
  A.SetAltro(nil);
  B := nil;
  A := nil;
end;

begin
  SenzaCiclo;
  WriteLn('--');
  ConCiclo;
  WriteLn('--');
  CicloRotto;
  WriteLn('fine');
end.
