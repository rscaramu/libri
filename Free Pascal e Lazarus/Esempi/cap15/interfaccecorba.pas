{ InterfacceCorba - Manuale completo di Free Pascal e Lazarus }
program InterfacceCorba;
{$mode objfpc}{$H+}
{$interfaces corba}
type
  IMotore = interface
    procedure Avvia;
  end;

  TMotoreDiesel = class(TObject, IMotore)
    procedure Avvia;
  end;

procedure TMotoreDiesel.Avvia;
begin
  WriteLn('brum');
end;

var
  M: TMotoreDiesel;
  I: IMotore;
begin
  M := TMotoreDiesel.Create;
  I := M;              { nessun conteggio }
  I.Avvia;
  M.Free;              { liberazione manuale, come sempre }
end.
