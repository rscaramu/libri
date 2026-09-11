{ AssignProfondo - Manuale completo di Free Pascal e Lazarus }
program AssignProfondo;
{$mode objfpc}{$H+}
uses
  Classes, SysUtils;
type
  TIndirizzo = class(TPersistent)
  private
    FCitta: String;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Citta: String read FCitta write FCitta;
  end;

  TOrdine = class(TPersistent)
  private
    FRighe: TStringList;
    FIndirizzo: TIndirizzo;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Righe: TStringList read FRighe;
    property Indirizzo: TIndirizzo read FIndirizzo;
  end;

procedure TIndirizzo.Assign(Source: TPersistent);
begin
  if Source is TIndirizzo then
    FCitta := TIndirizzo(Source).FCitta
  else
    inherited;
end;

constructor TOrdine.Create;
begin
  FRighe := TStringList.Create;
  FIndirizzo := TIndirizzo.Create;
end;

destructor TOrdine.Destroy;
begin
  FIndirizzo.Free;
  FRighe.Free;
  inherited;
end;

procedure TOrdine.Assign(Source: TPersistent);
begin
  if Source is TOrdine then
  begin
    FRighe.Assign(TOrdine(Source).FRighe);
    FIndirizzo.Assign(TOrdine(Source).FIndirizzo);
  end
  else
    inherited;
end;

var
  A, B: TOrdine;
begin
  A := TOrdine.Create;
  B := TOrdine.Create;
  try
    A.Righe.Add('vite x 10');
    A.Righe.Add('dado x 10');
    A.Indirizzo.Citta := 'Bari';
    B.Assign(A);
    A.Righe.Clear;
    A.Indirizzo.Citta := 'Lecce';
    WriteLn(B.Righe.Count, ' righe, ', B.Indirizzo.Citta);
    WriteLn(A.Righe.Count, ' righe, ', A.Indirizzo.Citta);
  finally
    A.Free;
    B.Free;
  end;
end.
