{ ProvaMagazzino - Manuale completo di Free Pascal e Lazarus }
program ProvaMagazzino;
{$mode objfpc}{$H+}
uses
  SysUtils, Magazzino;
var
  M: TMagazzino;
begin
  M := TMagazzino.Create;
  try
    M.Aggiungi('V001', 'Vite M4', 0.05);
    M.Aggiungi('D001', 'Dado M4', 0.03);
    M.Carica('V001', 1000);
    M.Carica('D001', 500);
    M.Scarica('V001', 200);
    WriteLn('Viti: ', M.Trova('V001').Giacenza);
    WriteLn('Valore: ', M.ValoreTotale:0:2);
    try
      M.Scarica('D001', 999);
    except
      on E: EMagazzino do
        WriteLn('Rifiutato: ', E.Message);
    end;
  finally
    M.Free;
  end;
end.
