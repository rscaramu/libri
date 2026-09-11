{ Fabbrica - Manuale completo di Free Pascal e Lazarus }
program Fabbrica;
{$mode objfpc}{$H+}
type
  TForma = class
    function Area: Double; virtual; abstract;
  end;
  TFormaClass = class of TForma;

  TRettangolo = class(TForma)
    function Area: Double; override;
  end;

  TQuadrato = class(TForma)
    function Area: Double; override;
  end;

function TRettangolo.Area: Double;
begin
  Result := 6;
end;

function TQuadrato.Area: Double;
begin
  Result := 4;
end;

function ClasseDaNome(const Nome: String): TFormaClass;
begin
  case Nome of
    'rettangolo': Result := TRettangolo;
    'quadrato':   Result := TQuadrato;
  else
    Result := nil;
  end;
end;

var
  Nome: String;
  C: TFormaClass;
  F: TForma;
begin
  for Nome in ['rettangolo', 'quadrato', 'cerchio'] do
  begin
    C := ClasseDaNome(Nome);
    if C = nil then
      WriteLn(Nome, ': sconosciuto')
    else
    begin
      F := C.Create;
      WriteLn(Nome, ' -> ', F.ClassName, ', area ',
              F.Area:0:1);
      F.Free;
    end;
  end;
end.
