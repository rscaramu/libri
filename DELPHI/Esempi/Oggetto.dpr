program Oggetto;

{$APPTYPE CONSOLE}

type
  TCosa = class
  end;

var
  C: TCosa;
begin
  C := TCosa.Create;
  try
    WriteLn(C.ClassName);
    WriteLn(C.ClassType = TCosa);
    WriteLn(C.InstanceSize, ' ', TObject.InstanceSize);
    WriteLn(C.ClassParent.ClassName);
    WriteLn(C is TObject);
  finally
    C.Free;
  end;
end.
