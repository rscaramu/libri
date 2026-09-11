{ CostruttoreVirtuale - Manuale completo di Free Pascal e Lazarus }
program CostruttoreVirtuale;
{$mode objfpc}{$H+}
type
  TAnimale = class
  protected
    FNome: String;
  public
    constructor Create(const ANome: String); virtual;
    function Verso: String; virtual;
    property Nome: String read FNome;
  end;
  TAnimaleClass = class of TAnimale;

  TCane = class(TAnimale)
    function Verso: String; override;
  end;

constructor TAnimale.Create(const ANome: String);
begin
  FNome := ANome;
end;

function TAnimale.Verso: String;
begin
  Result := '...';
end;

function TCane.Verso: String;
begin
  Result := 'bau';
end;

function CreaDaNome(Classe: TAnimaleClass;
                    const Nome: String): TAnimale;
begin
  Result := Classe.Create(Nome);
end;

var
  A: TAnimale;
begin
  A := CreaDaNome(TCane, 'Fido');
  WriteLn(A.Nome, ' fa ', A.Verso);
  A.Free;
end.
