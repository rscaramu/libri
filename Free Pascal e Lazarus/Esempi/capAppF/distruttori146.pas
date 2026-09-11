{ Distruttori146 - Manuale completo di Free Pascal e Lazarus }
program Distruttori146;
{$mode objfpc}{$H+}
type
  TBase = class
    destructor Destroy; override;
  end;
  TConOverride = class(TBase)
    destructor Destroy; override;
  end;
  TSenzaOverride = class(TBase)
    destructor Destroy; reintroduce;
  end;

destructor TBase.Destroy;
begin
  WriteLn('  TBase.Destroy');
  inherited;
end;

destructor TConOverride.Destroy;
begin
  WriteLn('  TConOverride.Destroy');
  inherited;
end;

destructor TSenzaOverride.Destroy;
begin
  WriteLn('  TSenzaOverride.Destroy');
  inherited;
end;

var
  B: TBase;
begin
  WriteLn('Con override:');
  B := TConOverride.Create;
  B.Free;
  WriteLn('Senza override:');
  B := TSenzaOverride.Create;
  B.Free;
end.
