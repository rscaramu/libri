{ AssignDemo - Manuale completo di Free Pascal e Lazarus }
program AssignDemo;
{$mode objfpc}{$H+}
uses
  Classes, SysUtils;
type
  TIndirizzo = class(TPersistent)
  private
    FVia, FCitta: String;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Via: String read FVia write FVia;
    property Citta: String read FCitta write FCitta;
  end;

procedure TIndirizzo.Assign(Source: TPersistent);
begin
  if Source is TIndirizzo then
  begin
    FVia := TIndirizzo(Source).FVia;
    FCitta := TIndirizzo(Source).FCitta;
  end
  else
    inherited Assign(Source);  { solleva EConvertError }
end;

var
  A, B: TIndirizzo;
begin
  A := TIndirizzo.Create;
  B := TIndirizzo.Create;
  try
    A.Via := 'Via Roma 1';
    A.Citta := 'Torino';
    B.Assign(A);
    A.Via := 'Corso Italia 5';
    WriteLn(B.Via, ', ', B.Citta);
    WriteLn(A.Via, ', ', A.Citta);
    try
      B.Assign(TStringList.Create);
    except
      on E: Exception do
        WriteLn(E.ClassName, ': ', E.Message);
    end;
  finally
    A.Free;
    B.Free;
  end;
end.
