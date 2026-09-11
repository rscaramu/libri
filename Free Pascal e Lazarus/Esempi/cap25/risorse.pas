{ Risorse - Manuale completo di Free Pascal e Lazarus }
program Risorse;
{$mode objfpc}{$H+}
uses
  SysUtils;

resourcestring
  SBenvenuto = 'Benvenuti in %s';
  SFileSalvato = 'File salvato';
  SConferma = 'Confermare l''operazione?';

begin
  WriteLn(Format(SBenvenuto, ['Lazarus']));
  WriteLn(SFileSalvato);
  WriteLn(SConferma);
end.
