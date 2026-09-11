{ Distruttori - Manuale completo di Free Pascal e Lazarus }
program Distruttori;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  TMotore = class
  private
    FCilindrata: Integer;
  public
    constructor Create(ACilindrata: Integer);
    destructor Destroy; override;
    property Cilindrata: Integer read FCilindrata;
  end;

  TAuto = class
  private
    FNome: String;
    FMotore: TMotore;
  public
    constructor Create(const ANome: String;
                       ACilindrata: Integer);
    destructor Destroy; override;
    function Descrizione: String;
  end;

constructor TMotore.Create(ACilindrata: Integer);
begin
  inherited Create;
  FCilindrata := ACilindrata;
  WriteLn('  motore ', FCilindrata, ' creato');
end;

destructor TMotore.Destroy;
begin
  WriteLn('  motore ', FCilindrata, ' distrutto');
  inherited Destroy;
end;

constructor TAuto.Create(const ANome: String;
                         ACilindrata: Integer);
begin
  inherited Create;
  FNome := ANome;
  FMotore := TMotore.Create(ACilindrata);   { posseduto }
  WriteLn('auto ', FNome, ' creata');
end;

destructor TAuto.Destroy;
begin
  WriteLn('auto ', FNome, ' in distruzione');
  FMotore.Free;                             { liberato qui }
  inherited Destroy;
end;

function TAuto.Descrizione: String;
begin
  Result := Format('%s, %d cc', [FNome, FMotore.Cilindrata]);
end;

var
  A: TAuto;
begin
  A := TAuto.Create('Panda', 1200);
  try
    WriteLn(A.Descrizione);
  finally
    A.Free;
  end;
  WriteLn('fine');
end.
