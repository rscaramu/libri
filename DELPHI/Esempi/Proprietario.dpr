program Proprietario;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

type
  TSensore = class(TComponent)
  public
    destructor Destroy; override;
  end;

destructor TSensore.Destroy;
begin
  WriteLn('distruggo ', Name);
  inherited;
end;

var
  Centrale: TComponent;
  S: TSensore;
begin
  Centrale := TComponent.Create(nil);
  try
    S := TSensore.Create(Centrale);
    S.Name := 'Temperatura';
    S := TSensore.Create(Centrale);
    S.Name := 'Umidita';
    S := TSensore.Create(Centrale);
    S.Name := 'Pressione';
    WriteLn(Centrale.ComponentCount, ' componenti');
    WriteLn(Centrale.FindComponent('Umidita') <> nil);
    S.Free;
    WriteLn(Centrale.ComponentCount, ' componenti');
  finally
    Centrale.Free;
  end;
  WriteLn('fine');
end.
