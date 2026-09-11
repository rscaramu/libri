program SommaParallela;

{$APPTYPE CONSOLE}

uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  SysUtils, Classes;

type
  TSommaParte = class(TThread)
  private
    FDati: TArray<Integer>;
    FDa, FA: Integer;
  public
    Somma: Int64;
    constructor Create(const ADati: TArray<Integer>;
      ADa, AA: Integer);
    procedure Execute; override;
  end;

constructor TSommaParte.Create(const ADati: TArray<Integer>;
  ADa, AA: Integer);
begin
  inherited Create(True);
  FDati := ADati;
  FDa := ADa;
  FA := AA;
end;

procedure TSommaParte.Execute;
var
  I: Integer;
begin
  Somma := 0;
  for I := FDa to FA do
    Somma := Somma + FDati[I];
end;

const
  N = 1000000;
var
  Dati: TArray<Integer>;
  I: Integer;
  Seq, Par: Int64;
  T: array[0..3] of TSommaParte;
begin
  SetLength(Dati, N);
  for I := 0 to N - 1 do
    Dati[I] := I mod 100;
  Seq := 0;
  for I := 0 to N - 1 do
    Seq := Seq + Dati[I];
  for I := 0 to 3 do
    T[I] := TSommaParte.Create(Dati, I * (N div 4),
      (I + 1) * (N div 4) - 1);
  for I := 0 to 3 do
    T[I].Start;
  Par := 0;
  for I := 0 to 3 do
  begin
    T[I].WaitFor;
    Par := Par + T[I].Somma;
    T[I].Free;
  end;
  WriteLn(Seq, ' ', Par, ' ', Seq = Par);
end.
