program InterfacceGeneriche;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  IContenitore<T> = interface
    procedure Aggiungi(const V: T);
    function Count: Integer;
    function Elemento(I: Integer): T;
  end;

  TContenitore<T> = class(TInterfacedObject, IContenitore<T>)
  private
    FDati: TArray<T>;
  public
    procedure Aggiungi(const V: T);
    function Count: Integer;
    function Elemento(I: Integer): T;
  end;

  TContenitoreStringhe = class(TContenitore<string>)
    function Tutti: string;
  end;

procedure TContenitore<T>.Aggiungi(const V: T);
begin
  FDati := FDati + [V];
end;

function TContenitore<T>.Count: Integer;
begin
  Result := Length(FDati);
end;

function TContenitore<T>.Elemento(I: Integer): T;
begin
  Result := FDati[I];
end;

function TContenitoreStringhe.Tutti: string;
begin
  Result := string.Join(',', FDati);
end;

var
  C: IContenitore<Integer>;
  S: TContenitoreStringhe;
begin
  C := TContenitore<Integer>.Create;
  C.Aggiungi(10);
  C.Aggiungi(20);
  WriteLn(C.Count, ' ', C.Elemento(1));
  S := TContenitoreStringhe.Create;
  try
    S.Aggiungi('a');
    S.Aggiungi('b');
    WriteLn(S.Tutti);
  finally
    S.Free;
  end;
end.
