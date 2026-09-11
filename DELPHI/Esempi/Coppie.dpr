program Coppie;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TCoppia<TChiave, TValore> = record
    Chiave: TChiave;
    Valore: TValore;
    constructor Create(const AChiave: TChiave;
      const AValore: TValore);
    function Testo: string;
  end;

constructor TCoppia<TChiave, TValore>.Create(
  const AChiave: TChiave; const AValore: TValore);
begin
  Chiave := AChiave;
  Valore := AValore;
end;

function TCoppia<TChiave, TValore>.Testo: string;
begin
  Result := 'coppia';
end;

var
  C: TCoppia<string, Integer>;
  D: TCoppia<Byte, Byte>;
begin
  C := TCoppia<string, Integer>.Create('eta', 30);
  D := TCoppia<Byte, Byte>.Create(1, 2);
  WriteLn(C.Chiave, '=', C.Valore, ' ', C.Testo);
  WriteLn(D.Chiave, '=', D.Valore);
  WriteLn(SizeOf(C), ' ', SizeOf(D));
end.
