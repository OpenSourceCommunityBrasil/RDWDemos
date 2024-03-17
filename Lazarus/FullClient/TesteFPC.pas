program testerestserver;

uses uRESTDWFphttpBase, uRESTDWdatamodule;

Type
 TServerClass = Class(TServerMethodClass)
 Public
 Published
End;

Var
 ServicePooler : TRESTDWFphttpServicePooler;

begin
 ServicePooler := TRESTDWFphttpServicePooler.Create(Nil);
 Try
  ServicePooler.ServerMethodClass := TServerClass;
  ServicePooler.Active            := True;
 Finally
  WriteLn('Server Online...');
  ReadLn();
 End;
end.
