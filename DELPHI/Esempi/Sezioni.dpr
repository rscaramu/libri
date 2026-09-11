program Sezioni;

{$APPTYPE CONSOLE}

const
  Pi2 = 6.283185;

type
  TMetri = Double;

var
  Raggio: TMetri;

const
  Messaggio = 'Circonferenza: ';

var
  Circonferenza: TMetri;

begin
  Raggio := 2.5;
  Circonferenza := Pi2 * Raggio;
  WriteLn(Messaggio, Circonferenza:0:3);
end.
