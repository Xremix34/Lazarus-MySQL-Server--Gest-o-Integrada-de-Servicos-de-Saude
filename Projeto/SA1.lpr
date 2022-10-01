program sa1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Main, consultarInscricao, Departamento, Professor, Login, Curso, Estudante
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TfmMainForm, fmMainForm);
  Application.CreateForm(TFEstudante, FEstudante);
  Application.Run;
end.


