program Rami;

{$APPTYPE CONSOLE}

uses
  SysUtils;

procedure Prova(const S: string);
var
  N: Integer;
  A: array of Integer;
begin
  try
    if S = 'conv' then
      N := StrToInt('abc')
    else if S = 'range' then
    begin
      SetLength(A, 2);
      {$R+}
      N := A[Length(S)];
      {$R-}
    end
    else if S = 'nil' then
      N := TObject(nil).InstanceSize
    else
      N := Length(S);
    WriteLn(S, ': ok ', N);
  except
    on E: EConvertError do
      WriteLn(S, ': conversione');
    on E: ERangeError do
      WriteLn(S, ': indice');
    on E: Exception do
      WriteLn(S, ': ', E.ClassName);
  end;
end;

begin
  Prova('conv');
  Prova('range');
  Prova('nil');
  Prova('bene');
end.
