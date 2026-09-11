program Operazioni;

{$APPTYPE CONSOLE}

type
  TOperazione = class
    function Esegui(A, B: Double): Double; virtual; abstract;
    function Simbolo: string; virtual; abstract;
  end;
  TOperazioneClass = class of TOperazione;
  TSomma = class(TOperazione)
    function Esegui(A, B: Double): Double; override;
    function Simbolo: string; override;
  end;
  TSottrazione = class(TOperazione)
    function Esegui(A, B: Double): Double; override;
    function Simbolo: string; override;
  end;
  TProdotto = class(TOperazione)
    function Esegui(A, B: Double): Double; override;
    function Simbolo: string; override;
  end;
  TDivisione = class(TOperazione)
    function Esegui(A, B: Double): Double; override;
    function Simbolo: string; override;
  end;

function TSomma.Esegui(A, B: Double): Double;
begin Result := A + B; end;
function TSomma.Simbolo: string;
begin Result := '+'; end;
function TSottrazione.Esegui(A, B: Double): Double;
begin Result := A - B; end;
function TSottrazione.Simbolo: string;
begin Result := '-'; end;
function TProdotto.Esegui(A, B: Double): Double;
begin Result := A * B; end;
function TProdotto.Simbolo: string;
begin Result := '*'; end;
function TDivisione.Esegui(A, B: Double): Double;
begin Result := A / B; end;
function TDivisione.Simbolo: string;
begin Result := '/'; end;

const
  Classi: array[0..3] of TOperazioneClass =
    (TSomma, TSottrazione, TProdotto, TDivisione);
var
  C: TOperazioneClass;
  O: TOperazione;
begin
  for C in Classi do
  begin
    O := C.Create;
    try
      WriteLn('8 ', O.Simbolo, ' 2 = ', O.Esegui(8, 2):0:1);
    finally
      O.Free;
    end;
  end;
end.
