program SelfEsempio;

{$APPTYPE CONSOLE}

type
  TCostruttore = class
  private
    FTesto: string;
  public
    function Aggiungi(const S: string): TCostruttore;
    property Testo: string read FTesto;
  end;

function TCostruttore.Aggiungi(const S: string): TCostruttore;
begin
  FTesto := FTesto + S;
  Result := Self;
end;

var
  C: TCostruttore;
begin
  C := TCostruttore.Create;
  try
    WriteLn(C.Aggiungi('a').Aggiungi('b').Aggiungi('c')
      .Testo);
  finally
    C.Free;
  end;
end.
