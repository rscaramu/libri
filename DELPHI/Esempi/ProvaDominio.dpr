program ProvaDominio;

{$APPTYPE CONSOLE}

uses
  SysUtils, Officina.Dominio;

var
  C: TCliente;
  A1, A2: TArticolo;
  P: TPreventivo;
begin
  C := TCliente.Create(1, ' Rossi Mario ',
    'rossi@example.it');
  A1 := TArticolo.Create('fil01', 'Filtro olio', 12.5, 22);
  A2 := TArticolo.Create('MAN02', 'Manodopera (ora)', 35, 22);
  P := TPreventivo.Create(1001, C, EncodeDate(2026, 3, 15));
  try
    P.Aggiungi(A1, 2);
    P.Aggiungi(A2, 3, 10);
    Write(P.Testo);
    WriteLn(P.Righe.Count, ' ', P.Confermato);
    try
      P.Aggiungi(A1, 0);
    except
      on E: ECommerciale do
        WriteLn('rifiutato: ', E.Message);
    end;
    P.Conferma;
    try
      P.Rimuovi(0);
    except
      on E: ECommerciale do
        WriteLn('rifiutato: ', E.Message);
    end;
    WriteLn(A1.Codice, ' ', C.Nome, '|');
  finally
    P.Free;
    A1.Free;
    A2.Free;
    C.Free;
  end;
end.
