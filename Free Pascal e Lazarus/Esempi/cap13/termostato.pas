{ Termostato - Manuale completo di Free Pascal e Lazarus }
program Termostato;
{$mode objfpc}{$H+}
uses
  Classes;
type
  TTermostato = class
  private
    FTemperatura: Double;
    FOnCambio: TNotifyEvent;
    procedure SetTemperatura(V: Double);
  public
    property Temperatura: Double read FTemperatura
                                 write SetTemperatura;
    property OnCambio: TNotifyEvent read FOnCambio
                                    write FOnCambio;
  end;

  TDisplay = class
    procedure Mostra(Sender: TObject);
  end;

procedure TTermostato.SetTemperatura(V: Double);
begin
  if V = FTemperatura then
    Exit;
  FTemperatura := V;
  if Assigned(FOnCambio) then
    FOnCambio(Self);
end;

procedure TDisplay.Mostra(Sender: TObject);
begin
  WriteLn('Display: ',
          (Sender as TTermostato).Temperatura:0:1, ' gradi');
end;

var
  T: TTermostato;
  D: TDisplay;
begin
  T := TTermostato.Create;
  D := TDisplay.Create;
  try
    T.OnCambio := @D.Mostra;
    T.Temperatura := 20;
    T.Temperatura := 20;    { nessun evento }
    T.Temperatura := 21.5;
  finally
    D.Free;
    T.Free;
  end;
end.
