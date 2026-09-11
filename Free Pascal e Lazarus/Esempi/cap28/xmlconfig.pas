{ XmlConfig - Manuale completo di Free Pascal e Lazarus }
program XmlConfig;
{$mode objfpc}{$H+}
uses
  SysUtils, XMLConf;
var
  Cfg: TXMLConfig;
begin
  DeleteFile('app.xml');
  Cfg := TXMLConfig.Create(nil);
  try
    Cfg.Filename := 'app.xml';
    Cfg.SetValue('finestra/larghezza', 1024);
    Cfg.SetValue('finestra/massimizzata', True);
    Cfg.SetValue('utente/nome', 'anna');
    Cfg.Flush;
    WriteLn('Larghezza: ',
            Cfg.GetValue('finestra/larghezza', 0));
    WriteLn('Altezza: ',
            Cfg.GetValue('finestra/altezza', 768));
    WriteLn('Nome: ', Cfg.GetValue('utente/nome', ''));
  finally
    Cfg.Free;
  end;
end.
