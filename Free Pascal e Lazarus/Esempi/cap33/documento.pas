{ Documento - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit Documento;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Controls, ComCtrls, Graphics, SynEdit,
  SynHighlighterPas, SynHighlighterCpp, SynHighlighterPython,
  SynHighlighterHTML, SynHighlighterJScript,
  SynHighlighterSQL, SynHighlighterXML, SynEditHighlighter,
  SynEditTypes;

type
  TDocumento = class
  private
    FScheda: TTabSheet;
    FEditor: TSynEdit;
    FNomeFile: String;
    FHighlighter: TSynCustomHighlighter;
    FOnStato: TNotifyEvent;
    procedure EditorChange(Sender: TObject);
    procedure EditorStatusChange(Sender: TObject;
                                 Changes: TSynStatusChanges);
    procedure ScegliHighlighter;
    function GetModificato: Boolean;
    function GetTitolo: String;
  public
    constructor Create(PC: TPageControl);
    destructor Destroy; override;
    procedure Carica(const NomeFile: String);
    procedure Salva(const NomeFile: String = '');
    property Editor: TSynEdit read FEditor;
    property Scheda: TTabSheet read FScheda;
    property NomeFile: String read FNomeFile;
    property Modificato: Boolean read GetModificato;
    property Titolo: String read GetTitolo;
    property OnStato: TNotifyEvent read FOnStato
                                   write FOnStato;
  end;

implementation

constructor TDocumento.Create(PC: TPageControl);
begin
  FScheda := TTabSheet.Create(PC);
  FScheda.PageControl := PC;
  FScheda.Tag := PtrInt(Self);   { per risalire dalla scheda }
  FEditor := TSynEdit.Create(FScheda);
  FEditor.Parent := FScheda;
  FEditor.Align := alClient;
  FEditor.Font.Name := 'Monospace';
  FEditor.Font.Size := 11;
  FEditor.Options := FEditor.Options +
    [eoAutoIndent, eoTabsToSpaces, eoTrimTrailingSpaces,
     eoBracketHighlight] - [eoScrollPastEof];
  FEditor.TabWidth := 2;
  FEditor.Gutter.LineNumberPart.Visible := True;
  FEditor.Gutter.CodeFoldPart.Visible := True;
  FEditor.RightEdge := 62;
  FEditor.OnChange := @EditorChange;
  FEditor.OnStatusChange := @EditorStatusChange;
  FNomeFile := '';
  FScheda.Caption := 'Senza nome';
end;

destructor TDocumento.Destroy;
begin
  FHighlighter.Free;
  { FEditor e' posseduto dalla scheda, la scheda dal PC }
  FScheda.Free;
  inherited;
end;

function TDocumento.GetModificato: Boolean;
begin
  Result := FEditor.Modified;
end;

function TDocumento.GetTitolo: String;
begin
  if FNomeFile = '' then
    Result := 'Senza nome'
  else
    Result := ExtractFileName(FNomeFile);
  if Modificato then
    Result := Result + ' *';
end;

procedure TDocumento.EditorChange(Sender: TObject);
begin
  FScheda.Caption := Titolo;
  if Assigned(FOnStato) then
    FOnStato(Self);
end;

procedure TDocumento.EditorStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin
  if Assigned(FOnStato) then
    FOnStato(Self);
end;

procedure TDocumento.ScegliHighlighter;
var
  Ext: String;
begin
  FreeAndNil(FHighlighter);
  Ext := LowerCase(ExtractFileExt(FNomeFile));
  case Ext of
    '.pas', '.pp', '.lpr', '.inc':
      FHighlighter := TSynPasSyn.Create(nil);
    '.c', '.cpp', '.h':
      FHighlighter := TSynCppSyn.Create(nil);
    '.py':
      FHighlighter := TSynPythonSyn.Create(nil);
    '.html', '.htm':
      FHighlighter := TSynHTMLSyn.Create(nil);
    '.js', '.json':
      FHighlighter := TSynJScriptSyn.Create(nil);
    '.sql':
      FHighlighter := TSynSQLSyn.Create(nil);
    '.xml', '.lfm', '.lpi':
      FHighlighter := TSynXMLSyn.Create(nil);
  end;
  FEditor.Highlighter := FHighlighter;
end;

procedure TDocumento.Carica(const NomeFile: String);
begin
  FEditor.Lines.LoadFromFile(NomeFile);
  FNomeFile := NomeFile;
  FEditor.Modified := False;
  ScegliHighlighter;
  FScheda.Caption := Titolo;
  FScheda.Hint := NomeFile;
end;

procedure TDocumento.Salva(const NomeFile: String);
begin
  if NomeFile <> '' then
    FNomeFile := NomeFile;
  if FNomeFile = '' then
    raise Exception.Create('Nome del file mancante');
  FEditor.Lines.SaveToFile(FNomeFile);
  FEditor.Modified := False;
  ScegliHighlighter;
  FScheda.Caption := Titolo;
end;

end.
