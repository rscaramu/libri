{ UnitProprieta - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit UnitProprieta;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls,
  XMLPropStorage, Dialogs;

type
  TFormProprieta = class(TForm)
    AppProps: TApplicationProperties;
    Storage: TXMLPropStorage;
    Memo: TMemo;
    BtnErrore: TButton;
    procedure AppPropsDropFiles(Sender: TObject;
      const FileNames: array of String);
    procedure AppPropsException(Sender: TObject;
      E: Exception);
    procedure BtnErroreClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var
  FormProprieta: TFormProprieta;

implementation

{$R *.lfm}

procedure TFormProprieta.FormCreate(Sender: TObject);
begin
  AllowDropFiles := True;      { proprieta' del form }
  Storage.FileName := GetAppConfigDir(False) + 'finestra.xml';
  ForceDirectories(ExtractFilePath(Storage.FileName));
  SessionProperties := 'Left;Top;Width;Height';
end;

procedure TFormProprieta.AppPropsDropFiles(Sender: TObject;
  const FileNames: array of String);
var
  F: String;
begin
  for F in FileNames do
    Memo.Lines.Add('Ricevuto: ' + F);
end;

procedure TFormProprieta.AppPropsException(Sender: TObject;
  E: Exception);
begin
  Memo.Lines.Add('ERRORE: ' + E.ClassName + ': ' + E.Message);
  MessageDlg('Si e'' verificato un errore: ' + E.Message,
             mtError, [mbOk], 0);
end;

procedure TFormProprieta.BtnErroreClick(Sender: TObject);
begin
  raise Exception.Create('errore di prova');
end;

end.
