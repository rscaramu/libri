program ScriviLog;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

function JsonStringa(const S: string): string;
var
  C: Char;
begin
  Result := '"';
  for C in S do
    case C of
      '"': Result := Result + '\"';
      '\': Result := Result + '\\';
      #10: Result := Result + '\n';
      #13: Result := Result + '\r';
      #9: Result := Result + '\t';
      #0..#8, #11, #12, #14..#31:
        Result := Result + '\u' + IntToHex(Ord(C), 4);
    else
      Result := Result + C;
    end;
  Result := Result + '"';
end;

function JsonNumero(V: Double): string;
var
  FS: TFormatSettings;
begin
  FS := FormatSettings;
  FS.DecimalSeparator := '.';
  Result := FloatToStr(V, FS);
end;

procedure ScriviLog(const Evento: string; Valore: Double;
  Ok: Boolean);
var
  SL: TStringList;
const
  Bool: array[Boolean] of string = ('false', 'true');
begin
  SL := TStringList.Create;
  try
    if FileExists('log.json') then
      SL.LoadFromFile('log.json');
    SL.Add('{"evento":' + JsonStringa(Evento) + ',"valore":' +
      JsonNumero(Valore) + ',"ok":' + Bool[Ok] + '}');
    SL.SaveToFile('log.json');
  finally
    SL.Free;
  end;
end;

var
  SL: TStringList;
begin
  DeleteFile('log.json');
  ScriviLog('avvio', 1.5, True);
  ScriviLog('errore "grave"', -2, False);
  SL := TStringList.Create;
  try
    SL.LoadFromFile('log.json');
    Write(SL.Text);
  finally
    SL.Free;
    DeleteFile('log.json');
  end;
end.
