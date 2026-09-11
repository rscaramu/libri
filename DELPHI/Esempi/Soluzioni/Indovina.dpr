program Indovina;

{$APPTYPE CONSOLE}

const
  Segreto = 42;
var
  Tentativo, Conteggio: Integer;
begin
  { stdin: 50\n25\n42\n }
  Conteggio := 0;
  repeat
    ReadLn(Tentativo);
    Inc(Conteggio);
    if Tentativo > Segreto then
      WriteLn('troppo alto')
    else if Tentativo < Segreto then
      WriteLn('troppo basso')
    else
      WriteLn('indovinato in ', Conteggio, ' tentativi');
  until Tentativo = Segreto;
end.
