program Elenco;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TCriterio<T> = reference to function(const X: T): Boolean;
  TSelettore<T> = reference to function(const X: T): Double;

  TElenco<T> = class
  private
    FDati: TArray<T>;
  public
    procedure Aggiungi(const X: T);
    function Trova(Criterio: TCriterio<T>): TArray<T>;
    function Conta(Criterio: TCriterio<T>): Integer;
    function Somma(Selettore: TSelettore<T>): Double;
  end;

  TCliente = record
    Nome: string;
    Citta: string;
    Saldo: Double;
  end;

procedure TElenco<T>.Aggiungi(const X: T);
begin
  FDati := FDati + [X];
end;

function TElenco<T>.Trova(Criterio: TCriterio<T>): TArray<T>;
var
  X: T;
begin
  Result := nil;
  for X in FDati do
    if Criterio(X) then
      Result := Result + [X];
end;

function TElenco<T>.Conta(Criterio: TCriterio<T>): Integer;
begin
  Result := Length(Trova(Criterio));
end;

function TElenco<T>.Somma(Selettore: TSelettore<T>): Double;
var
  X: T;
begin
  Result := 0;
  for X in FDati do
    Result := Result + Selettore(X);
end;

function C(const N, Ci: string; S: Double): TCliente;
begin
  Result.Nome := N;
  Result.Citta := Ci;
  Result.Saldo := S;
end;

var
  E: TElenco<TCliente>;
  X: TCliente;
  Citta: string;
begin
  E := TElenco<TCliente>.Create;
  try
    E.Aggiungi(C('Rossi', 'Roma', 120));
    E.Aggiungi(C('Verdi', 'Milano', -30));
    E.Aggiungi(C('Bianchi', 'Roma', 75));
    Citta := 'Roma';
    for X in E.Trova(
        function(const K: TCliente): Boolean
        begin
          Result := K.Citta = Citta;
        end) do
      Write(X.Nome, ' ');
    WriteLn;
    WriteLn(E.Conta(
      function(const K: TCliente): Boolean
      begin
        Result := K.Saldo > 0;
      end));
    WriteLn(E.Somma(
      function(const K: TCliente): Double
      begin
        Result := K.Saldo;
      end):0:1);
  finally
    E.Free;
  end;
end.
