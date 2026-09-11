program Costanti;

{$APPTYPE CONSOLE}

const
  Iva = 0.22;
  Massimo = 100;
  Titolo = 'Riepilogo';
  Debug = False;
  RigheMax = Massimo * 2;

begin
  WriteLn(Titolo, ': ', RigheMax, ' righe, IVA ',
    Iva * 100:0:0, '%');
  WriteLn('Debug: ', Debug);
end.
