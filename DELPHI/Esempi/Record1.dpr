program Record1;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TData = record
    Giorno, Mese, Anno: Integer;
  end;

  TPersona = record
    Nome, Cognome: string;
    Nascita: TData;
    Attiva: Boolean;
  end;

var
  P, Q: TPersona;
begin
  P.Nome := 'Anna';
  P.Cognome := 'Bianchi';
  P.Nascita.Giorno := 3;
  P.Nascita.Mese := 7;
  P.Nascita.Anno := 1990;
  P.Attiva := True;
  Q := P;
  Q.Nome := 'Marco';
  WriteLn(P.Nome, ' ', Q.Nome);
  with Q.Nascita do
    WriteLn(Format('%d/%d/%d', [Giorno, Mese, Anno]));
  WriteLn(SizeOf(TData));
end.
