{ Ciclo155 - Manuale completo di Free Pascal e Lazarus }
program Ciclo155;
{$mode objfpc}{$H+}
type
  IAmico = interface
    ['{7F1A2B3C-0005-4000-8000-000000000005}']
    procedure Collega(A: IAmico);
    procedure Scollega;
  end;

  TPersona = class(TInterfacedObject, IAmico)
  private
    FNome: String;
    FAmico: IAmico;
  public
    constructor Create(const ANome: String);
    destructor Destroy; override;
    procedure Collega(A: IAmico);
    procedure Scollega;
  end;

constructor TPersona.Create(const ANome: String);
begin
  FNome := ANome;
end;

destructor TPersona.Destroy;
begin
  WriteLn('  distrutto ', FNome);
  inherited;
end;

procedure TPersona.Collega(A: IAmico);
begin
  FAmico := A;
end;

procedure TPersona.Scollega;
begin
  FAmico := nil;
end;

procedure Prova(Rompi: Boolean);
var
  A, B: IAmico;
begin
  A := TPersona.Create('A');
  B := TPersona.Create('B');
  A.Collega(B);
  B.Collega(A);
  if Rompi then
    A.Scollega;
end;

begin
  WriteLn('Con ciclo:');
  Prova(False);
  WriteLn('Senza ciclo:');
  Prova(True);
end.
