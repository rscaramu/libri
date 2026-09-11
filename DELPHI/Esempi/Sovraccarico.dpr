program Sovraccarico;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function Descrivi(N: Integer): string; overload;
begin
  Result := 'intero ' + IntToStr(N);
end;

function Descrivi(X: Double): string; overload;
begin
  Result := 'reale ' + FloatToStr(X);
end;

function Descrivi(const S: string): string; overload;
begin
  Result := 'stringa "' + S + '"';
end;

begin
  WriteLn(Descrivi(7));
  WriteLn(Descrivi(2.5));
  WriteLn(Descrivi('ciao'));
end.
