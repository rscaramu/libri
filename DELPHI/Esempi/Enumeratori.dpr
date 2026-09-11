program Enumeratori;

{$APPTYPE CONSOLE}

uses
  SysUtils, Generics.Collections;

type
  TIntervallo = class
  private
    FDa, FA: Integer;
  public
    constructor Create(ADa, AA: Integer);
    function GetEnumerator: TEnumerator<Integer>;
  end;

  TIntervalloEnum = class(TEnumerator<Integer>)
  private
    FCorrente, FFine: Integer;
  protected
    function DoGetCurrent: Integer; override;
    function DoMoveNext: Boolean; override;
  public
    constructor Create(ADa, AA: Integer);
  end;

constructor TIntervallo.Create(ADa, AA: Integer);
begin
  inherited Create;
  FDa := ADa;
  FA := AA;
end;

function TIntervallo.GetEnumerator: TEnumerator<Integer>;
begin
  Result := TIntervalloEnum.Create(FDa, FA);
end;

constructor TIntervalloEnum.Create(ADa, AA: Integer);
begin
  inherited Create;
  FCorrente := ADa - 1;
  FFine := AA;
end;

function TIntervalloEnum.DoGetCurrent: Integer;
begin
  Result := FCorrente;
end;

function TIntervalloEnum.DoMoveNext: Boolean;
begin
  Inc(FCorrente);
  Result := FCorrente <= FFine;
end;

var
  R: TIntervallo;
  I, Somma: Integer;
begin
  R := TIntervallo.Create(1, 5);
  try
    Somma := 0;
    for I in R do
      Somma := Somma + I;
    WriteLn(Somma);
  finally
    R.Free;
  end;
end.
