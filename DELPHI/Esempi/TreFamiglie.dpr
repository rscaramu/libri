program TreFamiglie;

{$APPTYPE CONSOLE}

type
  TRoutine = procedure(const S: string);
  TMetodo = procedure(const S: string) of object;
  TRiferimento = reference to procedure(const S: string);

  TStampante = class
    Prefisso: string;
    procedure Stampa(const S: string);
  end;

procedure Libera(const S: string);
begin
  WriteLn('libera: ', S);
end;

procedure TStampante.Stampa(const S: string);
begin
  WriteLn(Prefisso, S);
end;

var
  R: TRoutine;
  M: TMetodo;
  F: TRiferimento;
  O: TStampante;
begin
  O := TStampante.Create;
  try
    O.Prefisso := 'metodo: ';
    R := Libera;
    M := O.Stampa;
    R('uno');
    M('due');
    F := Libera;
    F('tre');
    F := O.Stampa;
    F('quattro');
    F := procedure(const S: string)
      begin
        WriteLn('anonimo: ', S);
      end;
    F('cinque');
  finally
    O.Free;
  end;
end.
