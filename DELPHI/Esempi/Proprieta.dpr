program Proprieta;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TRettangolo = class
  private
    FBase, FAltezza: Double;
    procedure SetBase(const Value: Double);
    function GetArea: Double;
  public
    property Base: Double read FBase write SetBase;
    property Altezza: Double read FAltezza write FAltezza;
    property Area: Double read GetArea;
  end;

procedure TRettangolo.SetBase(const Value: Double);
begin
  if Value < 0 then
    raise EArgumentException.Create('base negativa');
  FBase := Value;
end;

function TRettangolo.GetArea: Double;
begin
  Result := FBase * FAltezza;
end;

var
  R: TRettangolo;
begin
  R := TRettangolo.Create;
  try
    R.Base := 3;
    R.Altezza := 4;
    WriteLn(R.Area:0:1);
    try
      R.Base := -1;
    except
      on E: EArgumentException do
        WriteLn('rifiutato: ', E.Message);
    end;
    WriteLn(R.Base:0:1);
  finally
    R.Free;
  end;
end.
