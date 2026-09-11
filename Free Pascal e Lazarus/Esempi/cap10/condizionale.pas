{ Condizionale - Manuale completo di Free Pascal e Lazarus }
program Condizionale;
{$mode objfpc}{$H+}
{$DEFINE VERBOSO}
begin
  {$IFDEF WINDOWS}
  WriteLn('Sistema: Windows');
  {$ENDIF}
  {$IFDEF UNIX}
  WriteLn('Sistema: Unix');
  {$ENDIF}
  {$IFDEF CPU64}
  WriteLn('Architettura a 64 bit');
  {$ELSE}
  WriteLn('Architettura a 32 bit');
  {$ENDIF}
  {$IFDEF VERBOSO}
  WriteLn('Compilato con FPC ', {$I %FPCVERSION%});
  {$ENDIF}
  {$IF FPC_FULLVERSION >= 30200}
  WriteLn('Almeno la 3.2');
  {$ENDIF}
end.
