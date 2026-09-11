{ attivita - Manuale completo di Free Pascal e Lazarus }
{ Input di prova (una voce per riga):  aggiungi "Comprare il latte" --priorita=alta --scadenza=2026-09-15 | aggiungi "Leggere il capitolo 32" | aggiungi "Pagare la bolletta" --scadenza=2026-09-01 | elenca | completa 2 | elenca --tutte | statistiche | completa 9 | elimina 3 | elenca | esci }
program attivita;
{$mode objfpc}{$H+}
uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  SysUtils, Classes, CustApp, DateUtils, StrUtils,
  Modello, Persistenza;

type
  TApp = class(TCustomApplication)
  private
    FElenco: TElencoAttivita;
    FFile: String;
    FOggi: TDateTime;
    procedure Esegui(const Argomenti: TStrings);
    procedure CmdAggiungi(const Argomenti: TStrings);
    procedure CmdElenca(const Argomenti: TStrings);
    procedure CmdStatistiche;
    procedure Interattivo;
    procedure Spezza(const Riga: String; Parole: TStrings);
    function Opzione(const Argomenti: TStrings;
                     const Nome, Default: String): String;
    function HaOpzione(const Argomenti: TStrings;
                       const Nome: String): Boolean;
  protected
    procedure DoRun; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

constructor TApp.Create(AOwner: TComponent);
begin
  inherited;
  StopOnException := True;
  FElenco := TElencoAttivita.Create;
  FOggi := EncodeDate(2026, 9, 11);
end;

destructor TApp.Destroy;
begin
  FElenco.Free;
  inherited;
end;

function TApp.Opzione(const Argomenti: TStrings;
                      const Nome, Default: String): String;
var
  S: String;
begin
  Result := Default;
  for S in Argomenti do
    if StartsStr('--' + Nome + '=', S) then
      Exit(Copy(S, Length(Nome) + 4, Length(S)));
end;

function TApp.HaOpzione(const Argomenti: TStrings;
                        const Nome: String): Boolean;
begin
  Result := Argomenti.IndexOf('--' + Nome) >= 0;
end;

procedure TApp.CmdAggiungi(const Argomenti: TStrings);
var
  Titolo, S: String;
  Scad: TDateTime;
  A: TAttivita;
begin
  Titolo := '';
  for S in Argomenti do
    if not StartsStr('--', S) then
      Titolo := Titolo + ' ' + S;
  Scad := DataDaTesto(Opzione(Argomenti, 'scadenza', ''));
  A := FElenco.Aggiungi(Titolo,
         PrioritaDaTesto(Opzione(Argomenti, 'priorita',
                                 'normale')), Scad);
  WriteLn('Aggiunta attivita'' ', A.Id);
end;

procedure TApp.CmdElenca(const Argomenti: TStrings);
var
  L: TListaAttivita;
  A: TAttivita;
  Pri: Integer;
  S, Segno, Scad: String;
begin
  S := Opzione(Argomenti, 'priorita', '');
  if S = '' then
    Pri := -1
  else
    Pri := Ord(PrioritaDaTesto(S));
  L := FElenco.Filtra(not HaOpzione(Argomenti, 'tutte'), Pri);
  try
    if L.Count = 0 then
      WriteLn('Nessuna attivita''.');
    for A in L do
    begin
      if A.Completata then
        Segno := '[x]'
      else if A.Scaduta(FOggi) then
        Segno := '[!]'
      else
        Segno := '[ ]';
      if A.Scadenza = 0 then
        Scad := ''
      else
        Scad := ' entro ' +
                FormatDateTime('dd"/"mm', A.Scadenza);
      WriteLn(Format('%3d %s %-8s %s%s',
        [A.Id, Segno, TestoPriorita(A.Priorita), A.Titolo,
         Scad]));
    end;
  finally
    L.Free;
  end;
end;

procedure TApp.CmdStatistiche;
var
  A: TAttivita;
  Scadute: Integer;
begin
  Scadute := 0;
  for A in FElenco.Elementi do
    if A.Scaduta(FOggi) then
      Inc(Scadute);
  WriteLn('Aperte: ', FElenco.Conta(False),
          '  Completate: ', FElenco.Conta(True),
          '  Scadute: ', Scadute);
end;

procedure TApp.Esegui(const Argomenti: TStrings);
var
  Cmd: String;
  Id: Integer;
begin
  if Argomenti.Count = 0 then
    Exit;
  Cmd := LowerCase(Argomenti[0]);
  Argomenti.Delete(0);
  case Cmd of
    'aggiungi': CmdAggiungi(Argomenti);
    'elenca': CmdElenca(Argomenti);
    'statistiche': CmdStatistiche;
    'completa', 'elimina':
      begin
        if (Argomenti.Count = 0) or
           not TryStrToInt(Argomenti[0], Id) then
          raise EAttivita.Create(
            'Serve il numero dell''attivita''');
        if Cmd = 'completa' then
          FElenco.Completa(Id)
        else
          FElenco.Elimina(Id);
        WriteLn('Fatto.');
      end;
  else
    raise EAttivita.CreateFmt('Comando sconosciuto: %s',
                              [Cmd]);
  end;
  SalvaElenco(FElenco, FFile);
end;

procedure TApp.Spezza(const Riga: String; Parole: TStrings);
var
  I: Integer;
  Corrente: String;
  InVirgolette: Boolean;
begin
  Parole.Clear;
  Corrente := '';
  InVirgolette := False;
  for I := 1 to Length(Riga) do
    case Riga[I] of
      '"': InVirgolette := not InVirgolette;
      ' ': if InVirgolette then
             Corrente := Corrente + ' '
           else if Corrente <> '' then
           begin
             Parole.Add(Corrente);
             Corrente := '';
           end;
    else
      Corrente := Corrente + Riga[I];
    end;
  if Corrente <> '' then
    Parole.Add(Corrente);
end;

procedure TApp.Interattivo;
var
  Riga: String;
  Parole: TStringList;
begin
  Parole := TStringList.Create;
  try
    repeat
      Write('> ');
      ReadLn(Riga);
      Riga := Trim(Riga);
      if SameText(Riga, 'esci') or EOF(Input) then
        Break;
      Spezza(Riga, Parole);
      try
        Esegui(Parole);
      except
        on E: EAttivita do
          WriteLn('Errore: ', E.Message);
      end;
    until False;
  finally
    Parole.Free;
  end;
end;

procedure TApp.DoRun;
var
  Argomenti: TStringList;
  I: Integer;
begin
  Argomenti := TStringList.Create;
  try
    for I := 1 to ParamCount do
      Argomenti.Add(ParamStr(I));
    FFile := Opzione(Argomenti, 'file',
               GetAppConfigDir(False) + 'attivita.json');
    I := 0;
    while I < Argomenti.Count do
      if StartsStr('--file=', Argomenti[I]) then
        Argomenti.Delete(I)
      else
        Inc(I);
    CaricaElenco(FElenco, FFile);
    if Argomenti.Count = 0 then
      Interattivo
    else
      try
        Esegui(Argomenti);
      except
        on E: EAttivita do
        begin
          WriteLn(StdErr, 'Errore: ', E.Message);
          ExitCode := 1;
        end;
      end;
  finally
    Argomenti.Free;
    Terminate;
  end;
end;

var
  App: TApp;
begin
  DeleteFile(GetAppConfigDir(False) + 'attivita.json');
  App := TApp.Create(nil);
  try
    App.Run;
  finally
    App.Free;
  end;
end.
