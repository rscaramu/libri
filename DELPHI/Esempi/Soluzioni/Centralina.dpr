program Centralina;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

type
  TSensore = class(TComponent)
    destructor Destroy; override;
  end;
  TCentralina = class(TComponent)
    constructor Create(AOwner: TComponent); override;
  end;

destructor TSensore.Destroy;
begin
  WriteLn('libero ', Name);
  inherited;
end;

constructor TCentralina.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited;
  for I := 1 to 3 do
    TSensore.Create(Self).Name := 'S' + IntToStr(I);
end;

var
  C: TCentralina;
begin
  C := TCentralina.Create(nil);
  WriteLn(C.ComponentCount);
  C.Free;
  WriteLn('fine');
end.
