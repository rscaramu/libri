program Metaclassi;

{$APPTYPE CONSOLE}

type
  TForma = class
  public
    constructor Create; virtual;
    function Nome: string; virtual;
  end;
  TFormaClass = class of TForma;

  TCerchio = class(TForma)
    function Nome: string; override;
  end;

  TQuadrato = class(TForma)
    function Nome: string; override;
  end;

constructor TForma.Create;
begin
  inherited;
end;

function TForma.Nome: string;
begin
  Result := 'forma';
end;

function TCerchio.Nome: string;
begin
  Result := 'cerchio';
end;

function TQuadrato.Nome: string;
begin
  Result := 'quadrato';
end;

function Fabbrica(Classe: TFormaClass): TForma;
begin
  Result := Classe.Create;
end;

var
  Classi: array[0..2] of TFormaClass;
  C: TFormaClass;
  F: TForma;
begin
  Classi[0] := TCerchio;
  Classi[1] := TQuadrato;
  Classi[2] := TForma;
  for C in Classi do
  begin
    F := Fabbrica(C);
    try
      WriteLn(C.ClassName, ' -> ', F.Nome);
    finally
      F.Free;
    end;
  end;
end.
