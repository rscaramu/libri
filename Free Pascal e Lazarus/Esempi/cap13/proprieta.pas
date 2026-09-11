{ Proprieta - Manuale completo di Free Pascal e Lazarus }
program Proprieta;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  TRettangolo = class
  private
    FBase, FAltezza: Double;
    procedure SetBase(V: Double);
    procedure SetAltezza(V: Double);
    function GetArea: Double;
    function GetLato(Indice: Integer): Double;
  public
    property Base: Double read FBase write SetBase;
    property Altezza: Double read FAltezza write SetAltezza;
    property Area: Double read GetArea;
    property Lato[I: Integer]: Double read GetLato; default;
  end;

procedure TRettangolo.SetBase(V: Double);
begin
  if V < 0 then
    raise EArgumentException.Create('Base negativa');
  FBase := V;
end;

procedure TRettangolo.SetAltezza(V: Double);
begin
  if V < 0 then
    raise EArgumentException.Create('Altezza negativa');
  FAltezza := V;
end;

function TRettangolo.GetArea: Double;
begin
  Result := FBase * FAltezza;
end;

function TRettangolo.GetLato(Indice: Integer): Double;
begin
  case Indice of
    0: Result := FBase;
    1: Result := FAltezza;
  else
    raise ERangeError.Create('Indice non valido');
  end;
end;

var
  R: TRettangolo;
begin
  R := TRettangolo.Create;
  try
    R.Base := 3;
    R.Altezza := 4;
    WriteLn('Area: ', R.Area:0:1);
    WriteLn('Lati: ', R.Lato[0]:0:1, ' ', R[1]:0:1);
    try
      R.Base := -1;
    except
      on E: Exception do
        WriteLn('Rifiutato: ', E.Message);
    end;
    WriteLn('Base ancora ', R.Base:0:1);
  finally
    R.Free;
  end;
end.
