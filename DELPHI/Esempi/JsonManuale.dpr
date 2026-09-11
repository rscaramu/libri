program JsonManuale;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function JsonStringa(const S: string): string;
var
  C: Char;
  SB: TStringBuilder;
begin
  SB := TStringBuilder.Create;
  try
    SB.Append('"');
    for C in S do
      case C of
        '"': SB.Append('\"');
        '\': SB.Append('\\');
        #8: SB.Append('\b');
        #9: SB.Append('\t');
        #10: SB.Append('\n');
        #13: SB.Append('\r');
        #0..#7, #11, #12, #14..#31:
          SB.Append('\u').Append(IntToHex(Ord(C), 4));
      else
        SB.Append(C);
      end;
    SB.Append('"');
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

function JsonNumero(V: Double): string;
var
  FS: TFormatSettings;
begin
  FS := FormatSettings;
  FS.DecimalSeparator := '.';
  Result := FloatToStr(V, FS);
end;

begin
  WriteLn(JsonStringa('Rossi, Bianchi & C.'));
  WriteLn(JsonStringa('dice "ciao"' + #10 + 'e va a capo'));
  WriteLn(JsonStringa('percorso C:\temp'));
  WriteLn('{"cliente":', JsonStringa('Verdi'),
    ',"importo":', JsonNumero(1250.5), ',"ok":true}');
end.
