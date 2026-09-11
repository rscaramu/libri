{ MassimoParallelo - Manuale completo di Free Pascal e Lazarus }
program MassimoParallelo;
{$mode objfpc}{$H+}
uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  SysUtils, Classes;
type
  TInteri = array of Integer;
  TCercaMax = class(TThread)
  private
    FDati: TInteri;
    FDa, FA: Integer;
    FMax: Integer;
  protected
    procedure Execute; override;
  public
    constructor Create(const ADati: TInteri;
                       ADa, AA: Integer);
    property Max: Integer read FMax;
  end;

constructor TCercaMax.Create(const ADati: TInteri;
                             ADa, AA: Integer);
begin
  inherited Create(True);
  FDati := ADati;             { stesso array, sola lettura }
  FDa := ADa;
  FA := AA;
end;

procedure TCercaMax.Execute;
var
  I: Integer;
begin
  FMax := FDati[FDa];
  for I := FDa + 1 to FA do
    if FDati[I] > FMax then
      FMax := FDati[I];
end;

const
  N = 4000000;
  NThread = 4;
var
  Dati: TInteri;
  T: array[0..NThread - 1] of TCercaMax;
  I, Blocco, Massimo: Integer;
begin
  SetLength(Dati, N);
  RandSeed := 42;
  for I := 0 to N - 1 do
    Dati[I] := Random(1000000);
  Dati[N div 3] := 1000001;     { il massimo, nascosto }
  Blocco := N div NThread;
  for I := 0 to NThread - 1 do
    T[I] := TCercaMax.Create(Dati, I * Blocco,
                             (I + 1) * Blocco - 1);
  for I := 0 to NThread - 1 do
    T[I].Start;
  Massimo := 0;
  for I := 0 to NThread - 1 do
  begin
    T[I].WaitFor;
    if T[I].Max > Massimo then
      Massimo := T[I].Max;
    T[I].Free;
  end;
  WriteLn('Massimo: ', Massimo);
end.
